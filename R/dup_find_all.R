#' Find and extract all duplicate sequences
#' @param vec vector with possible duplicates
#' @param min length of the shortest sequence of interest
#' (high risk of false positives if this is short)
#' @param type Type of duplicate sought.
#' Options are "identical" for exact duplicates (new == old),
#' "offset" for duplicates with an fixed offset (new == old + constant ),
#' and "multiple" for duplicates with a multiplicative offset
#' (new == old * constant1 + constant2)
#' @param tolerance Small positive number to allow for numerical imprecision.
#' Defaults to `sqrt(.Machine$double.eps)`.
#' @examples
#' data(kp2014)
#' dup_find_all(
#'   vec = c(
#'     kp2014$`Theridion murarium Aggressiveness...4`,
#'     kp2014$`Theridion murarium Aggressiveness...5`,
#'     kp2014$`Theridion murarium Aggressiveness...6`
#'   ),
#'   type = "offset"
#' )
#' @importFrom dplyr bind_rows distinct cur_group_id
#' @importFrom rlang .data
#' @export
dup_find_all <- function(vec, type = "identical", min = 4, tolerance) {
  # max possible duplicate
  max <- floor(length(vec) / 2)

  # iterate to find different length duplicates.
  results <- list()
  for (n in min:max) {
    found <- dup_find(vec = vec, n = n, type = type, tolerance = tolerance)

    results[[n - min + 1]] <- found # allocate to list
    if (nrow(found) == 0) {
      break # stop searching when no more duplicates are found
    }
  }
  # collate results from different lengths
  results <- rev(results) |>
    bind_rows() |>
    # remove duplicates (eg short sequence that is subset of long sequence)
    distinct(.data$pos1, .data$pos2, .keep_all = TRUE) |>
    mutate(duplicate_no = cur_group_id(), .by = c("duplicate_no", "length"))
  results
}
