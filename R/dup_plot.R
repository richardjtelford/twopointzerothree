#' Plot duplicates
#'
#' @param x The vector or data.frame used
#' @param obj result from `dup_find_all`
#' @importFrom ggplot2 ggplot aes geom_raster geom_linerange
#' @importFrom dplyr bind_rows summarise
#' @importFrom rlang .data
#'
#' @export

# plot ideas - single variable
# 1 plot variable - colour duplicate segments - second panel abacus plot
# 2 plot row number vs rownumber coloured by type/offset

# multicolumn
dup_plot <- function(obj, x) {
  p1 <- ggplot(obj, aes(.data$pos1, .data$pos2, fill = .data$delta)) +
    geom_raster()


  bind_rows(
    obj |> summarise(min = min(.data$pos1), max = max(.data$pos1), .by = "duplicate_no"),
    obj |> summarise(min = min(.data$pos2), max = max(.data$pos2), .by = "duplicate_no")
  ) |>
    ggplot(aes(xmin = .data$min, xmax = .data$max, y = .data$duplicate_no)) +
    geom_linerange()
}
