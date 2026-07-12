test_that("finds duplicates", {
  set.seed(42)
  x <- rnorm(10)

  s1 <- dup_dist(vec = x, n = 4)

  # no duplicate
  expect_true(all(s1 == 0))
  
  # duplicate sequence
  x2 <- c(x, x[1:4])
  s2 <- dup_dist(vec = x2, n = 4, type = "identical")
  expect_equal(sum(s2), 1)
  
  # duplicate sequence with tolerance
  x2 <- c(x, x[1:4] + sqrt(.Machine$double.eps)/2)
  expect_false(isTRUE(identical(x2[1:4], tail(x2, 4))))
  s2 <- dup_dist(vec = x2, n = 4, type = "identical")
  expect_equal(sum(s2), 1)

  # duplicate offset sequence
  x2 <- c(x, x[1:4] + 2.03) # with offset duplicate
  s2 <- dup_dist(vec = x2, n = 4, type = "offset")
  expect_equal(sum(s2), 1)
  
  # reverse sequence
  x3 <- c(x, x[4:1] + 2.03) # with offset duplicate
  s3 <- dup_dist(vec = x3, n = 4, type = "offset", reverse = TRUE)
  expect_equal(sum(s3), 1)
  
  # duplicate multiple sequence
  x4 <- c(x, x[1:4] * 2) # with multiple duplicate
  s4 <- dup_dist(vec = x4, n = 4, type = "multiple")
  expect_equal(sum(s4), 1)
  
  # duplicate multiple sequence with offset
  x4 <- c(x, x[1:4] * 2 + 1) # with multiple + offset  duplicate
  s4 <- dup_dist(vec = x4, n = 4, type = "multiple")
  expect_equal(sum(s4), 1)
})
