#' extract duplicate sequences
#' @param d result of `dup_dist`
#' @param vec vector with possible duplicates
#' @param n length of sequence sought
#' @importFrom tibble tibble
#' @examples
#' #' set.seed(42)
#' x <- rnorm(10)
#' x <- c(x, x[1:4] + 2.03)
#' d <- detectduplicate:::dup_dist(vec = x, n = 3)
#' detectduplicate:::dup_extract(d, vec = x)
#' @importFrom rlang .data
#' @importFrom tibble tibble
#' @importFrom purrr list_rbind
#' @importFrom dplyr mutate relocate
#' @importFrom stats lm coef


dup_extract <- function(d, vec, n) {
  # get type
  type <- attr(d, "type")
  # get reverse
  reverse <- attr(d, "reverse")

  # get indices where d is true (ie within tolerance of zero)
  dups <- finv(which(d), d)

  # recode from index to row
  labels <- attr(d, "Labels")
  dups[, "i"] <- as.numeric(labels[dups[, "i"]])
  dups[, "j"] <- as.numeric(labels[dups[, "j"]])

  if (nrow(dups) == 0) {
    result <- tibble(
      duplicate_no = integer(),
      length = numeric(),
      pos1 = integer(),
      vec1 = numeric(),
      pos2 = integer(),
      vec2 = numeric(),
      delta = numeric()
    )
  } else {
    result <- apply(dups, 1, function(pos) {
      out <- tibble(
        length = n,
        pos1 = pos["j"]:(pos["j"] + n - 1),
        vec1 = vec[.data$pos1],
        pos2 = if(reverse) {rev(pos["i"]:(pos["i"] + n - 1))} else {pos["i"]:(pos["i"] + n - 1)},
        vec2 = vec[.data$pos2],
        delta = .data$vec2 - .data$vec1
      )

      out <- switch(type,
        identical = out,
        offset = out |> mutate(offset = .data$vec2 - .data$vec1),
        multiply = out |> mutate(multiple = .data$vec2 / .data$vec1),
        multiply_offset = {
          mod <- lm(vec2 ~ vec1, data = out)
          out |> mutate(offset = coef(mod)[1], multiply = coef(mod)[2])
        }
      )
      out
    }, simplify = FALSE) |>
      list_rbind(names_to = "duplicate_no")
  }

  result <- result |>
    relocate(.data$duplicate_no, .before = 1) |>
    mutate(type = {{ type }}, .after = "duplicate_no")

  result
}


#' 1D index to 2D index
#' @param k Indicies to convert to 2D
#' @param dist_obj distance object
#' @references https://stackoverflow.com/a/39006382/2055765


finv <- function(k, dist_obj) {
  if (!inherits(dist_obj, "dist")) stop("please provide a 'dist' object")
  n <- attr(dist_obj, "Size")
  valid <- (k >= 1) & (k <= n * (n - 1) / 2)
  k_valid <- k[valid]
  j <- rep.int(NA_real_, length(k))
  j[valid] <- floor(((2 * n + 1) - sqrt((2 * n - 1)^2 - 8 * (k_valid - 1))) / 2)
  i <- j + k - (2 * n - j) * (j - 1) / 2
  cbind(i, j)
}
