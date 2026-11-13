# DONE fn get_parents_;
# DONE fn get_children_;
# DONE fn get_children_count_;
# DONE fn get_children_center_;
# DONE fn get_children_position_;
# DONE fn get_children_at_;
# fn compact_cells_;
# fn uncompact_cells_;

#' Hierarchical H3 Grid Functions
#'
#' Functions used to traverse the hierarchy of H3 grids.
#'
#' @param x an `H3` vector.
#' @param resolution a scalar integer representing the grid resolution in the range \[0, 15\].
#' @param position the integer position in the ordered set of cells.
#'
#' @details
#' - `get_parents()`: returns the parent cells for an `H3` vector at a given resolution. Errors if the resolution is smaller than the provided cell.
#' - `get_children()`: returns a list of `H3` vectors containing the children of each H3 cell at a specified resolution. If the resolution is greater than the cell's resolution an empty vector is returned.
#' - `get_children_count()`: returns an integer vector containing the number of children for each cell at the specified resolution.
#' - `get_children_center()`: returns the middle child (center child) for all children of an H3 cell at a specified resolution as an `H3` vector.
#' - `get_children_position()`: returns the position of the observed H3 cell in an ordered list of all children as a child of a higher resolution cell (PR for clearer language welcome).
#' - `get_children_at()`: returns the child of each H3 cell at a specified resolution based on its position in an ordered list (PR for clearer language welcome).
#' @examples
#' h3_strs <- c("841f91dffffffff", "841fb59ffffffff")
#' h3 <- h3_from_strings(h3_strs)
#'
#' get_parents(h3, 3)
#' get_children(h3, 5)
#' get_children_count(h3, 6)
#' get_children_position(h3, 3)
#' get_children_at(h3, 999, 10)
#' @export
#' @rdname hierarchy
#' @returns See details.
get_parents <- function(x, resolution) {
  stopifnot(is_h3(x))
  if (resolution < 0 || resolution > 15) {
    stop("`resolution` must be an integer in range [0, 15]")
  }

  get_parents_(x, resolution)
}

#' @export
#' @rdname hierarchy
get_children <- function(x, resolution) {
  stopifnot(is_h3(x))
  if (resolution < 0 || resolution > 15) {
    stop("`resolution` must be an integer in range [0, 15]")
  }
  get_children_(x, resolution)
}

#' @export
#' @rdname hierarchy
get_children_count <- function(x, resolution) {
  stopifnot(is_h3(x))
  if (resolution < 0 || resolution > 15) {
    stop("`resolution` must be an integer in range [0, 15]")
  }
  get_children_count_(x, resolution)
}

#' @export
#' @rdname hierarchy
get_children_center <- function(x, resolution) {
  stopifnot(is_h3(x))
  if (resolution < 0 || resolution > 15) {
    stop("`resolution` must be an integer in range [0, 15]")
  }
  get_children_center_(x, resolution)
}

#' @export
#' @rdname hierarchy
get_children_position <- function(x, resolution) {
  stopifnot(is_h3(x))
  if (resolution < 0 || resolution > 15) {
    stop("`resolution` must be an integer in range [0, 15]")
  }
  get_children_position_(x, resolution)
}

#' @export
#' @rdname hierarchy
get_children_at <- function(x, position, resolution) {
  stopifnot(is_h3(x))
  if (resolution < 0 || resolution > 15) {
    stop("`resolution` must be an integer in range [0, 15]")
  }
  get_children_at_(x, position, resolution)
}
