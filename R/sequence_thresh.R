#' Threshold inter-segment distances
#' @description Thresholds distances between all segments length n of a vector
#' @param dist Output of [twopointzerothree::sequence_dist()]
#' @param tolerance Small positive number to allow for numerical imprecision
#' @details Tests if distances are, within tolerance, equal to zero.
#' @examples
#' set.seed(42)
#' x <- rnorm(10)
#' x <- c(x, x[1:4] + 2.03)
#' sequ <- twopointzerothree:::sequence_dist(vec = x, n = 4)
#' twopointzerothree:::sequence_thresh(sequ)
sequence_thresh <- function(dist, tolerance) {
  if (missing(tolerance)) tolerance <- sqrt(.Machine$double.eps)
  if (tolerance < 0) {
    stop("tolerance must be positive")
  }
  th <- dist < tolerance
  # keep dist object structure
  attributes(th) <- attributes(dist)

  th
}
