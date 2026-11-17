skip_if_not_installed("sf")

test_that("each containment mode fills polygons the same way", {
  g <- nc_geometry()[1:2]
  fill <- function(mode) format(sfc_to_cells(g, 5, mode)[[1]])

  expect_identical(
    fill("centroid"),
    c(
      "8544db37fffffff",
      "852a9927fffffff",
      "852a9923fffffff",
      "852a9937fffffff"
    )
  )
  expect_identical(fill("boundary"), c("852a9927fffffff", "852a9937fffffff"))

  intersect <- c(
    "8544dbaffffffff",
    "8544db37fffffff",
    "852a9927fffffff",
    "8544dba7fffffff",
    "852a992ffffffff",
    "852a992bfffffff",
    "852a9923fffffff",
    "852a993bfffffff",
    "852a9937fffffff",
    "852a9933fffffff",
    "852a99affffffff",
    "8544db27fffffff"
  )
  expect_identical(fill("intersect"), intersect)
  expect_identical(fill("covers"), intersect)
})

test_that("cell counts per county are stable", {
  expected <- c(
    4L,
    2L,
    7L,
    5L,
    7L,
    4L,
    2L,
    4L,
    5L,
    5L,
    6L,
    7L,
    6L,
    4L,
    3L,
    9L,
    2L,
    8L,
    3L,
    2L,
    2L,
    3L,
    4L,
    4L,
    4L,
    7L,
    5L,
    8L,
    4L,
    3L,
    5L,
    2L,
    6L,
    6L,
    3L,
    6L,
    10L,
    6L,
    6L,
    3L,
    4L,
    7L,
    6L,
    6L,
    3L,
    5L,
    10L,
    9L,
    4L,
    5L,
    6L,
    4L,
    8L,
    10L,
    5L,
    4L,
    7L,
    7L,
    3L,
    2L,
    6L,
    7L,
    7L,
    6L,
    4L,
    6L,
    8L,
    6L,
    5L,
    5L,
    5L,
    4L,
    2L,
    6L,
    4L,
    4L,
    2L,
    5L,
    10L,
    3L,
    6L,
    8L,
    5L,
    8L,
    5L,
    5L,
    9L,
    9L,
    6L,
    3L,
    9L,
    4L,
    8L,
    10L,
    5L,
    11L,
    10L,
    11L,
    1L,
    10L
  )
  expect_identical(
    lengths(sfc_to_cells(nc_geometry(), 5, "centroid")),
    expected
  )
})

test_that("covers cell counts per county are stable", {
  expected <- c(
    12L,
    8L,
    12L,
    16L,
    14L,
    11L,
    10L,
    9L,
    12L,
    12L,
    10L,
    12L,
    14L,
    11L,
    8L,
    18L,
    7L,
    15L,
    9L,
    8L,
    8L,
    9L,
    9L,
    13L,
    12L,
    14L,
    11L,
    16L,
    11L,
    8L,
    13L,
    10L,
    11L,
    11L,
    9L,
    12L,
    21L,
    11L,
    13L,
    10L,
    8L,
    15L,
    13L,
    8L,
    11L,
    11L,
    15L,
    16L,
    11L,
    14L,
    15L,
    12L,
    15L,
    18L,
    15L,
    23L,
    22L,
    15L,
    8L,
    7L,
    14L,
    13L,
    14L,
    13L,
    10L,
    12L,
    16L,
    14L,
    11L,
    13L,
    11L,
    10L,
    9L,
    11L,
    12L,
    10L,
    8L,
    13L,
    22L,
    9L,
    13L,
    17L,
    13L,
    15L,
    15L,
    10L,
    19L,
    18L,
    12L,
    6L,
    18L,
    11L,
    16L,
    21L,
    21L,
    21L,
    19L,
    23L,
    6L,
    20L
  )
  expect_identical(
    lengths(sfc_to_cells(nc_geometry(), 5, "covers")),
    expected
  )
})

