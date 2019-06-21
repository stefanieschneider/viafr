context("Utils")

test_that("invalid query", {
  expect_error(viaf_retrieve())

  expect_warning(viaf_retrieve("10233341"))
  expect_true(is.null(viaf_retrieve("10233341")))
})

test_that("valid query", {
  result <- viaf_retrieve("102333412")

  expect_true(is.list(result))
  expect_equal(length(result), 34)

  expect_true("@xmlns" %in% names(result))
  expect_equal(result$viafID, "102333412")
})
