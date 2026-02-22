use crate::h3::H3;
use extendr_api::prelude::*;

#[extendr]
fn area_km2_(x: List) -> Doubles {
    x.into_iter()
        .map(|(_, x)| {
            let cell = <&H3>::try_from(&x);
            match cell {
                Ok(v) => Rfloat::from(v.index.area_km2()),
                Err(_) => Rfloat::na(),
            }
        })
        .collect::<Doubles>()
}

#[extendr]
fn area_m2_(x: List) -> Doubles {
    x.into_iter()
        .map(|(_, x)| {
            let cell = <&H3>::try_from(&x);
            match cell {
                Ok(v) => Rfloat::from(v.index.area_m2()),
                Err(_) => Rfloat::na(),
            }
        })
        .collect::<Doubles>()
}

#[extendr]
fn area_rads2_(x: List) -> Doubles {
    x.into_iter()
        .map(|(_, x)| {
            let cell = <&H3>::try_from(&x);
            match cell {
                Ok(v) => Rfloat::from(v.index.area_rads2()),
                Err(_) => Rfloat::na(),
            }
        })
        .collect::<Doubles>()
}

extendr_module! {
    mod area;
    fn area_km2_;
    fn area_m2_;
    fn area_rads2_;
}
