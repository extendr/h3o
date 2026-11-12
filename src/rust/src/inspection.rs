use std::str::FromStr;

use crate::h3::*;
use extendr_api::prelude::*;
use h3o::CellIndex;

#[extendr]
/// H3 Inspection Functions
///
/// Functions that provide metadata about H3 indexes.
///
/// @param x an `H3` vector.
///
/// @details
/// - `h3_resolution()`: returns the resolution of each H3 cell.
/// - `h3_base_cell()`: returns the base cell integer.
/// - `is_valid_h3()`: given a vector of H3 index string IDs, determine if they are valid.
/// - `is_res_class_iii()`: determines if an H3 cell has Class III orientation.
/// - `is_pentagon()`: determines if an H3 cell is one of the rare few pentagons.
/// - `get_face_count()`: returns the number of faces that intersect with the H3 index.
///
/// @export
/// @rdname inspection
/// @examples
/// cells_ids <-c(
///     "85e22da7fffffff", "85e35ad3fffffff", 
///     "85e22daffffffff", "85e35adbfffffff", 
///     "85e22db7fffffff", "85e35e6bfffffff",
///     "85e22da3fffffff"
///   ) 
///   
/// cells <- h3o::h3_from_strings(cells_ids)
/// 
/// h3_resolution(cells)
/// h3_base_cell(cells)
/// is_valid_h3(c("85e22db7fffffff", NA, "oopsies"))
/// is_res_class_iii(cells)
/// is_res_class_iii(h3_from_xy(0, 0, 10))
/// is_pentagon(h3_from_strings("08FD600000000000"))
/// get_face_count(cells)
/// @returns
/// See details.
fn h3_resolution(x: List) -> Vec<i32> {
    x.into_iter()
        .map(|(_, x)| {
            if x.is_null() {
                i32::MIN
            } else {
                let idx = <&H3>::try_from(&x);
                match idx {
                    Ok(idx) => idx.index.resolution() as i32,
                    Err(_) => i32::MIN,
                }
            }
        })
        .collect::<Vec<i32>>()
}

#[extendr]
/// @export
/// @rdname inspection
fn h3_base_cell(x: List) -> Vec<i32> {
    x.into_iter()
        .map(|(_, x)| {
            if x.is_null() {
                i32::MIN
            } else {
                let cell = <&H3>::try_from(&x);
                match cell {
                    Ok(cell) => u8::from(cell.index.base_cell()) as i32,
                    Err(_) => i32::MIN,
                }
            }
        })
        .collect::<Vec<i32>>()
}

// scalar implementation
fn is_valid_h3_(x: &str) -> bool {
    let mb = CellIndex::from_str(x);
    match mb {
        Ok(_mb) => true,
        Err(_mb) => false,
    }
}

#[extendr]
/// @export
/// @rdname inspection
fn is_valid_h3(x: Strings) -> Logicals {
    x.into_iter()
        .map(|x| {
            if x.is_na() {
                return Rbool::na()
            }

            Rbool::from(is_valid_h3_(x.as_ref()))
        })
        .collect::<Logicals>()
}

#[extendr]
/// @export
/// @rdname inspection
fn is_res_class_iii(x: List) -> Logicals {
    x.into_iter()
        .map(|(_, x)| {
            let cell = <&H3>::try_from(&x);

            match cell {
                Ok(cell) => Rbool::from_bool(cell.index.resolution().is_class3()),
                Err(_) => Rbool::na(),
            }
        })
        .collect::<Logicals>()
}

#[extendr]
/// @export
/// @rdname inspection
fn is_pentagon(x: List) -> Logicals {
    x.into_iter()
        .map(|(_, x)| {
            let cell = <&H3>::try_from(&x);

            match cell {
                Ok(cell) => Rbool::from_bool(cell.index.is_pentagon()),
                Err(_) => Rbool::na(),
            }
        })
        .collect::<Logicals>()
}

// skip CellIndex::icosahedron_faces
#[extendr]
/// @export
/// @rdname inspection
fn get_face_count(x: List) -> Integers {
    x.into_iter()
        .map(|(_, x)| {
            let cell = <&H3>::try_from(&x);

            match cell {
                Ok(cell) => Rint::from(cell.index.max_face_count() as i32),
                Err(_) => Rint::na(),
            }
        })
        .collect::<Integers>()
}

extendr_module! {
    mod inspection;
    fn h3_resolution;
    fn h3_base_cell;
    fn is_valid_h3;
    fn is_res_class_iii;
    fn is_pentagon;
    fn get_face_count;
}
