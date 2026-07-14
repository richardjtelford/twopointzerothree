#' Null expectation for apparent sequences
#' @description Vectors with low cardinality have a high risk of false positive
#' duplicate sequences, especially for short sequences.
#' `dup_permute` permutes sequences and then tests for duplicates.
#'
#' @param vec vector with possible duplicates
#' @param min minimum length of sequence sought
#' @param max maximum length of sequence sought
#' @param nsamp number of replications
#' @param type Type of duplicate sought: "identical", "offset", "multiply" or
#'  "multiply_offset"
#'
#' @examples
#' # data from https://doi.org/10.5061/dryad.bd26mq0
#' TotalPrey <- c(
#'   4, 5, 4, 1, 3, 8, 2, 4, 7, 6, 1, 8, 3, 6, 2, 1, 3, 5, 2, 7,
#'   1, 1, 3, 4, 4, 1, 3, 4, 3, 9, 2, 7, 6, 5, 3, 2, 4, 3, 4, 3, 2,
#'   3, 4, 3, 3, 3, 2, 4, 4, 2, 2, 6, 4, 3, 5, 2, 4, 3, 5, 1, 3, 4,
#'   4, 3, 1, 3, 2, 2, 3, 1, 4, 4, 3, 4, 3, 4, 3, 3, 7, 3, 4, 9, 2,
#'   7, 3, 5, 2, 3, 6, 2, 4, 5, 2, 8, 5, 3, 4, 5, 6, 4, 3, 3, 4, 3,
#'   2, 3, 2, 2, 2, 1, 1, 2, 1, 3, 4, 1, 2, 3, 3, 4, 1, 2, 3, 3, 2,
#'   2, 3, 1, 5, 3, 4, 2, 2, 1, 1, 2, 1, 0, 1, 2
#' )
#'
#' res <- dup_permute(TotalPrey, min = 5, max = 10, nsamp = 100)
#' res
#' res |> dplyr::summarise(prob_has_duplicate = mean(sequences > 0), .by = "n")
#' @importFrom dplyr mutate if_else
#' @importFrom purrr set_names map list_rbind
#' @importFrom tibble tibble
#' @importFrom rlang .data
#' @export

dup_permute <- function(vec, min = 5, max = 10, nsamp = 100,
                        type = "identical") {
  min:max |>
    set_names() |>
    rep(each = nsamp) |>
    map(\(n) {
      dup_find(vec = sample(vec), n = n, type = type)
    }) |>
    map(\(s) {
      n_seq <- if (nrow(s)) {
        max(s$duplicate_no)
      } else {
        0
      }
      tibble(sequences = n_seq)
    }) |>
    list_rbind(names_to = "n") |>
    mutate(n = as.integer(.data$n))
}
