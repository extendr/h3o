# Compact H3 Cells

Reduce a set of H3 indices of the same resolution to the minimum number
of H3 indices of varying resolution that entirely covers the input area.

## Usage

``` r
compact_cells(x)

uncompact_cells(x, resolution)
```

## Arguments

- x:

  a vector of H3 indexes.

- resolution:

  a scalar integer representing the grid resolution in the range \[0,
  15\].

## Value

An `H3` vector.

## Examples

``` r
x <- h3_from_strings("841f91dffffffff")
y <- uncompact_cells(x, 5)[[1]]
z <- compact_cells(y)
all.equal(x, z)
#> [1] TRUE
```
