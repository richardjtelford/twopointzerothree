test_that("finds duplicates", {
  set.seed(42)
  x <- rnorm(10)

  s1 <- sequence_dist(vec = x, n = 4)

  # no duplicate
  expect_gt(min(s1, na.rm = TRUE), 0)

  # duplicate sequence
  x2 <- c(x, x[1:4] + 2.03) # with offset duplicate
  s2 <- sequence_dist(vec = x2, n = 4, type = "offset")
  expect_equal(min(s2, na.rm = TRUE), 0)
})
