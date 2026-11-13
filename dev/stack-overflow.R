devtools::load_all()

g <- sfdep::guerry |>
  sf::st_set_crs(27572) |>
  sf::st_transform(4326) |>
  sf::st_geometry()

# insanely faster than javascript
bench::mark(
  rust = sfg_to_cells(g[[1]], 5),
  js = h3jsr::polygon_to_cells(g[1], 5),
  check = FALSE
)


# markedly faster
bench::mark(
  rust = sfg_to_cells(g[[1]], 8),
  js = h3jsr::polygon_to_cells(g[1], 8),
  check = FALSE
)


# stack overflow
bench::mark(
  rust = sfg_to_cells(g[[1]], 9),
  js = h3jsr::polygon_to_cells(g[1], 9),
  check = FALSE
)


bench::mark(
  rust = sf::st_sfc(h3_boundaries_(unlist(sfc_to_cells(g, 5))), crs = 4326),
  V8 = h3jsr::cell_to_polygon(unlist(h3jsr::polygon_to_cells(g, 5))),
  check = FALSE,
  min_time = 10
)

x2 <-
  plot(x)
