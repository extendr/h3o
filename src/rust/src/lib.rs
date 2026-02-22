use extendr_api::prelude::*;

mod area;
mod createh3;
mod edgefns;
mod fromsf;
mod grid_traversal;
mod h3;
mod hierarchical;
mod inspection;
mod togeo;

extendr_module! {
    mod h3o;
    use createh3;
    use h3;
    use fromsf;
    use inspection;
    use hierarchical;
    use togeo;
    use edgefns;
    use grid_traversal;
    use area;
}
