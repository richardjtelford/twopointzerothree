#' Find and extract all duplicate sequences
#' @param vec vector with possible duplicates
#' @param min length of the shortest sequence of interest (high risk of false positives if this is short)
#' @examples
#' data(kp2014)
#' sequence_find_all(
#'   vec = c(
#'     kp2014$`Theridion murarium Aggressiveness...4`,
#'     kp2014$`Theridion murarium Aggressiveness...5`,
#'     kp2014$`Theridion murarium Aggressiveness...6`
#'   ),
#'   max = 9
#' )
#' @importFrom dplyr bind_rows distinct cur_group_id
#' @importFrom rlang .data
#' @export
sequence_find_all <- function(vec, min = 4) {

  max <- floor(length(vec) / 2)
  
  results <- list()
  for (n in min:max) {
    found <- sequence_find(vec = vec, n = n)
    if (nrow(found) == 0) {
      break
    }
    results[[n - min + 1]] <- found
  }
  results <- rev(results) |> 
    bind_rows() |>
    # remove duplicates (eg short sequence that is subset of long sequence)
    distinct(.data$pos1, .data$pos2, .keep_all = TRUE) |> 
    mutate(duplicate_no = cur_group_id(), .by = c("duplicate_no", "length"))
  results
}

