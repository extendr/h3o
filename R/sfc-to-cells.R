#' Convert sf geometry to H3 Cells
#'
#' Given a vector of sf geometries (class `sfc`) create a list of `H3` vectors.
#' Each list element contains the vector of H3 cells that cover the geometry.
#'
#' Note, use `flatten_h3()` to reduce the list to a single vector.
#'
#' @inheritParams h3_from_points
#' @param containment character. Strategy for selecting H3 cells. Must be one of
#'   `"intersect"` (Default), `"centroid"`, `"boundary"`, or `"covers"`. See details.
#'
#' @details
#' The selection of H3 cells is determined by the [**Containment Mode**](https://docs.rs/h3o/0.4.0/h3o/geom/enum.ContainmentMode.html):
#'
#' - `"centroid"`: Returns cells whose center point (centroid) falls inside the
#'   geometry. This is the fastest method but may leave edges of the geometry
#'   uncovered.
#' - `"boundary"`: Returns only cells that are completely contained within the
#'   geometry. This often leaves the outer perimeter of the geometry uncovered.
#' - `"intersect"`: (Default) Returns any cell that touches the geometry (including
#'   boundary intersections). This ensures the entire geometry is covered,
#'   but may include cells that are only partially overlapped.
#' - `"covers"`: An extension of `"intersect"`. Use this when dealing with
#'   very small geometries. While `"intersect"` captures cells that touch the
#'   geometry's boundary, `"covers"` ensures that if a geometry is so small
#'   that it sits entirely inside a single cell (without touching the cell's
#'   edges), that covering cell is still returned.
#'
#' @examples
#' if (interactive() && rlang::is_installed("sf")) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   geo <- sf::st_geometry(nc)
#'   cells <- sfc_to_cells(geo, 5)
#'
#'   head(cells)
#'
#'   plot(flatten_h3(cells))
#' }
#'
#' @export
#' @returns An H3 vector.
sfc_to_cells <- function(x, resolution, containment = "intersect") {
  match.arg(containment, c("intersect", "centroid", "boundary", "covers"))
  if (!inherits(x, c("sfc_POLYGON", "sfc_MULTIPOLYGON"))) {
    rlang::abort("`x` must be of class `sfc_POLYGON` or `sfc_MULTIPOLYGON`")
  } else if (!(resolution >= 0 && resolution <= 15)) {
    rlang::abort("`resolution` must be between 0 and 15 inclusive")
  } else if (rlang::is_installed("sf")) {
    # additional check for degrees if sf is installed
    units <- sf::st_crs(x)$units_gdal

    if (is.na(units)) {
      rlang::warn("`x` has missing units. Cannot confirm if degrees are used.")
    } else if (units != "degree") {
      rlang::abort("`x` must have a CRS using degrees such as EPSG:4326.")
    }
  }
  sfc_to_cells_(x, resolution, containment)
}