test_that("multipolygons concatenate each polygon's cells", {
  sq <- function(x0) {
    list(cbind(c(x0, x0 + 1, x0 + 1, x0, x0), c(0, 0, 1, 1, 0)))
  }
  fill <- function(x) format(sfc_to_cells(x, 5, "centroid")[[1]])
  mp <- sf::st_sfc(sf::st_multipolygon(list(sq(0), sq(0.5))), crs = 4326)
  left <- sf::st_sfc(sf::st_polygon(sq(0)), crs = 4326)
  right <- sf::st_sfc(sf::st_polygon(sq(0.5)), crs = 4326)

  res <- fill(mp)
  expect_length(res, 132L)
  expect_identical(sum(duplicated(res)), 34L)
  expect_identical(res, c(fill(left), fill(right)))
})

test_that("polygons crossing the antimeridian fill the same cells", {
  tm <- sf::st_sfc(
    sf::st_polygon(list(cbind(
      c(170, -170, -170, 170, 170),
      c(-10, -10, 10, 10, -10)
    ))),
    crs = 4326
  )
  expected <- c(
    "825b07fffffffff",
    "825b0ffffffffff",
    "825b17fffffffff",
    "825b27fffffffff",
    "825b2ffffffffff",
    "825b37fffffffff",
    "825b57fffffffff",
    "825b77fffffffff",
    "827007fffffffff",
    "827017fffffffff",
    "82701ffffffffff",
    "827027fffffffff",
    "827037fffffffff",
    "827087fffffffff",
    "82708ffffffffff",
    "827097fffffffff",
    "82709ffffffffff",
    "8270a7fffffffff",
    "8270affffffffff",
    "8270b7fffffffff",
    "8270d7fffffffff",
    "8270f7fffffffff",
    "82711ffffffffff",
    "827187fffffffff",
    "82718ffffffffff",
    "827197fffffffff",
    "82719ffffffffff",
    "8271a7fffffffff",
    "8271affffffffff",
    "8271b7fffffffff",
    "827e07fffffffff",
    "827e17fffffffff",
    "827e1ffffffffff",
    "827e27fffffffff",
    "827e2ffffffffff",
    "827e37fffffffff",
    "827e87fffffffff",
    "827e8ffffffffff",
    "827e97fffffffff",
    "827e9ffffffffff",
    "827ea7fffffffff",
    "827eaffffffffff",
    "827eb7fffffffff",
    "827ec7fffffffff",
    "827ed7fffffffff",
    "827edffffffffff",
    "827ee7fffffffff",
    "827ef7fffffffff",
    "827f07fffffffff",
    "827f0ffffffffff",
    "827f17fffffffff",
    "827f1ffffffffff",
    "827f2ffffffffff",
    "827f57fffffffff",
    "827f5ffffffffff",
    "827f77fffffffff",
    "827f87fffffffff",
    "827f8ffffffffff",
    "827f97fffffffff",
    "827f9ffffffffff",
    "827fa7fffffffff",
    "827faffffffffff",
    "827fb7fffffffff",
    "829a4ffffffffff",
    "829a5ffffffffff",
    "829ac7fffffffff",
    "829acffffffffff",
    "829ad7fffffffff",
    "829adffffffffff",
    "829ae7fffffffff",
    "829aeffffffffff",
    "829af7fffffffff",
    "829eb7fffffffff"
  )
  res <- format(sfc_to_cells(tm, 2, "centroid")[[1]])
  expect_identical(sort(res), expected)
})

test_that("sfc_to_cells rejects geometries that are not polygons", {
  pts <- sf::st_sfc(sf::st_point(c(0, 0)), crs = 4326)
  expect_error(
    sfc_to_cells(pts, 5)
  )
})

test_that("sfc_to_cells errors on invalid coordinates", {
  bad <- sf::st_sfc(
    sf::st_polygon(list(cbind(c(0, 1, 1, 0, 0), c(0, 0, 500, 500, 0)))),
    crs = 4326
  )
  expect_error(sfc_to_cells(bad, 5))
})
