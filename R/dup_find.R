#' Find and extract duplicate sequences
#' @param vec vector with possible duplicates
#' @param n length of sequence sought
#' @param tolerance Small positive number to allow for numerical imprecision
#' @param type Type of duplicate sought. See details.
#'
#' @details
#' Options for `type` are "identical" for exact duplicates (new == old),
#' "offset" for duplicates with an fixed offset (new == old + constant ),
#' and "multiple" for duplicates with a multiplicative offset,
#' and perhaps a constant offset (new == old * constant1 + constant2).
#'
#' Note that multiplicative offsets will also find constant offsets
#' (i.e. constant1 = 1), and identical duplicates (i.e. constant2 = 0)
#' @examples
#' set.seed(42)
#' x <- rnorm(10)
#' x <- c(x, x[1:4] + 2.03)
#' detectduplicate:::dup_find(vec = x, n = 5, type = "offset")
dup_find <- function(vec, n, type, tolerance) {
  d <- dup_dist(vec = vec, n = n, type = type, tolerance)
  dup_extract(d, vec, n = n)
}
