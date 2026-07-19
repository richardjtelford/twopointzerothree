#' Find all duplicate sequences
#' @description Finds duplicate sequences, identical or with an offset and/or
#' multiplier, whether forward or reverse.
#'
#' @param x vector or data.frame with possible duplicates
#' @param min length of the shortest sequence of interest
#' (high risk of false positives if this is short)
#' @param tolerance Small positive number to allow for numerical imprecision.
#' Defaults to `sqrt(.Machine$double.eps)`.
#' @examples
#' data(kp2014)
#' dup_find_all(
#'   x = kp2014$`Theridion murarium Aggressiveness...4`,
#' )
#'
#' dup_find_all(
#'   x = kp2014[, c(
#'     "Theridion murarium Aggressiveness...4",
#'     "Theridion murarium Aggressiveness...5",
#'     "Theridion murarium Aggressiveness...6"
#'   )]
#' )
#'
#' @importFrom rlang .data
#' @importFrom purrr pmap list_rbind
#' @importFrom dplyr mutate filter
#' @importFrom tidyr crossing

#' @export


dup_find_all <- function(x, min = 4, tolerance) {
  if (missing(tolerance)) {
    tolerance <- sqrt(.Machine$double.eps)
  }
  # test all duplicate types
  # forward and reverse

  config <- crossing(
    type = eval(formals(dup_dist)$type), # permitted types,
    reverse = c(FALSE, TRUE)
  )

  pmap(config, \(type, reverse) {
    dups <- dup_find(x, min = min, tolerance = tolerance, type = type, reverse = reverse)
    # remove sequences where all(offset == 0) or all(multiplier = 0) (as these should already be caught)
    if (nrow(dups) > 0) {
      dups <- switch(type,
        identical = dups,
        offset = dups |> filter(all(abs(.data$offset) >= tolerance), .by = "duplicate_no"),
        multiply = dups |> filter(all(abs(.data$multiply) >= tolerance), .by = "duplicate_no"),
        multiply_offset = dups |> filter(all(abs(.data$offset) >= tolerance),
          all(abs(.data$multiply - 1) >= tolerance),
          .by = "duplicate_no"
        ),
      )
      dups |> mutate(type = type, reverse = reverse, .before = 1)
    }
  }) |>
    list_rbind()
}
