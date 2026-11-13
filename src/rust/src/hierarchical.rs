use crate::{createh3::match_resolution, h3::*};
use extendr_api::prelude::*;
use h3o::CellIndex;
use std::iter::FromIterator;

#[extendr]
fn get_parents_(x: List, resolution: u8) -> List {
    let reso = match_resolution(resolution);
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                Robj::from(extendr_api::NULL)
            } else {
                let rent = <&H3>::try_from(&robj).unwrap().index.parent(reso);
                match rent {
                    Some(rent) => Robj::from(H3::from(rent)),
                    None => Robj::from(extendr_api::NULL),
                }
            }
        })
        .collect::<Vec<Robj>>();

    List::from_values(res)
        .set_class(vctrs_class())
        .unwrap()
        .clone()
}

#[extendr]
fn get_children_(x: List, resolution: u8) -> List {
    let reso = match_resolution(resolution);
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                list!().set_class(vctrs_class()).unwrap().clone()
            } else {
                let children = <&H3>::try_from(&robj).unwrap().index.children(reso);
                let r = children.map(|child| H3::from(child)).collect::<Vec<H3>>();
                List::from_values(r)
                    .set_class(vctrs_class())
                    .unwrap()
                    .clone()
            }
        })
        .collect::<Vec<List>>();

    List::from_values(res)
}

#[extendr]
fn get_children_count_(x: List, resolution: u8) -> Vec<i32> {
    let reso = match_resolution(resolution);
    x.into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                i32::MIN
            } else {
                <&H3>::try_from(&robj).unwrap().index.children_count(reso) as i32
            }
        })
        .collect::<Vec<i32>>()
}

#[extendr]
fn get_children_center_(x: List, resolution: u8) -> List {
    let reso = match_resolution(resolution);
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                Robj::from(extendr_api::NULL)
            } else {
                let child = <&H3>::try_from(&robj).unwrap().index.center_child(reso);
                match child {
                    Some(child) => Robj::from(H3::from(child)),
                    None => Robj::from(extendr_api::NULL),
                }
            }
        })
        .collect::<Vec<Robj>>();

    List::from_values(res)
        .set_class(vctrs_class())
        .unwrap()
        .clone()
}

#[extendr]
fn get_children_position_(x: List, resolution: u8) -> Integers {
    let reso = match_resolution(resolution);
    let res = x.into_iter().map(|(_, robj)| {
        let child = <&H3>::try_from(&robj).unwrap().index.child_position(reso);

        match child {
            Some(child) => Rint::from(child as i32),
            None => Rint::na(),
        }
    });

    Integers::from_iter(res)
}

#[extendr]
fn get_children_at_(x: List, position: i32, resolution: u8) -> List {
    let reso = match_resolution(resolution);
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            let child = <&H3>::try_from(&robj)
                .unwrap()
                .index
                .child_at(position as u64, reso);
            match child {
                Some(child) => Robj::from(H3::from(child)),
                None => Robj::from(extendr_api::NULL),
            }
        })
        .collect::<Vec<Robj>>();

    List::from_values(res)
        .set_class(vctrs_class())
        .unwrap()
        .clone()
}

#[extendr]
fn compact_cells_(x: List) -> extendr_api::Result<List> {
    let mut h3_vec = x
        .into_iter()
        .map(|(_, robj)| <&H3>::try_from(&robj).map(|h| h.index))
        .collect::<extendr_api::Result<Vec<CellIndex>>>()?;

    CellIndex::compact(&mut h3_vec).map_err(|e| Error::Other(e.to_string()))?;

    let mut res = List::from_values(h3_vec.into_iter().map(H3::from));
    res.set_class(vctrs_class())?;
    Ok(res)
}

#[extendr]
fn uncompact_cells_(x: List, resolution: u8) -> List {
    let reso = match_resolution(resolution);

    let res = x
        .into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                list!().set_class(vctrs_class()).unwrap().clone()
            } else {
                let uncompacted = CellIndex::uncompact(
                    std::iter::once(<&H3>::try_from(&robj).unwrap().index),
                    reso,
                );
                let res = uncompacted.map(|x| H3::from(x)).collect::<Vec<H3>>();

                List::from_values(res)
                    .set_class(vctrs_class())
                    .unwrap()
                    .clone()
            }
        })
        .collect::<Vec<List>>();

    List::from_values(res)
}

// skipping uncompactCellSize

extendr_module! {
    mod hierarchical;
    fn get_parents_;
    fn get_children_;
    fn get_children_count_;
    fn get_children_center_;
    fn get_children_position_;
    fn get_children_at_;
    fn compact_cells_;
    fn uncompact_cells_;
}
