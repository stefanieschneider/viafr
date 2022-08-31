context("Utils")

skip_on_cran()
skip_if_offline(host = "viaf.org")

test_that("invalid query", {
  expect_error(viaf_retrieve())

  expect_message(result <- viaf_retrieve("10233341"))
  expect_true(is.null(result))
})

test_that("valid query", {
  result <- viaf_retrieve("102333412")

  expect_true(is.list(result))
  # expect_equal(length(result), 34)

  expect_true("@xmlns" %in% names(result))
  expect_equal(result$viafID, "102333412")
})
