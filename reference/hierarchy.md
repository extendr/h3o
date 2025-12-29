# Hierarchical H3 Grid Functions

Functions used to traverse the hierarchy of H3 grids.

## Usage

``` r
get_parents(x, resolution)

get_children(x, resolution)

get_children_count(x, resolution)

get_children_center(x, resolution)

get_children_position(x, resolution)

get_children_at(x, position, resolution)
```

## Arguments

- x:

  an `H3` vector.

- resolution:

  a scalar integer representing the grid resolution in the range \[0,
  15\].

- position:

  the integer position in the ordered set of cells.

## Value

See details.

## Details

- `get_parents()`: returns the parent cells for an `H3` vector at a
  given resolution. Errors if the resolution is smaller than the
  provided cell.

- `get_children()`: returns a list of `H3` vectors containing the
  children of each H3 cell at a specified resolution. If the resolution
  is greater than the cell's resolution an empty vector is returned.

- `get_children_count()`: returns an integer vector containing the
  number of children for each cell at the specified resolution.

- `get_children_center()`: returns the middle child (center child) for
  all children of an H3 cell at a specified resolution as an `H3`
  vector.

- `get_children_position()`: returns the position of the observed H3
  cell in an ordered list of all children as a child of a higher
  resolution cell (PR for clearer language welcome).

- `get_children_at()`: returns the child of each H3 cell at a specified
  resolution based on its position in an ordered list (PR for clearer
  language welcome).

## Examples

``` r
h3_strs <- c("841f91dffffffff", "841fb59ffffffff")
h3 <- h3_from_strings(h3_strs)

get_parents(h3, 3)
#> <H3[2]>
#> [1] 831f91fffffffff 831fb5fffffffff
get_children(h3, 5)
#> [[1]]
#> <H3[7]>
#> [1] 851f91c3fffffff 851f91c7fffffff 851f91cbfffffff 851f91cffffffff
#> [5] 851f91d3fffffff 851f91d7fffffff 851f91dbfffffff
#> 
#> [[2]]
#> <H3[7]>
#> [1] 851fb583fffffff 851fb587fffffff 851fb58bfffffff 851fb58ffffffff
#> [5] 851fb593fffffff 851fb597fffffff 851fb59bfffffff
#> 
get_children_count(h3, 6)
#> [1] 49 49
get_children_position(h3, 3)
#> [1] 6 4
get_children_at(h3, 999, 10)
#> <H3[2]>
#> [1] 8a1f91c02caffff 8a1fb5802caffff
```
