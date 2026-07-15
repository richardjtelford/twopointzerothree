#' segment_dist
#' @description Finds distance between all segments length n of a vector
#' @param vec numeric vector to test for possible offset duplicate sequences
#' @param n length of duplicate sequence to search for
#' @param type Type of duplicate sought. See [dup_find()] for details.
#' @param tolerance Small positive number to allow for numerical imprecision
#' @param reverse logical, test if the sequence is a reversed duplicate.
#' @details Embeds the vector into low-dimensional Euclidean space and then
#' tests is rows are identical within tolerance.
#' Pairs of rows with a distance of 0 are identical if `type` is "identical".
#' If `type` is "offset, rows are centred before the distance is calculated.
#' If `type` is multiply, rows are scaled without centring.
#' If `type` is multiply_offset, rows are centred and scales.
#'
#' @examples
#' set.seed(42)
#' x <- rnorm(10)
#' x <- c(x, x[1:4] + 2.03)
#' detectduplicate:::dup_dist(vec = x, n = 4, type = "offset")
#' @importFrom stats dist embed na.omit


dup_dist <- function(vec, n,
                     type = c("identical", "offset", "multiply", "multiply_offset"),
                     tolerance, 
                     reverse = FALSE) {
  if (missing(tolerance)) {
    tolerance <- sqrt(.Machine$double.eps)
  }
  type <- match.arg(type)
  if (!is.numeric(vec)) {
    stop("vec must be numeric")
  }
  multiple <- type %in% c("multiply", "multiply_offset")
  if (length(vec) <= n) {
    stop("vec must be longer than n")
  }
  # embed
  em <- embed(vec, n)
  # reverse col order
  em <- em[, rev(seq_len(ncol(em)))] ## to delete as pointless?

  # treat for type
  em <- switch(type,
    identical = em,
    offset = t(scale(t(em), center = TRUE, scale = FALSE)),
    multiply = t(scale(t(em), center = FALSE, scale = TRUE)),
    multiply_offset = t(scale(t(em), center = TRUE, scale = TRUE))
  )

  # set rownames
  rownames(em) <- seq_len(nrow(em))
  # remove rows with NA (dist otherwise ignores NA giving some spurious matches)
  em <- na.omit(em)
  if (nrow(em) == 0) {
    warning("After embedding, all rows include NA")
  }

  # remove rows with all identical values
  all_eq <- apply(em, 1, \(r) {
    min(r) != max(r)
  })
  em <- em[all_eq, ]
  if (nrow(em) == 0) {
    warning("No rows have any variance")
  }


  # calculate distance
  d <- near_dist_cpp(em, tolerance = tolerance, rev = reverse, negate = multiple)
  attr(d, "Labels") <- rownames(em)
  attr(d, "type") <- type

  d
}
