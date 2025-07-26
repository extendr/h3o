# DONE fn is_nb_pairwise_;
# DONE fn is_nb_sparse_;
# DONE fn h3_edges_pairwise_;
# DONE fn h3_edges_sparse_;
# DONE fn is_valid_edge_;
# DONE fn get_directed_origin_;
# DONE fn get_directed_destination_;
# DONE fn get_directed_cells_;
# DONE fn h3_edges_;
# DONE fn edge_boundary_;

#' H3 index neighbors
#'
#' Test if two H3 cells are neighbors.
#'
#' @param x an `H3` vector.
#' @param y and `H3` vector.
#' @export
#' @rdname is_nb
#' @returns
#' `is_nb_pairwise()` returns a logical vector wheraas `is_nb_sparse()` returns
#' a list with logical vector elements.
#'
#' @examples
#' cells_ids <-c(
#'   "85e22da7fffffff", "85e35ad3fffffff",
#'   "85e22daffffffff", "85e35adbfffffff",
#'   "85e22db7fffffff", "85e35e6bfffffff",
#'   "85e22da3fffffff"
#' )
#'
#' cells <- h3o::h3_from_strings(cells_ids)
#'
#' is_nb_pairwise(cells, rev(cells))
#' is_nb_sparse(cells, cells)
is_nb_pairwise <- function(x, y) {
  stopifnot(is_h3(x), is_h3(y))
  is_nb_pairwise_(x, y)
}

#' @export
#' @rdname is_nb
is_nb_sparse <- function(x, y) {
  is_nb_sparse_(x, y)
}


#' H3 Edges
#'
#' Functions to create or work with `H3Edge` vectors. See `Details` for further details.
#'
#' @param x an H3 vector
#' @param y an H3 vector
#' @param flat default `FALSE`. If `TRUE` return a single vector combining all edges of all H3 cells.
#'
#' @details
#'
#' - `h3_edges()`: returns a list of `H3Edge` vectors for each H3 index.
#' When `flat = TRUE`, returns a single `H3Edge` vector.
#' - `h3_shared_edge_pairwise()`: returns an `H3Edge` vector of shared edges. If
#' there is no shared edge `NA` is returned.
#' - `h3_shared_edge_sparse()`: returns a list of `H3Edge` vectors. Each element
#' iterates through each element of `y` checking for a shared edge.
#' - `is_edge()`: returns `TRUE` if the element inherits the `H3Edge` class.
#' - `is_valid_edge()`: checks each element of a character vector to determine if it is
#' a valid edge ID.
#' - `h3_edges_from_strings()`: create an `H3Edge` vector from a character vector.
#' - `flatten_edges()`: flattens a list of `H3Edge` vectors into a single `H3Edge` vector.
#' - `h3_edge_cells()`: returns a list of length 2 named `H3Edge` vectors of `origin` and `destination` cells
#' - `h3_edge_origin()`: returns a vector of `H3Edge` origin cells
#' - `h3_edge_destination()`: returns a vector of `H3Edge` destination cells
#' @rdname edges
#' @returns
#' See details.
#' @export
#' @examples
#' # create an H3 cell
#' x <- h3_from_xy(-122, 38, 5)
#'
#' # find all edges and flatten
#' edges <- h3_edges(x) |>
#'   flatten_edges()
#'
#' # check if they are all edges
#' is_edge(edges)
#'
#' # check if valid edge strings
#' is_valid_edge(c("115e22da7fffffff", "abcd"))
#'
#' # get the origin cell of the edge
#' h3_edge_origin(edges)
#'
#' # get the destination of the edge
#' h3_edge_destination(edges)
#'
#' # get both origin and destination cells
#' h3_edge_cells(edges)
#'
#' # create edges from strings
#' h3_edges_from_strings(c("115e22da7fffffff", "abcd"))
#'
#' # create a vector of cells
#' cells_ids <-c(
#'   "85e22da7fffffff", "85e35ad3fffffff",
#'   "85e22daffffffff", "85e35adbfffffff",
#'   "85e22da3fffffff"
#' )
#'
#' cells <- h3o::h3_from_strings(cells_ids)
#'
#' # find shared edges between the two pairwise
#' h3_shared_edge_pairwise(cells, rev(cells))
#'
#' # get the sparse shared eddge. Finds all possible shared edges.
#' h3_shared_edge_sparse(cells, cells)
h3_edges <- function(x, flat = FALSE) {
  stopifnot(is_h3(x))
  res <- h3_edges_(x)

  if (flat) {
    res <- structure(
      unlist(res),
      class = edge_vctrs()
    )
  }

  res
}

#' @export
#' @rdname edges
h3_shared_edge_sparse <- function(x, y) {
  stopifnot(is_h3(x), is_h3(y))
  h3_edges_sparse_(x, y)
}

#' @export
#' @rdname edges
h3_shared_edge_pairwise <- function(x, y) {
  stopifnot(is_h3(x), is_h3(y))
  h3_edges_pairwise_(x, y)
}

#' @export
`[[.H3Edge` <- function(x, i, ...) {
  if (length(i) > 1) {
    stop("subscript out of bounds", call. = FALSE)
  }
  structure(
    .subset(x, i),
    class = edge_vctrs()
  )
}

#' @export
format.H3Edge <- function(x, ...) format(edges_to_strings(x), ...)

#' @export
#' @rdname edges
is_edge <- function(x) inherits(x, "H3Edge")


#' @export
#' @rdname edges
is_valid_edge <- function(x) {
  is_valid_edge_(x)
}

#' @export
#' @rdname edges
h3_edges_from_strings <- function(x) {
  h3_edge_from_strings_(x)
}


#' @export
#' @rdname edges
flatten_edges <- function(x) {
  all_classes <- vapply(x, function(x) class(x)[1], character(1))
  if (!identical(unique(all_classes), "H3Edge")) {
    stop("All list elements must be an H3Edge vector")
  }

  x <- unlist(x)
  structure(x, class = edge_vctrs())
}

#' @export
#' @rdname edges
h3_edge_cells <- function(x) {
  stopifnot(is_edge(x))
  get_directed_cells_(x)
}


#' @export
#' @rdname edges
h3_edge_origin <- function(x) {
  stopifnot(is_edge(x))
  get_directed_origin_(x)
}

#' @export
#' @rdname edges
h3_edge_destination <- function(x) {
  stopifnot(is_edge(x))
  get_directed_destination_(x)
}

st_as_sfc.H3Edge <- function(x) {
  sf::st_sfc(edge_boundary_(x), crs = 4326)
}


#' @export
#' @rdname edges
#' @param ... unused.
as.character.H3Edge <- function(x, ...) {
  edges_to_strings(x)
}
