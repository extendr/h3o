# H3 Inspection Functions

Functions that provide metadata about H3 indexes.

## Usage

``` r
h3_resolution(x)

h3_base_cell(x)

is_valid_h3(x)

is_res_class_iii(x)

is_pentagon(x)

get_face_count(x)
```

## Arguments

- x:

  an `H3` vector.

## Value

See details.

## Details

- `h3_resolution()`: returns the resolution of each H3 cell.

- `h3_base_cell()`: returns the base cell integer.

- `is_valid_h3()`: given a vector of H3 index string IDs, determine if
  they are valid.

- `is_res_class_iii()`: determines if an H3 cell has Class III
  orientation.

- `is_pentagon()`: determines if an H3 cell is one of the rare few
  pentagons.

- `get_face_count()`: returns the number of faces that intersect with
  the H3 index.

## Examples

``` r
cells_ids <-c(
    "85e22da7fffffff", "85e35ad3fffffff", 
    "85e22daffffffff", "85e35adbfffffff", 
    "85e22db7fffffff", "85e35e6bfffffff",
    "85e22da3fffffff"
  ) 
  
cells <- h3o::h3_from_strings(cells_ids)

h3_resolution(cells)
#> [1] 5 5 5 5 5 5 5
h3_base_cell(cells)
#> [1] 113 113 113 113 113 113 113
is_valid_h3(c("85e22db7fffffff", NA, "oopsies"))
#> [1]  TRUE    NA FALSE
is_res_class_iii(cells)
#> [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE
is_res_class_iii(h3_from_xy(0, 0, 10))
#> [1] FALSE
is_pentagon(h3_from_strings("08FD600000000000"))
#> [1] TRUE
get_face_count(cells)
#> [1] 2 2 2 2 2 2 2
```
