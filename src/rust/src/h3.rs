use extendr_api::prelude::*;

use h3o::CellIndex;

#[extendr]
#[derive(Debug, Clone, Copy)]
pub struct H3 {
    pub index: CellIndex,
}

#[extendr]
impl H3 {}

impl From<CellIndex> for H3 {
    fn from(index: CellIndex) -> Self {
        H3 { index: index }
    }
}

// returns an array of strings with the appropriate vctrs class
#[extendr]
pub fn vctrs_class() -> [String; 3] {
    [
        String::from("H3"),
        String::from("vctrs_vctr"),
        String::from("list"),
    ]
}

#[extendr]
fn h3_to_strings(x: List) -> Strings {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            //
            let indx = <&H3>::try_from(&robj);
            match indx {
                Ok(indx) => Rstr::from_string(&indx.index.to_string()),
                Err(_) => Rstr::na(),
            }
        })
        .collect::<Vec<Rstr>>();

    Strings::from_values(res)
}
extendr_module! {
    mod h3;
    fn h3_to_strings;
    fn vctrs_class;
}
