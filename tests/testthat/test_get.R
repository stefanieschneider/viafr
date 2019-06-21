context("Get")

test_that("query list", {
  expect_equal(
    unlist(viaf_get(list("102333412"))),
    unlist(viaf_get("102333412"))
  )
})

test_that("invalid query", {
  expect_error(viaf_get())
})

test_that("empty query", {
  expect_warning(result <- viaf_get(""))

  tbl_class <- c("tbl_df", "tbl", "data.frame")

  expect_equal(class(result), tbl_class)
  expect_equal(nrow(result), 0)
})

test_that("valid query", {
  result <- viaf_get("102333412")
  tbl_class <- c("tbl_df", "tbl", "data.frame")

  expect_equal(class(result), tbl_class)

  expect_equal(class(result$source_ids), "list")
  expect_equal(class(result$source_ids[[1]]), tbl_class)
  expect_gt(nrow(result$source_ids[[1]]), 0)

  expect_equal(class(result$text), "list")
  expect_gt(nrow(result$text[[1]]), 0)
})

test_that("valid query personal names", {
  result <- viaf_get("64013650")

  expect_equal(result$name_type, "Personal Names")
})

test_that("valid query corporate names", {
  result <- viaf_get("156527943")

  expect_equal(result$name_type, "Corporate Names")
})

test_that("valid query uniform title works", {
  result <- viaf_get("175917895")

  expect_equal(result$name_type, "Uniform Title Works")
})
