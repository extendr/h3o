#' Grid Traversal
#'
#' Functions used to traverse the H3 grid.
#'
#' @param x an `H3` vector.
#' @param y an `H3` vector.
#' @param k the order of ring neighbors. 0 is the focal location (the observed H3 index). 1 is the immediate neighbors of the H3 index. 2 is the neighbors of the 1st order neighbors and so on.
#' @param safe default `TRUE`. If `FALSE` uses the fast algorithm which can fail.
#'
#' @details
#'
#' - `grid_disk()`: returns the disk of cells for the identified K ring. It is a disk because it returns all cells to create a complete geometry without any holes. See `grid_ring()` if you do not want inclusive neighbors.
#' - `grid_ring()`: returns a K ring of neighbors around the H3 cell.
#' - `grid_distances()`: returns a list of numeric vectors indicating the network distances between neighbors in a K ring. The first element is always 0 as the travel distance to one's self is 0. If the H3 index is missing a 0 length vector will be returned.
#' - `grid_path_cells()`: returns a list of `H3` vectors indicating the cells traversed to get from `x` to `y`. If either `x` or `y` are missing, an empty vector is returned.
#' - `grid_path_cells_size()`: returns an integer vector with the cell path distance between pairwise elements of `x` and `y`. If either x or y are missing the result is `NA`.
#' `grid_distance()`: returns an integer vector with the network distance between pairwise elements of `x` and `y`. If either x or y are missing the result is `NA`. Effectively `grid_path_cells_size() - 1`.
#' - `grid_local_ij()` returns a two column data frame containing the columns `i` and `j` which correspond to the i,j coordinate directions to the destination cell.
#' @examples
#' h3_strs <- c("841f91dffffffff", "841fb59ffffffff")
#' h3 <- h3_from_strings(h3_strs)
#'
#' grid_disk(h3, 1)
#' grid_ring(h3, 2)
#' grid_distances(h3, 2)
#' grid_path_cells(h3, rev(h3))
#' grid_path_cells_size(h3, rev(h3))
#' grid_distance(h3, rev(h3))
#' grid_local_ij(h3, rev(h3))
#' @export
#' @rdname grid
#' @returns
#'
#' See details.
grid_disk <- function(x, k = 1, safe = TRUE) {
  stopifnot(is_h3(x))
  switch(
    as.character(safe),
    "TRUE" = grid_disk_safe_(x, k),
    "FALSE" = grid_disk_fast_(x, k)
  )
}

#' @export
#' @rdname grid
grid_ring <- function(x, k = 1) {
  stopifnot(is_h3(x))
  grid_ring_(x, k)
}

#' @export
#' @rdname grid
grid_distances <- function(x, k = 1) {
  stopifnot(is_h3(x))
  grid_distances_(x, k)
}

#' @export
#' @rdname grid
grid_path_cells <- function(x, y) {
  stopifnot(is_h3(x), is_h3(y))
  grid_path_cells_(x, y)
}

#' @export
#' @rdname grid
grid_path_cells_size <- function(x, y) {
  stopifnot(is_h3(x), is_h3(y))
  grid_path_cells_size_(x, y)
}

#' @export
#' @rdname grid
grid_distance <- function(x, y) {
  stopifnot(is_h3(x), is_h3(y))
  grid_distance_(x, y)
}

#' @export
#' @rdname grid
grid_local_ij <- function(x, y) {
  stopifnot(is_h3(x), is_h3(y))
  as.data.frame(local_ij_(x, y))
}
