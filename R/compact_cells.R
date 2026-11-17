#' Compact H3 Cells
#'
#' Reduce a set of H3 indices of the same resolution to the minimum number of H3 indices of
#' varying resolution that entirely covers the input area.
#'
#' @param x a vector of H3 indexes.
#' @param resolution a scalar integer representing the grid resolution in the range \[0, 15\].
#' @export
#' @examples
#' x <- h3_from_strings("841f91dffffffff")
#' y <- uncompact_cells(x, 5)[[1]]
#' z <- compact_cells(y)
#' all.equal(x, z)
#' @returns
#' An `H3` vector.
compact_cells <- function(x) {
  stopifnot(is_h3(x))
  compact_cells_(stats::na.omit(unique(x)))
}

#' @export
#' @rdname compact_cells
uncompact_cells <- function(x, resolution) {
  stopifnot(is_h3(x))
  if (resolution < 0 || resolution > 15) {
    stop("`resolution` must be an integer in range [0, 15]")
  }
  uncompact_cells_(x, resolution)
}
