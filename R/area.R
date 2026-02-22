#' Calculate Area of H3 Cells
#'
#' @description
#'
#' These functions calculate the area of H3 cells for a given unit.
#'
#' - `area_km2()` calculates the area in kilometers squared
#' - `area_m2()` calculates the area in meters squared
#' - `area_rads2()` calculates the area in radians squared
#'
#' @returns a numeric vector the same length as `x`
#' @inheritParams is_h3
#' @rdname area
#' @export
#' @examples
#' nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#' geo <- sf::st_geometry(nc)
#' cells <- sfc_to_cells(geo, 5) |>
#'   flatten_h3()
#'
#' head(area_km2(cells))
#' head(area_m2(cells))
#' head(area_rads2(cells))
area_km2 <- function(x) {
  stopifnot(is_h3(x))
  area_km2_(x)
}

#' @rdname area
#' @export
area_m2 <- function(x) {
  stopifnot(is_h3(x))
  area_m2_(x)
}

#' @rdname area
#' @export
area_rads2 <- function(x) {
  stopifnot(is_h3(x))
  area_rads2_(x)
}
