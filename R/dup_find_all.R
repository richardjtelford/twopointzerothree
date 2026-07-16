#' Find and extract all duplicate sequences
#' @param x vector or data.frame with possible duplicates
#' @param min length of the shortest sequence of interest
#' (high risk of false positives if this is short)
#' @param type Type of duplicate sought.
#' Options are "identical" for exact duplicates,
#' "offset" for duplicates with an fixed offset,
#' "multiply" where one duplicate is a multiple of another,
#' and "multiple_offset" where one duplicate is a multiple of another with an offset.
#' @param tolerance Small positive number to allow for numerical imprecision.
#' Defaults to `sqrt(.Machine$double.eps)`.
#' @param reverse logical, test if the sequence is a reversed duplicate. 
#' Defaults to FALSE
#' @examples
#' data(kp2014)
#' dup_find_all(
#'   x = kp2014$`Theridion murarium Aggressiveness...4`,
#'   type = "offset"
#' )
#' dup_find_all(
#'   x = kp2014[, c("Theridion murarium Aggressiveness...4",
#'                  "Theridion murarium Aggressiveness...5",
#'                  "Theridion murarium Aggressiveness...6")],
#'   type = "offset"
#' )
#' @importFrom dplyr bind_rows distinct cur_group_id
#' @importFrom rlang .data
#' @export
#' 
dup_find_all <- function(x, type = "identical", min = 4, tolerance, reverse) {
  UseMethod("dup_find_all")
}
  
#' @rdname dup_find_all
#' @export 
dup_find_all.default <- function(x, type = "identical", min = 4, tolerance, reverse) {
  if(!is.numeric(x)) {
    stop("`dup_find_all()` can only process numeric data.") 
  }
  
  # max possible duplicate
  max <- floor(length(x) / 2)

  # iterate to find different length duplicates.
  results <- list()
  for (n in min:max) {
    found <- dup_find(vec = x, n = n, type = type, tolerance = tolerance)

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

#' @rdname dup_find_all
#' @export 

dup_find_all.data.frame <- function(x, type = "identical", min = 4, tolerance, reverse) {
    # check data are valid
    if(! all(sapply(x, is.numeric))) {
      stop("`dup_find_all()` can only process numeric data.") 
    }
   # unwrap data
  vec <- unlist(x) |> as.vector()
  
  # run dup_find_all
  dups <- dup_find_all(vec, type = type, min = min, tolerance = tolerance, reverse = reverse)

  # update output to show rows columns
  #todo
  dups
}