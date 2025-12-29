# Grid Traversal

Functions used to traverse the H3 grid.

## Usage

``` r
grid_disk(x, k = 1, safe = TRUE)

grid_ring(x, k = 1)

grid_distances(x, k = 1)

grid_path_cells(x, y)

grid_path_cells_size(x, y)

grid_distance(x, y)

grid_local_ij(x, y)
```

## Arguments

- x:

  an `H3` vector.

- k:

  the order of ring neighbors. 0 is the focal location (the observed H3
  index). 1 is the immediate neighbors of the H3 index. 2 is the
  neighbors of the 1st order neighbors and so on.

- safe:

  default `TRUE`. If `FALSE` uses the fast algorithm which can fail.

- y:

  an `H3` vector.

## Value

See details.

## Details

- `grid_disk()`: returns the disk of cells for the identified K ring. It
  is a disk because it returns all cells to create a complete geometry
  without any holes. See `grid_ring()` if you do not want inclusive
  neighbors.

- `grid_ring()`: returns a K ring of neighbors around the H3 cell.

- `grid_distances()`: returns a list of numeric vectors indicating the
  network distances between neighbors in a K ring. The first element is
  always 0 as the travel distance to one's self is 0. If the H3 index is
  missing a 0 length vector will be returned.

- `grid_path_cells()`: returns a list of `H3` vectors indicating the
  cells traversed to get from `x` to `y`. If either `x` or `y` are
  missing, an empty vector is returned.

- `grid_path_cells_size()`: returns an integer vector with the cell path
  distance between pairwise elements of `x` and `y`. If either x or y
  are missing the result is `NA`. `grid_distance()`: returns an integer
  vector with the network distance between pairwise elements of `x` and
  `y`. If either x or y are missing the result is `NA`. Effectively
  `grid_path_cells_size() - 1`.

- `grid_local_ij()` returns a two column data frame containing the
  columns `i` and `j` which correspond to the i,j coordinate directions
  to the destination cell.

## Examples

``` r
h3_strs <- c("841f91dffffffff", "841fb59ffffffff")
h3 <- h3_from_strings(h3_strs)

grid_disk(h3, 1)
#> [[1]]
#> <H3[7]>
#> [1] 841f91dffffffff 841f903ffffffff 841f915ffffffff 841f911ffffffff
#> [5] 841f919ffffffff 841f957ffffffff 841f90bffffffff
#> 
#> [[2]]
#> <H3[7]>
#> [1] 841fb59ffffffff 841fb5dffffffff 841fb51ffffffff 841fb5bffffffff
#> [5] 841fa65ffffffff 841949bffffffff 8419493ffffffff
#> 
grid_ring(h3, 2)
#> [[1]]
#> <H3[12]>
#>  [1] 841f951ffffffff 841f955ffffffff 841f909ffffffff 841f901ffffffff
#>  [5] 841f907ffffffff 841f939ffffffff 841f93bffffffff 841f917ffffffff
#>  [9] 841f913ffffffff 841f91bffffffff 841f825ffffffff 841f953ffffffff
#> 
#> [[2]]
#> <H3[12]>
#>  [1] 8419499ffffffff 8419491ffffffff 8419497ffffffff 841fb4bffffffff
#>  [5] 841fb43ffffffff 841fb55ffffffff 841fb57ffffffff 841fb53ffffffff
#>  [9] 841fa2dffffffff 841fa67ffffffff 841fa61ffffffff 841fa6dffffffff
#> 
grid_distances(h3, 2)
#> [[1]]
#>  [1] 0 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2
#> 
#> [[2]]
#>  [1] 0 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2
#> 
grid_path_cells(h3, rev(h3))
#> [[1]]
#> <H3[11]>
#>  [1] 841f91dffffffff 841f957ffffffff 841f951ffffffff 841f959ffffffff
#>  [5] 841fb33ffffffff 841fb3bffffffff 841fb15ffffffff 841fb1dffffffff
#>  [9] 841fb57ffffffff 841fb51ffffffff 841fb59ffffffff
#> 
#> [[2]]
#> <H3[11]>
#>  [1] 841fb59ffffffff 841fb51ffffffff 841fb57ffffffff 841fb1dffffffff
#>  [5] 841fb15ffffffff 841fb3bffffffff 841fb33ffffffff 841f959ffffffff
#>  [9] 841f951ffffffff 841f957ffffffff 841f91dffffffff
#> 
grid_path_cells_size(h3, rev(h3))
#> [1] 11 11
grid_distance(h3, rev(h3))
#> [1] 10 10
grid_local_ij(h3, rev(h3))
#>    i  j
#> 1 13 26
#> 2 23 26
```
