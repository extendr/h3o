test_that("edges keep ascending index order", {
  h <- test_cells()
  e <- h3_edges(h[1])[[1]]
  expect_identical(
    format(e),
    c(
      "1152aa847fffffff",
      "1252aa847fffffff",
      "1352aa847fffffff",
      "1452aa847fffffff",
      "1552aa847fffffff",
      "1652aa847fffffff"
    )
  )
  expect_identical(format(h3_edge_origin(e)), rep("852aa847fffffff", 6))
  expect_identical(
    lapply(h3_edge_cells(e[1:2]), format),
    list(
      c("852aa847fffffff", "852aa873fffffff"),
      c("852aa847fffffff", "852aa84ffffffff")
    )
  )
})

test_that("neighbor checks and shared edges are stable", {
  h <- test_cells()
  disk <- grid_disk(h[1], 3)[[1]]
  expect_identical(is_nb_pairwise(h[1], disk[c(2, 10)]), TRUE)
  expect_identical(
    format(h3_shared_edge_pairwise(h[1], disk[2])),
    "1252aa847fffffff"
  )
})

test_that("missing cells have no edges", {
  missing <- h3_from_xy(NA_real_, NA_real_, 5)
  res <- h3_edges(c(test_cells()[1], missing))
  expect_length(res[[1]], 6L)
  expect_length(res[[2]], 0L)
  expect_true(is_edge(res[[2]]))
})
