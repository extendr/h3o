test_that("parents and children are stable", {
  h <- test_cells()
  expect_identical(
    format(get_parents(h, 2)),
    c("822aaffffffffff", "821fb7fffffffff", "822f5ffffffffff")
  )
  expect_identical(get_children_count(h, 7), c(49L, 49L, 49L))
  expect_identical(
    format(get_children(h[1], 6)[[1]]),
    c(
      "862aa8447ffffff",
      "862aa844fffffff",
      "862aa8457ffffff",
      "862aa845fffffff",
      "862aa8467ffffff",
      "862aa846fffffff",
      "862aa8477ffffff"
    )
  )
  centers <- get_children_center(h, 7)
  expect_identical(
    format(centers),
    c("872aa8440ffffff", "871fb4640ffffff", "872f5a340ffffff")
  )
  expect_identical(get_children_position(centers, 5), c(0L, 0L, 0L))
  expect_identical(
    format(get_children_at(h, 3, 7)),
    c("872aa8443ffffff", "871fb4643ffffff", "872f5a343ffffff")
  )
})

test_that("compact and uncompact are stable", {
  h <- test_cells()
  cells <- c(get_children(h[1], 6)[[1]], get_children(h[2], 6)[[1]][1:3])
  expect_identical(
    format(compact_cells(cells)),
    c(
      "861fb4647ffffff",
      "861fb464fffffff",
      "861fb4657ffffff",
      "852aa847fffffff"
    )
  )
  expect_identical(
    format(uncompact_cells(h[1], 6)[[1]]),
    format(get_children(h[1], 6)[[1]])
  )
})

test_that("compact_cells drops missing and duplicate cells", {
  h <- test_cells()
  missing <- h3_from_xy(NA_real_, NA_real_, 5)
  expect_identical(format(compact_cells(c(h[1], h[1], missing))), format(h[1]))
})

test_that("compact_cells errors on mixed resolutions", {
  h <- test_cells()
  expect_error(
    compact_cells(c(h[1], get_children(h[2], 6)[[1]][1]))
  )
})
