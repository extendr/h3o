# H3 index neighbors

Test if two H3 cells are neighbors.

## Usage

``` r
is_nb_pairwise(x, y)

is_nb_sparse(x, y)
```

## Arguments

- x:

  an `H3` vector.

- y:

  and `H3` vector.

## Value

`is_nb_pairwise()` returns a logical vector wheraas `is_nb_sparse()`
returns a list with logical vector elements.

## Examples

``` r
cells_ids <-c(
  "85e22da7fffffff", "85e35ad3fffffff",
  "85e22daffffffff", "85e35adbfffffff",
  "85e22db7fffffff", "85e35e6bfffffff",
  "85e22da3fffffff"
)

cells <- h3o::h3_from_strings(cells_ids)

is_nb_pairwise(cells, rev(cells))
#> [1]  TRUE  TRUE FALSE FALSE FALSE  TRUE  TRUE
is_nb_sparse(cells, cells)
#> [[1]]
#> [1] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
#> 
#> [[2]]
#> [1]  TRUE FALSE FALSE  TRUE FALSE  TRUE FALSE
#> 
#> [[3]]
#> [1]  TRUE FALSE FALSE  TRUE FALSE FALSE  TRUE
#> 
#> [[4]]
#> [1]  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE
#> 
#> [[5]]
#> [1]  TRUE FALSE FALSE FALSE FALSE  TRUE  TRUE
#> 
#> [[6]]
#> [1]  TRUE  TRUE FALSE FALSE  TRUE FALSE FALSE
#> 
#> [[7]]
#> [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE FALSE
#> 
```
