test_that("cells are created from coordinates and strings", {
  h <- test_cells()
  expected <- c("852aa847fffffff", "851fb467fffffff", "852f5a37fffffff")
  expect_identical(format(h), expected)
  expect_identical(format(h3_from_strings(expected)), expected)
  expect_true(all(is_valid_h3(expected)))
})

test_that("inspection functions are stable", {
  h <- test_cells()
  expect_identical(h3_resolution(h), c(5L, 5L, 5L))
  expect_identical(h3_base_cell(h), c(21L, 15L, 23L))
  expect_identical(is_res_class_iii(h), c(TRUE, TRUE, TRUE))
  expect_identical(is_pentagon(h), c(FALSE, FALSE, FALSE))
  expect_identical(get_face_count(h), c(2L, 2L, 2L))
})

test_that("cell areas are stable", {
  h <- test_cells()
  expect_equal(
    area_km2(h),
    c(245.794138648, 225.337807466, 232.008939601),
    tolerance = 1e-9
  )
  expect_equal(
    area_m2(h),
    c(245794138.648, 225337807.466, 232008939.601),
    tolerance = 1e-9
  )
  expect_equal(
    area_rads2(h),
    c(6.05557424286e-06, 5.5515962681e-06, 5.71595143192e-06),
    tolerance = 1e-9
  )
})
