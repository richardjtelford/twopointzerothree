set.seed(42)
x <- rnorm(10)


test_that("works with no duplicates - identical", {
  f1 <- dup_find_length_n(x, n = 4, type = "identical")
  expect_s3_class(f1, "data.frame")
  expect_equal(nrow(f1), 0)
  expect_equal(colnames(f1), c("duplicate_no", "type", "length", "pos1", "vec1", "pos2", "vec2", "delta"))
})


test_that("works with no duplicates - multiply-offset", {
  f1 <- dup_find_length_n(x, n = 4, type = "multiply_offset")
  expect_s3_class(f1, "data.frame")
  expect_equal(nrow(f1), 0)
  expect_equal(colnames(f1), c("duplicate_no", "type", "length", "pos1", "vec1", "pos2", "vec2", "delta", "offset", "multiply"))
})
