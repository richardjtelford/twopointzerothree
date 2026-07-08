#' extract duplicate sequences
#' @param th result of sequence_thresh
#' @param vec vector with possible duplicates
#' @importFrom tibble tibble
#' @examples
#' #' set.seed(42)
#' x <- rnorm(10)
#' x <- c(x, x[1:4] + 2.03)
#' d <- twopointzerothree:::sequence_dist(vec = x, n = 3)
#' th <- twopointzerothree:::sequence_thresh(d)
#' twopointzerothree:::sequence_extract(th, vec = x)
#' @importFrom rlang .data
#' @importFrom tibble tibble
#' @importFrom purrr list_rbind




sequence_extract <- function(th, vec) {

  # get indices where th is true (ie within tolerance of zero)
  dups <- finv(which(th), th)

  # recode from index to row
  labels <- attr(th, "Labels")
  dups[, "i"] <- as.numeric(labels[dups[, "i"]])  
  dups[, "j"] <- as.numeric(labels[dups[, "j"]])
  
  n <- attr(th, "len")
  if (nrow(dups) == 0) {
    tibble(
      length = numeric(),
      pos1 = integer(),
      vec1 = numeric(),
      pos2 = integer(),
      vec2 = numeric(),
      delta = numeric(),
      duplicate_no = integer()
    )
  } else {
    apply(dups, 1, function(pos) {
      tibble(
        length = n,
        pos1 = pos["j"]:(pos["j"] + n - 1),
        vec1 = vec[.data$pos1],
        pos2 = pos["i"]:(pos["i"] + n - 1),
        vec2 = vec[.data$pos2],
        delta = .data$vec2 - .data$vec1
      )
      }, simplify = FALSE) |>
    list_rbind(names_to = "duplicate_no")
  }
}



#' 1D index to 2D index
#' @param k Indicies to convert to 2D
#' @param dist_obj distance object
#' @references https://stackoverflow.com/a/39006382/2055765


finv <- function (k, dist_obj) {
  if (!inherits(dist_obj, "dist")) stop("please provide a 'dist' object")
  n <- attr(dist_obj, "Size")
  valid <- (k >= 1) & (k <= n * (n - 1) / 2)
  k_valid <- k[valid]
  j <- rep.int(NA_real_, length(k))
  j[valid] <- floor(((2 * n + 1) - sqrt((2 * n - 1) ^ 2 - 8 * (k_valid - 1))) / 2)
  i <- j + k - (2 * n - j) * (j - 1) / 2
  cbind(i, j)
}