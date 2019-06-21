context("Search")

test_that("query list", {
  expect_equal(
    unlist(viaf_search(list("Rembrandt"))),
    unlist(viaf_search("Rembrandt"))
  )
})

test_that("no results", {
  result <- viaf_search("asdfgh")$`asdfgh`

  tbl_class <- c("tbl_df", "tbl", "data.frame")

  expect_equal(class(result), tbl_class)
  expect_equal(nrow(result), 0)
})

test_that("invalid query", {
  expect_error(viaf_search())
})

test_that("empty query", {
  expect_warning(result <- viaf_search("")[[1]])

  tbl_class <- c("tbl_df", "tbl", "data.frame")

  expect_equal(class(result), tbl_class)
  expect_equal(nrow(result), 0)
})

test_that("valid query", {
  result <- viaf_search("Duerer", maximumRecords = 5)
  result <- result$`Duerer`

  tbl_class <- c("tbl_df", "tbl", "data.frame")

  expect_equal(class(result), tbl_class)

  expect_equal(class(result$source_ids), "list")
  expect_equal(class(result$source_ids[[1]]), tbl_class)
  expect_gt(nrow(result$source_ids[[1]]), 0)

  expect_equal(class(result$text), "list")
  expect_gt(nrow(result$text[[1]]), 0)

  expect_equal(nrow(result), 5)
})
