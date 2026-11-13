use extendr_api::prelude::*;

use geo_traits::to_geo::{ToGeoMultiPolygon, ToGeoPolygon};
use geo_types::Polygon;
use h3o::geom::{ContainmentMode, TilerBuilder};
use h3o::{CellIndex, Resolution};
use rayon::prelude::*;
use sfconversions::sfg::{SfgMultiPolygon, SfgPolygon};

use crate::h3::*;

fn sfg_to_polygons(x: Robj) -> extendr_api::Result<Vec<Polygon>> {
    if x.inherits("POLYGON") {
        Ok(vec![SfgPolygon::try_from(x)?.to_polygon()])
    } else if x.inherits("MULTIPOLYGON") {
        Ok(SfgMultiPolygon::try_from(x)?.to_multi_polygon().0)
    } else {
        Err(Error::Other(
            "Expected an sfg POLYGON or MULTIPOLYGON.".to_string(),
        ))
    }
}

fn polygons_to_cells(
    polygons: Vec<Polygon>,
    resolution: Resolution,
    containment: ContainmentMode,
) -> std::result::Result<Vec<CellIndex>, h3o::error::InvalidGeometry> {
    let mut cells = Vec::new();
    for polygon in polygons {
        let mut tiler = TilerBuilder::new(resolution)
            .containment_mode(containment)
            .build();
        tiler.add(polygon)?;
        cells.extend(tiler.into_coverage());
    }
    Ok(cells)
}

#[extendr]
fn sfc_to_cells_(x: List, resolution: i32, containment: &str) -> extendr_api::Result<List> {
    let resolution =
        Resolution::try_from(resolution as u8).map_err(|e| Error::Other(e.to_string()))?;

    let containment_strategy = match containment {
        "boundary" => ContainmentMode::ContainsBoundary,
        "centroid" => ContainmentMode::ContainsCentroid,
        "intersect" => ContainmentMode::IntersectsBoundary,
        "covers" => ContainmentMode::Covers,
        _ => ContainmentMode::ContainsBoundary,
    };

    // R objects aren't Send, so convert to geo-types serially first.
    let x = x
        .into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                Ok(Vec::new())
            } else {
                sfg_to_polygons(robj)
            }
        })
        .collect::<extendr_api::Result<Vec<Vec<Polygon>>>>()?;

    let res = x
        .into_par_iter()
        .with_min_len(4096)
        .map(|polygons| polygons_to_cells(polygons, resolution, containment_strategy))
        .collect::<std::result::Result<Vec<Vec<CellIndex>>, _>>()
        .map_err(|e| Error::Other(e.to_string()))?;

    let res = res
        .into_iter()
        .map(|cells| {
            let mut cells = List::from_values(cells.into_iter().map(H3::from));
            cells.set_class(vctrs_class())?;
            Ok(cells)
        })
        .collect::<extendr_api::Result<Vec<List>>>()?;

    Ok(List::from_values(res))
}

extendr_module! {
    mod fromsf;
    // fn sfg_to_cells;
    fn sfc_to_cells_;
}
