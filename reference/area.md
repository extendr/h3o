# Calculate Area of H3 Cells

These functions calculate the area of H3 cells for a given unit.

- `area_km2()` calculates the area in kilometers squared

- `area_m2()` calculates the area in meters squared

- `area_rads2()` calculates the area in radians squared

## Usage

``` r
area_km2(x)

area_m2(x)

area_rads2(x)
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

## Value

a numeric vector the same length as `x`

## Examples

``` r
nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
geo <- sf::st_geometry(nc)
cells <- sfc_to_cells(geo, 5) |>
  flatten_h3()

head(area_km2(cells))
#> [1] 230.8037 231.5341 231.3662 230.6341 231.1934 231.7500
head(area_m2(cells))
#> [1] 230803680 231534107 231366169 230634132 231193430 231749967
head(area_rads2(cells))
#> [1] 5.686258e-06 5.704253e-06 5.700116e-06 5.682081e-06 5.695860e-06
#> [6] 5.709571e-06
```
