skip_if_not_installed("sf")

test_that("cell centers are stable", {
  h <- test_cells()
  coords <- unclass(sf::st_coordinates(h3_to_points(h)))
  expect_equal(
    unname(coords),
    cbind(
      c(-76.9512287304, 2.39618812597, 139.639553653),
      c(38.9369895182, 48.8241028768, 35.720113561)
    ),
    tolerance = 1e-9
  )
})

test_that("cell vertexes and boundaries are stable", {
  h <- test_cells()
  x <- c(
    -76.9597439196,
    -77.0562561569,
    -77.0475792361,
    -76.9427435515,
    -76.8463635075,
    -76.8546867848
  )
  y <- c(
    39.0211841645,
    38.9736340606,
    38.8895012198,
    38.8528916403,
    38.9002697529,
    38.9844291295
  )

  verts <- unclass(sf::st_coordinates(h3_to_vertexes(h[1])))[, 1:2]
  expect_equal(unname(verts), cbind(x, y), tolerance = 1e-9, ignore_attr = TRUE)

  poly <- unclass(sf::st_coordinates(sf::st_as_sfc(h[1])))[, 1:2]
  expect_equal(
    unname(poly),
    cbind(c(x, x[1]), c(y, y[1])),
    tolerance = 1e-9,
    ignore_attr = TRUE
  )
})

test_that("missing cells have empty vertexes", {
  missing <- h3_from_xy(NA_real_, NA_real_, 5)
  res <- h3_to_vertexes(c(test_cells()[1], missing))
  expect_s3_class(res, "sfc_MULTIPOINT")
  expect_identical(nrow(sf::st_coordinates(res[2])), 0L)
  expect_identical(nrow(sf::st_coordinates(res[1])), 6L)
})
