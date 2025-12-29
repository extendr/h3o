# Convert sf geometry to H3 Cells

Given a vector of sf geometries (class `sfc`) create a list of `H3`
vectors. Each list element contains the vector of H3 cells that cover
the geometry.

## Usage

``` r
sfc_to_cells(x, resolution, containment = "intersect")
```

## Arguments

- x:

  for
  [`h3_from_points()`](https://extendr.github.io/h3o/reference/H3.md) an
  object of class `sfc_POINT`. For
  [`h3_from_strings()`](https://extendr.github.io/h3o/reference/H3.md) a
  character vector of H3 index IDs. For
  [`h3_from_xy()`](https://extendr.github.io/h3o/reference/H3.md) a
  numeric vector of longitudes.

- resolution:

  an integer indicating the H3 cell resolution. Must be between 0 and 15
  inclusive.

- containment:

  character. Strategy for selecting H3 cells. Must be one of
  `"intersect"` (Default), `"centroid"`, `"boundary"`, or `"covers"`.
  See details.

## Value

An H3 vector.

## Details

Note, use
[`flatten_h3()`](https://extendr.github.io/h3o/reference/H3.md) to
reduce the list to a single vector.

The selection of H3 cells is determined by the [**Containment
Mode**](https://docs.rs/h3o/0.4.0/h3o/geom/enum.ContainmentMode.html):

- `"centroid"`: Returns cells whose center point (centroid) falls inside
  the geometry. This is the fastest method but may leave edges of the
  geometry uncovered.

- `"boundary"`: Returns only cells that are completely contained within
  the geometry. This often leaves the outer perimeter of the geometry
  uncovered.

- `"intersect"`: (Default) Returns any cell that touches the geometry
  (including boundary intersections). This ensures the entire geometry
  is covered, but may include cells that are only partially overlapped.

- `"covers"`: An extension of `"intersect"`. Use this when dealing with
  very small geometries. While `"intersect"` captures cells that touch
  the geometry's boundary, `"covers"` ensures that if a geometry is so
  small that it sits entirely inside a single cell (without touching the
  cell's edges), that covering cell is still returned.

## Examples

``` r
if (interactive() && rlang::is_installed("sf")) {
  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
  geo <- sf::st_geometry(nc)
  cells <- sfc_to_cells(geo, 5)

  head(cells)

  plot(flatten_h3(cells))
}
```
