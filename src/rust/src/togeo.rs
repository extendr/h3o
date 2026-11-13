use extendr_api::prelude::*;
use h3o::{geom::SolventBuilder, CellIndex, LatLng};

use crate::h3::*;

use sfconversions::sfg::{SfgMultiPoint, SfgMultiPolygon};

#[extendr]
fn h3_to_geo_(x: List) -> extendr_api::Result<Robj> {
    let h3_vec = x
        .into_iter()
        .map(|(_, x)| <&H3>::try_from(&x).map(|h| h.index))
        .collect::<extendr_api::Result<Vec<CellIndex>>>()?;
    let res = SolventBuilder::new()
        .build()
        .dissolve(h3_vec)
        .map_err(|e| Error::Other(e.to_string()))?;
    Ok(Robj::from(SfgMultiPolygon::from(res)))
}

#[extendr]
fn h3_to_points_(x: List) -> List {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            let idx = <&H3>::try_from(&robj);

            let mut res = match idx {
                Ok(idx) => {
                    let ll = LatLng::try_from(idx.index).unwrap();
                    let arr = [Rfloat::from(ll.lng()), Rfloat::from(ll.lat())];
                    Doubles::from_values(arr)
                }
                Err(_) => Doubles::from_values([Rfloat::na(), Rfloat::na()]),
            };

            res.set_class(["XY", "POINT", "sfg"]).unwrap().clone()
        })
        .collect::<Vec<Doubles>>();

    List::from_values(res)
}

#[extendr]
fn h3_to_vertexes_(x: List) -> extendr_api::Result<List> {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                let mut empty = Robj::from(RMatrix::new_matrix(0, 2, |_r, _c| 0));
                empty.set_class(["XY", "MULTIPOINT", "sfg"])?;
                Ok(empty)
            } else {
                let ps = <&H3>::try_from(&robj)?
                    .index
                    .vertexes()
                    .map(geo_types::Point::from)
                    .collect::<Vec<geo_types::Point>>();
                let mp = geo_types::MultiPoint::new(ps);
                Ok(Robj::from(SfgMultiPoint::from(mp)))
            }
        })
        .collect::<extendr_api::Result<Vec<Robj>>>()?;

    Ok(List::from_values(res))
}

extendr_module! {
    mod togeo;
    fn h3_to_geo_;
    fn h3_to_points_;
    fn h3_to_vertexes_;
}
