context("Suggest")

test_that("query list", {
  expect_equal(
    unlist(viaf_suggest(list("rembrandt"))),
    unlist(viaf_suggest("rembrandt"))
  )
})

test_that("no results", {
  result <- viaf_suggest("asdfgh")$`asdfgh`

  tbl_class <- c("tbl_df", "tbl", "data.frame")

  expect_equal(class(result), tbl_class)
  expect_equal(nrow(result), 0)
})

test_that("invalid query", {
  expect_error(viaf_suggest())
})

test_that("empty query", {
  result <- viaf_suggest("")[[1]]

  tbl_class <- c("tbl_df", "tbl", "data.frame")

  expect_equal(class(result), tbl_class)
  expect_equal(nrow(result), 0)
})

test_that("valid query", {
  result <- viaf_suggest("rembrandt")$`rembrandt`

  tbl_class <- c("tbl_df", "tbl", "data.frame")

  expect_equal(class(result), tbl_class)
  expect_equal(class(result$source_ids), "list")
  expect_equal(class(result$source_ids[[1]]), tbl_class)
})
