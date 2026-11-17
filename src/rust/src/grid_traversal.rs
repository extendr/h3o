use crate::h3::*;
use extendr_api::prelude::*;

#[extendr]
fn grid_disk_fast_(x: List, k: u32) -> List {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                list!().set_class(vctrs_class()).unwrap().clone()
            } else {
                let ind = <&H3>::try_from(&robj).unwrap().index;
                let res = ind
                    .grid_disk_fast(k)
                    .map(|x|
                        // can be null sometimes
                        // if it messed up catch it and return null
                        match x {
                            Some(x) => Robj::from(H3::from(x)),
                            None => Robj::from(extendr_api::NULL)
                        })
                    .collect::<Vec<Robj>>();

                List::from_values(res)
                    .set_class(crate::h3::vctrs_class())
                    .unwrap()
                    .clone()
            }
        })
        .collect::<Vec<List>>();

    List::from_values(res)
}

#[extendr]
fn grid_disk_safe_(x: List, k: u32) -> List {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                list!().set_class(vctrs_class()).unwrap().clone()
            } else {
                let ind = <&H3>::try_from(&robj).unwrap().index;
                let res = ind
                    .grid_disk_safe(k)
                    .map(|x| H3::from(x))
                    .collect::<Vec<H3>>();

                List::from_values(res)
                    .set_class(vctrs_class())
                    .unwrap()
                    .clone()
            }
        })
        .collect::<Vec<List>>();

    List::from_values(res)
}

#[extendr]
fn grid_distances_(x: List, k: u32) -> List {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                let vc: Vec<u32> = Vec::with_capacity(0);
                vc
            } else {
                let ind = <&H3>::try_from(&robj).unwrap().index;
                ind.grid_disk_distances::<Vec<_>>(k)
                    .into_iter()
                    .map(|(_, dist)| dist)
                    .collect::<Vec<u32>>()
            }
        })
        .collect::<Vec<Vec<u32>>>();

    List::from_values(res)
}

#[extendr]
fn grid_ring_(x: List, k: u32) -> List {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                list!().set_class(vctrs_class()).unwrap().clone()
            } else {
                let r = <&H3>::try_from(&robj)
                    .unwrap()
                    .index
                    .grid_ring_fast(k)
                    .map(|x| {
                        // can be null sometimes
                        // if it messed up catch it and return null
                        match x {
                            Some(x) => Robj::from(H3::from(x)),
                            None => Robj::from(extendr_api::NULL),
                        }
                    })
                    .collect::<Vec<Robj>>();

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
fn grid_path_cells_(x: List, y: List) -> List {
    let res = x
        .into_iter()
        .zip(y.into_iter())
        .map(|((_, x), (_, y))| {
            if x.is_null() || y.is_null() {
                list!().set_class(vctrs_class()).unwrap().clone()
            } else {
                let x = <&H3>::try_from(&x).unwrap().index;
                let y = <&H3>::try_from(&y).unwrap().index;
                let path = x.grid_path_cells(y);
                let mut path = match path {
                    Ok(path) => {
                        let r = path
                            .into_iter()
                            .map(|x| match x {
                                Ok(x) => Robj::from(H3::from(x)),
                                Err(_x) => Robj::from(extendr_api::NULL),
                            })
                            .collect::<Vec<Robj>>();

                        List::from_values(r)
                    }
                    // idk if this is the right way to handle it
                    Err(_path) => list!(),
                };

                path.set_class(vctrs_class()).unwrap().clone()
            }
        })
        .collect::<Vec<List>>();

    List::from_values(res)
}

#[extendr]
fn grid_path_cells_size_(x: List, y: List) -> Integers {
    x.into_iter()
        .zip(y.into_iter())
        .map(|((_, x), (_, y))| {
            if x.is_null() || y.is_null() {
                Rint::na()
            } else {
                let x = <&H3>::try_from(&x).unwrap().index;
                let y = <&H3>::try_from(&y).unwrap().index;
                let size = x.grid_path_cells_size(y);

                match size {
                    Ok(size) => Rint::from(size),
                    Err(_size) => Rint::na(),
                }
            }
        })
        .collect::<Integers>()
}

#[extendr]
fn grid_distance_(x: List, y: List) -> Integers {
    x.into_iter()
        .zip(y.into_iter())
        .map(|((_, x), (_, y))| {
            if x.is_null() || y.is_null() {
                Rint::na()
            } else {
                let d = <&H3>::try_from(&x)
                    .unwrap()
                    .index
                    .grid_distance(<&H3>::try_from(&y).unwrap().index);

                match d {
                    Ok(d) => Rint::from(d),
                    Err(_) => Rint::na(),
                }
            }
        })
        .collect::<Integers>()
}

#[extendr]
// x is anchor
// y is origin
fn local_ij_(x: List, y: List) -> List {
    let (i, j): (Vec<i32>, Vec<i32>) = x
        .into_iter()
        .zip(y.into_iter())
        .map(|((_, x), (_, y))| {
            if x.is_null() || y.is_null() {
                (i32::MIN, i32::MIN)
            } else {
                let x = <&H3>::try_from(&x).unwrap().index;
                let y = <&H3>::try_from(&y).unwrap().index;

                let res = x.to_local_ij(y);
                match res {
                    Ok(res) => {
                        let c = res.coord;
                        (c.i, c.j)
                    }
                    Err(_) => (i32::MIN, i32::MIN),
                }
            }
        })
        .unzip();
    list!(i = i, j = j)
}

extendr_module! {
    mod grid_traversal;
    fn grid_disk_fast_;
    fn grid_disk_safe_;
    fn grid_distances_;
    fn grid_ring_;
    fn grid_path_cells_;
    fn grid_path_cells_size_;
    fn grid_distance_;
    fn local_ij_;
}
