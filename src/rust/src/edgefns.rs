use std::str::FromStr;

use extendr_api::{prelude::*, RMatrix};

use crate::h3::{vctrs_class, H3};
use h3o::DirectedEdgeIndex;

#[extendr]
fn is_nb_pairwise_(x: List, y: List) -> Logicals {
    x.into_iter()
        .zip(y.into_iter())
        .map(|((_, x), (_, y))| {
            if x.is_null() || y.is_null() {
                Rbool::na()
            } else {
                let y = <&H3>::try_from(&y).unwrap().index;
                let x = <&H3>::try_from(&x).unwrap().index;
                let is_nb = x.is_neighbor_with(y);

                match is_nb {
                    Ok(is_nb) => Rbool::from_bool(is_nb),
                    Err(_is_nb) => Rbool::na_value(),
                }
            }
        })
        .collect::<Logicals>()
}

#[extendr]
fn is_nb_sparse_(x: List, y: List) -> List {
    let res = x
        .into_iter()
        .map(|(_, x)| {
            if x.is_null() {
                Logicals::new(1)
            } else {
                let xh3 = <&H3>::try_from(&x).unwrap().index;
                y.iter()
                    .map(|(_, y)| {
                        if y.is_null() {
                            Rbool::na()
                        } else {
                            let xi_yj_nbs =
                                xh3.is_neighbor_with(<&H3>::try_from(&y).unwrap().index);
                            match xi_yj_nbs {
                                Ok(xi_yj_nbs) => Rbool::from_bool(xi_yj_nbs),
                                Err(_xi_yj_nbs) => Rbool::na_value(),
                            }
                        }
                    })
                    .collect::<Logicals>()
            }
        })
        .collect::<Vec<Logicals>>();

    List::from_values(res)
}

#[extendr]
fn h3_edges_pairwise_(x: List, y: List) -> List {
    let res = x
        .into_iter()
        .zip(y.into_iter())
        .map(|((_, x), (_, y))| {
            if x.is_null() || y.is_null() {
                list!().set_class(edge_vctrs()).unwrap().clone().into_robj()
            } else {
                let x = <&H3>::try_from(&x).unwrap().index;
                let y = <&H3>::try_from(&y).unwrap().index;

                let res = x.edge(y);

                match res {
                    Some(res) => Robj::from(H3DEdge { edge: res }),
                    None => extendr_api::NULL.into(),
                }
            }
        })
        .collect::<Vec<Robj>>();

    List::from_values(res)
        .set_class(edge_vctrs())
        .unwrap()
        .clone()
}

#[extendr]
fn h3_edges_sparse_(x: List, y: List) -> List {
    let res = x
        .into_iter()
        .map(|(_, x)| {
            if x.is_null() {
                list!().set_class(edge_vctrs()).unwrap().clone()
            } else {
                let xh3 = <&H3>::try_from(&x).unwrap().index;

                let r = y
                    .iter()
                    .map(|(_, y)| {
                        let yh3 = <&H3>::try_from(&y).unwrap().index;
                        let res = xh3.edge(yh3);
                        match res {
                            Some(res) => Robj::from(H3DEdge { edge: res }),
                            None => extendr_api::NULL.into(),
                        }
                    })
                    .collect::<Vec<Robj>>();
                List::from_values(r)
                    .set_class(edge_vctrs())
                    .unwrap()
                    .clone()
            }
        })
        .collect::<Vec<List>>();

    List::from_values(res)
}

#[extendr]
fn is_valid_edge_(x: Strings) -> Logicals {
    x.into_iter()
        .map(|x| {
            let x_na = x.is_na();
            if !x_na {
                let edge = DirectedEdgeIndex::from_str(x.as_str());
                match edge {
                    Ok(_res) => Rbool::from_bool(true),
                    Err(_res) => Rbool::from_bool(false),
                }
            } else {
                Rbool::na_value()
            }
        })
        .collect::<Logicals>()
}

#[extendr]
fn h3_edge_from_strings_(x: Strings) -> List {
    let res = x
        .into_iter()
        .map(|x| {
            let x_na = x.is_na();
            if !x_na {
                let edge = DirectedEdgeIndex::from_str(x.as_str());
                match edge {
                    Ok(res) => Robj::from(H3DEdge::from(res)),
                    Err(_res) => Robj::from(extendr_api::NULL),
                }
            } else {
                Robj::from(extendr_api::NULL)
            }
        })
        .collect::<Vec<Robj>>();

    List::from_values(res)
        .set_class(edge_vctrs())
        .unwrap()
        .clone()
}

#[extendr]
fn get_directed_origin_(x: List) -> List {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            //Robj::from(H3::from(H3DEdge::from(robj).edge.origin()))
            let res = <&H3DEdge>::try_from(&robj);

            match res {
                Ok(res) => Robj::from(H3::from(res.edge.origin())),
                Err(_) => Robj::from(extendr_api::NULL),
            }
        })
        .collect::<Vec<Robj>>();

    List::from_values(res)
        .set_class(vctrs_class())
        .unwrap()
        .clone()
}

