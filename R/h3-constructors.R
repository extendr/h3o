
#' Create H3 Index
#'
#' Create H3 indices from `sfc` objects, vectors of x and y coordinates, or H3 string IDs.
#'
#' @param y a numeric vector of latitudes.
#' @param x for `h3_from_points()` an object of class `sfc_POINT`. For `h3_from_strings()` a character vector of H3 index IDs. For `h3_from_xy()` a numeric vector of longitudes.
#' @param resolution an integer indicating the H3 cell resolution. Must be between 0 and 15 inclusive.
#' @examples
#' h3_from_xy(-122, 38, 5)
#'
#' h3_from_strings("85f29383fffffff")
#'
#' if (requireNamespace("sf")) {
#'   # create random points
#'   pnts <- sf::st_cast(
#'     sf::st_sfc(
#'       sf::st_multipoint(matrix(runif(10, max = 90), ncol = 2)),
#'       crs = 4326
#'     ),
#'     "POINT"
#'   )
#'
#'   # convert to H3 objects
#'   h3s <- h3_from_points(pnts, 5)
#'
#'   h3_to_vertexes(h3s)
#'
#'   h3_to_points(h3s)
#' }
#'
#' @details
#' - `h3_from_points()`: takes an `sfc_POINT` object and creates a vector of `H3` cells
#' - `h3_from_strings()`: converts a character vector of cell indexes to an H3 vector
#' - `h3_from_xy()`: converts vectors of `x` and `y` coordinates to an `H3` vector
#' - `h3_to_points()`: converts an `H3` vector to a either an `sfc_POINT` object or a list of `sfg` `POINT` objects.
#' - `h3_to_vertexes()`: converts an `H3` vector to an `sfc_MULTIPOINT` object or a list of `MULTIPOINT` objects.
#' @export
#' @rdname H3
#' @returns 
#' See details.
h3_from_xy <- function(x, y, resolution) {
  if (resolution < 0 || resolution > 15)
    stop("`resolution` must be an integer in range [0, 15]")

  h3_from_xy_(x, y, resolution)
}

#' @export
#' @rdname H3
h3_from_points <- function(x, resolution) {

  if (resolution < 0 || resolution > 15)
    stop("`resolution` must be an integer in range [0, 15]")

  if (!inherits(x, "sfc_POINT"))
    stop("`x` must be an object of class `sfc_POINT`")

  x_crs <- attr(x, "crs")
  x_bbox <- sf::st_bbox(x)

  if (is.na(x_crs)) {
    if (any(abs(x_bbox[c("xmin", "xmax")]) > 180) || any(abs(x_bbox[c("ymin", "ymax")]) > 90)) {
      stop("Input must be in EPSG:4326")
    }  else {
      warning("CRS is missing assuming EPSG:4326")
    }
  }

  h3_from_points_(x, resolution)

}

#' @export
#' @rdname H3
h3_from_strings <- function(x) h3_from_string_(x)


#' @export
#' @rdname H3
h3_to_points <- function(x) {
  stopifnot(is_h3(x))
  res <- h3_to_points_(x)

  # ask user to install sf
  rlang::check_installed("sf")

  if (requireNamespace("sf")) {
    res <- sf::st_sfc(res, crs = 4326)
  }
  res
}

#' @export
#' @rdname H3
h3_to_vertexes <- function(x) {
  stopifnot(is_h3(x))
  res <- h3_to_vertexes_(x)

  # ask user to install sf
  rlang::check_installed("sf")

  if (requireNamespace("sf")) {
    res <- sf::st_sfc(res, crs = 4326)
  }
  res
}
