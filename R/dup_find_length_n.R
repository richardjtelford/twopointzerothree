#' Find and extract duplicate sequences of specified length
#' @param vec vector with possible duplicates
#' @param n length of sequence sought
#' @param tolerance Small positive number to allow for numerical imprecision
#' @param type Type of duplicate sought.
#' Options are "identical" for exact duplicates,
#' "offset" for duplicates with an fixed offset,
#' "multiply" where one duplicate is a multiple of another,
#' and "multiple_offset" where one duplicate is a multiple of another with an offset.
#' @param reverse logical, test if the sequence is a reversed duplicate.

#'
#' @details
#' Note that type = "multiply_offsets" will also find multiplied duplicates (offset = 0),
#' constant offsets (multiplier = 1), and identical duplicates (multiplier = 1, offset = 0)
#' @examples
#' set.seed(42)
#' x <- rnorm(10)
#' x <- c(x, x[1:4] + 2.03)
#' detectduplicate:::dup_find_length_n(vec = x, n = 5, type = "offset")
dup_find_length_n <- function(vec, n, type, tolerance, reverse) {
  d <- dup_dist(vec = vec, n = n, type = type, tolerance)
  dup_extract(d = d, vec = vec, n = n)
}