#[extendr]
fn get_directed_destination_(x: List) -> List {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            //Robj::from(H3::from(H3DEdge::from(robj).edge.origin()))
            let res = <&H3DEdge>::try_from(&robj);
            match res {
                Ok(res) => Robj::from(H3::from(res.edge.origin())),
                Err(_) => Robj::from(extendr_api::NULL),
            }
        })
        .collect::<Vec<Robj>>();

    List::from_values(res)
        .set_class(vctrs_class())
        .unwrap()
        .clone()
}

#[extendr]
fn get_directed_cells_(x: List) -> List {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            //Robj::from(H3::from(H3DEdge::from(robj).edge.origin()))
            let res = <&H3DEdge>::try_from(&robj);
            match res {
                Ok(res) => {
                    let cells = res.edge.cells();

                    list!(Robj::from(H3::from(cells.0)), Robj::from(H3::from(cells.1)))
                        .set_attrib("names", ["origin", "destination"])
                        .unwrap()
                        .set_class(vctrs_class())
                        .unwrap()
                        .clone()
                        .into_robj()
                }
                Err(_) => Robj::from(extendr_api::NULL),
            }
        })
        .collect::<Vec<Robj>>();

    List::from_values(res)
}

#[extendr]
fn h3_edges_(x: List) -> List {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            if robj.is_null() {
                list!().set_class(edge_vctrs()).unwrap().clone()
            } else {
                let eds = <&H3>::try_from(&robj).unwrap().index.edges();
                let res = eds.map(|ed| H3DEdge { edge: ed }).collect::<Vec<H3DEdge>>();

                List::from_values(res)
                    .set_class(edge_vctrs())
                    .unwrap()
                    .clone()
            }
        })
        .collect::<Vec<List>>();

    List::from_values(res)
}

#[extendr]
fn edge_boundary_(x: List) -> List {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            let res = <&H3DEdge>::try_from(&robj);
            match res {
                Ok(res) => {
                    let boundary = res.edge.boundary();
                    let coords = boundary
                        .into_iter()
                        .map(|x| [x.lng(), x.lat()])
                        .collect::<Vec<[f64; 2]>>();

                    let mut m = RMatrix::new_matrix(coords.len(), 2, |r, c| coords[r][c]);

                    m.set_class(["XY", "LINESTRING", "sfg"]).unwrap().clone()
                }

                Err(_) => RMatrix::new_matrix(0, 2, |_r, _c| 0)
                    .set_class(["XY", "LINESTRING", "sfg"])
                    .unwrap()
                    .clone(),
            }
        })
        .collect::<Vec<Robj>>();

    List::from_values(res)
}

extendr_module! {
    mod edgefns;
    fn is_nb_pairwise_;
    fn is_nb_sparse_;
    fn h3_edges_pairwise_;
    fn h3_edges_sparse_;
    fn is_valid_edge_;
    fn h3_edge_from_strings_;
    fn get_directed_origin_;
    fn get_directed_destination_;
    fn get_directed_cells_;
    fn h3_edges_;
    fn edge_boundary_;
    fn edges_to_strings;
    fn edge_vctrs;
    impl H3DEdge;
}

// H3DEdge implementation. Defines a struct to be used for directed edges
// a list of H3DEdges is a H3Edge vector.
#[extendr]
#[derive(Debug, Clone, Copy)]
pub struct H3DEdge {
    pub edge: DirectedEdgeIndex,
}

#[extendr]
impl H3DEdge {
    fn new(x: Robj, y: Robj) -> Self {
        let ed = <&H3>::try_from(&x)
            .unwrap()
            .index
            .edge(<&H3>::try_from(&y).unwrap().index)
            .unwrap();
        Self { edge: ed }
    }

    fn to_id(&self) -> String {
        self.edge.to_string()
    }

    fn length(&self, unit: &str) -> f64 {
        match unit {
            "km" => self.edge.length_km(),
            "m" => self.edge.length_m(),
            "rad" => self.edge.length_rads(),
            &_ => self.edge.length_m(),
        }
    }
}

impl From<DirectedEdgeIndex> for H3DEdge {
    fn from(value: DirectedEdgeIndex) -> Self {
        H3DEdge { edge: value }
    }
}

#[extendr]
fn edges_to_strings(x: List) -> Strings {
    let res = x
        .into_iter()
        .map(|(_, robj)| {
            //
            let indx = <&H3DEdge>::try_from(&robj);
            match indx {
                Ok(indx) => Rstr::from_string(&indx.edge.to_string()),
                Err(_) => Rstr::na(),
            }
        })
        .collect::<Vec<Rstr>>();

    Strings::from_values(res)
}

#[extendr]
fn edge_vctrs() -> [String; 3] {
    [
        String::from("H3Edge"),
        String::from("vctrs_vctr"),
        String::from("list"),
    ]
}
