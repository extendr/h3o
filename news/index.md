# Changelog

## h3o (development version)

## h3o 0.3.0

CRAN release: 2025-08-29

- Now on CRAN
- `"covers"` containment mode is now supported
- `to_cells()` is renamed
  [`sfc_to_cells()`](https://extendr.github.io/h3o/reference/sfc_to_cells.md)
- h3o dependency is bumped to version 0.4.0
- [`sfc_to_cells()`](https://extendr.github.io/h3o/reference/sfc_to_cells.md)
  gets a new argument `containment` based off of the [`ContainmentMode`
  enum](https://docs.rs/h3o/0.4.0/h3o/geom/enum.ContainmentMode.html)

## h3o 0.2.0

- Adds a `wk::wk_handler` function for conversion to sfc, geos, s2, and
  other types that implement the handler.
- New functionality: `to_cells()` to convert an `sfc` object to H3
  cells.
- Refactors Rust code to avoid collecting into `List`s to prevent Stack
  Overflow bug.
- Bumps h3o version to 0.3.5 to get speed and memory enhancements.

## h3o 0.1.0

- Added a `NEWS.md` file to track changes to the package.
