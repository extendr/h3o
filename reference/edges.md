# H3 Edges

Functions to create or work with `H3Edge` vectors. See `Details` for
further details.

## Usage

``` r
h3_edges(x, flat = FALSE)

h3_shared_edge_sparse(x, y)

h3_shared_edge_pairwise(x, y)

is_edge(x)

is_valid_edge(x)

h3_edges_from_strings(x)

flatten_edges(x)

h3_edge_cells(x)

h3_edge_origin(x)

h3_edge_destination(x)

# S3 method for class 'H3Edge'
as.character(x, ...)
```

## Arguments

- x:

  an H3 vector

- flat:

  default `FALSE`. If `TRUE` return a single vector combining all edges
  of all H3 cells.

- y:

  an H3 vector

- ...:

  unused.

## Value

See details.

## Details

- `h3_edges()`: returns a list of `H3Edge` vectors for each H3 index.
  When `flat = TRUE`, returns a single `H3Edge` vector.

- `h3_shared_edge_pairwise()`: returns an `H3Edge` vector of shared
  edges. If there is no shared edge `NA` is returned.

- `h3_shared_edge_sparse()`: returns a list of `H3Edge` vectors. Each
  element iterates through each element of `y` checking for a shared
  edge.

- `is_edge()`: returns `TRUE` if the element inherits the `H3Edge`
  class.

- `is_valid_edge()`: checks each element of a character vector to
  determine if it is a valid edge ID.

- `h3_edges_from_strings()`: create an `H3Edge` vector from a character
  vector.

- `flatten_edges()`: flattens a list of `H3Edge` vectors into a single
  `H3Edge` vector.

- `h3_edge_cells()`: returns a list of length 2 named `H3Edge` vectors
  of `origin` and `destination` cells

- `h3_edge_origin()`: returns a vector of `H3Edge` origin cells

- `h3_edge_destination()`: returns a vector of `H3Edge` destination
  cells

## Examples

``` r
# create an H3 cell
x <- h3_from_xy(-122, 38, 5)

# find all edges and flatten
edges <- h3_edges(x) |>
  flatten_edges()

# check if they are all edges
is_edge(edges)
#> [1] TRUE

# check if valid edge strings
is_valid_edge(c("115e22da7fffffff", "abcd"))
#> [1]  TRUE FALSE

# get the origin cell of the edge
h3_edge_origin(edges)
#> <H3[6]>
#> [1] 85e22da7fffffff 85e22da7fffffff 85e22da7fffffff 85e22da7fffffff
#> [5] 85e22da7fffffff 85e22da7fffffff

# get the destination of the edge
h3_edge_destination(edges)
#> <H3[6]>
#> [1] 85e22da7fffffff 85e22da7fffffff 85e22da7fffffff 85e22da7fffffff
#> [5] 85e22da7fffffff 85e22da7fffffff

# get both origin and destination cells
h3_edge_cells(edges)
#> [[1]]
#> <H3[2]>
#>          origin     destination 
#> 85e22da7fffffff 85e35ad3fffffff 
#> 
#> [[2]]
#> <H3[2]>
#>          origin     destination 
#> 85e22da7fffffff 85e22daffffffff 
#> 
#> [[3]]
#> <H3[2]>
#>          origin     destination 
#> 85e22da7fffffff 85e35adbfffffff 
#> 
#> [[4]]
#> <H3[2]>
#>          origin     destination 
#> 85e22da7fffffff 85e22db7fffffff 
#> 
#> [[5]]
#> <H3[2]>
#>          origin     destination 
#> 85e22da7fffffff 85e35e6bfffffff 
#> 
#> [[6]]
#> <H3[2]>
#>          origin     destination 
#> 85e22da7fffffff 85e22da3fffffff 
#> 

# create edges from strings
h3_edges_from_strings(c("115e22da7fffffff", "abcd"))
#> <H3Edge[2]>
#> [1] 115e22da7fffffff NA              

# create a vector of cells
cells_ids <-c(
  "85e22da7fffffff", "85e35ad3fffffff",
  "85e22daffffffff", "85e35adbfffffff",
  "85e22da3fffffff"
)

cells <- h3o::h3_from_strings(cells_ids)

# find shared edges between the two pairwise
h3_shared_edge_pairwise(cells, rev(cells))
#> <H3Edge[5]>
#> [1] 165e22da7fffffff 125e35ad3fffffff NA               155e35adbfffffff
#> [5] 115e22da3fffffff

# get the sparse shared eddge. Finds all possible shared edges.
h3_shared_edge_sparse(cells, cells)
#> [[1]]
#> <H3Edge[5]>
#> [1] NA               115e22da7fffffff 125e22da7fffffff 135e22da7fffffff
#> [5] 165e22da7fffffff
#> 
#> [[2]]
#> <H3Edge[5]>
#> [1] 165e35ad3fffffff NA               NA               125e35ad3fffffff
#> [5] NA              
#> 
#> [[3]]
#> <H3Edge[5]>
#> [1] 155e22daffffffff NA               NA               115e22daffffffff
#> [5] 145e22daffffffff
#> 
#> [[4]]
#> <H3Edge[5]>
#> [1] 145e35adbfffffff 155e35adbfffffff 165e35adbfffffff NA              
#> [5] NA              
#> 
#> [[5]]
#> <H3Edge[5]>
#> [1] 115e22da3fffffff NA               135e22da3fffffff NA              
#> [5] NA              
#> 
```
