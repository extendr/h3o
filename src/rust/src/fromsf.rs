use extendr_api::prelude::*;

use geo_traits::to_geo::ToGeoGeometry;
use sfconversions::sfg::Sfg;
use h3o::geom::ToCells;
use h3o::geom::{PolyfillConfig, ContainmentMode};

// internal deps
use crate::createh3::match_resolution;
use crate::h3::*;

use rayon::prelude::*;
use geo_types::Geometry;

fn geometry_to_cells(x: Geometry, containment: PolyfillConfig) -> Vec<H3> {
    let h3geo = h3o::geom::Geometry::from_degrees(x)
        .unwrap();

    h3geo
        .to_cells(containment)
        .map(H3::from)
        .collect::<Vec<_>>()
}

#[extendr]
fn sfc_to_cells_(x: List, resolution: i32, containment: &str) -> extendr_api::Result<List> {

    let resolution = match_resolution(resolution as u8);

    let containment_strategy = match containment {
        "boundary" => ContainmentMode::ContainsBoundary,
        "centroid" => ContainmentMode::ContainsCentroid,
        "intersect" => ContainmentMode::IntersectsBoundary,
        "covers" => ContainmentMode::Covers,
        _ => ContainmentMode::ContainsBoundary
    };

    let poly_config = PolyfillConfig::new(resolution)
        .containment_mode(containment_strategy);

    // R objects aren't Send, so convert to geo-types serially first.
    let x = x
        .into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                Ok(None)
            } else {
                Sfg::try_from(robj).map(|sfg| Some(sfg.to_geometry()))
            }
        })
        .collect::<extendr_api::Result<Vec<Option<Geometry>>>>()?;

    let res = x.into_par_iter()
        .with_min_len(4096)
        .map(|xi| {
            match xi {
                Some(xi) => geometry_to_cells(xi, poly_config),
                None => vec![]
            }
        })
        .collect::<Vec<Vec<H3>>>();

    let res = res.into_iter().map(|xi| {
        List::from_values(xi).set_class(vctrs_class()).unwrap().clone()
    })
    .collect::<Vec<List>>();

    Ok(List::from_values(res))
}

extendr_module! {
    mod fromsf;
    // fn sfg_to_cells;
    fn sfc_to_cells_;
}
