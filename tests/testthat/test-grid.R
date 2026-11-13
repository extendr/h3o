test_that("grid disk and ring are stable", {
  h <- test_cells()
  expect_identical(
    format(grid_disk(h[1], 1)[[1]]),
    c(
      "852aa847fffffff",
      "852aa84ffffffff",
      "852aa87bfffffff",
      "852aa873fffffff",
      "852aa80bfffffff",
      "852aa857fffffff",
      "852aa843fffffff"
    )
  )
  expect_identical(
    format(grid_ring(h[1], 1)[[1]]),
    c(
      "852aa857fffffff",
      "852aa843fffffff",
      "852aa84ffffffff",
      "852aa87bfffffff",
      "852aa873fffffff",
      "852aa80bfffffff"
    )
  )
})

test_that("grid distance, path and local ij are stable", {
  h <- test_cells()
  disk <- grid_disk(h[1], 3)[[1]]
  expect_identical(grid_distance(h[1], disk[c(2, 10, 30)]), 1L)
  expect_identical(
    format(grid_path_cells(h[1], disk[30])[[1]]),
    c(
      "852aa847fffffff",
      "852aa80bfffffff",
      "852aa80ffffffff",
      "852aa807fffffff"
    )
  )
  expect_identical(grid_path_cells_size(h[1], disk[30]), 4L)
  expect_identical(
    grid_local_ij(disk[c(2, 10)], h[1]),
    data.frame(i = -7L, j = 31L)
  )
})
