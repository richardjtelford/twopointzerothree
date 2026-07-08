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
#' @importFrom dplyr anti_join bind_rows
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
  results <- rev(results)
  results2 <- list()
  results2[[1]] <- results[[1]]
  if (length(results) > 1) {
    for (i in 2:length(results)) {
      results2[[i]] <- anti_join(results[[i]], results[[i - 1]],
        by = c("pos1", "pos2")
      )
    }
  }
  bind_rows(results2)
}
