# setup
set.seed(42)
x <- rnorm(10)


test_that("no duplicates", {
  s1 <- dup_dist(vec = x, n = 4)
  expect_true(all(s1 == 0))
})

test_that("finds duplicate sequence", {
  x2 <- c(x, x[1:4])
  s2 <- dup_dist(vec = x2, n = 4, type = "identical")
  expect_equal(sum(s2), 1)
})

test_that("finds duplicate sequence with tolerance", {
  x2 <- c(x, x[1:4] + sqrt(.Machine$double.eps) / 2)
  expect_false(isTRUE(identical(x2[1:4], tail(x2, 4))))
  s2 <- dup_dist(vec = x2, n = 4, type = "identical")
  expect_equal(sum(s2), 1)
})

test_that("finds duplicate offset sequence", {
  x2 <- c(x, x[1:4] + 2.03) # with offset duplicate
  s2 <- dup_dist(vec = x2, n = 4, type = "offset")
  expect_equal(sum(s2), 1)
})

test_that("Finds reversed sequence", {
  # reverse sequence
  x3 <- c(x, x[4:1] + 2.03) # with offset duplicate
  s3 <- dup_dist(vec = x3, n = 4, type = "offset", reverse = TRUE)
  expect_equal(sum(s3), 1)
})

test_that("finds duplicate sequence with multiplier", {
  x4 <- c(x, x[1:4] * 2) # with multiple duplicate
  s4 <- dup_dist(vec = x4, n = 4, type = "multiply")
  expect_equal(sum(s4), 1)
})

test_that("finds duplicate sequence with multiplier and offset", {
  x4 <- c(x, x[1:4] * 2 + 1) # with multiple + offset  duplicate
  s4 <- dup_dist(vec = x4, n = 4, type = "multiply_offset")
  expect_equal(sum(s4), 1)
})

test_that("finds duplicate sequence with negative multiplier and offset", {
  x4 <- c(x, x[1:4] * -2 + 1) # with multiple + offset  duplicate
  s4 <- dup_dist(vec = x4, n = 4, type = "multiply_offset")
  expect_equal(sum(s4), 1)
})
