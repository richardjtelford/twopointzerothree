#' Plot duplicates as a raster
#'
#' @param obj result from `dup_find` or `dup_find_all`
#' @importFrom ggplot2 ggplot aes geom_raster facet_grid vars
#' @importFrom rlang .data

#'
#' @export

# plot ideas - single variable
# 1 plot variable - colour duplicate segments - second panel abacus plot
# 2 plot row number vs rownumber coloured by type/offset

# cope with dup_find and dup_find_all (perhaps with different defaults)
# cope with vector and data.frame
# different types of plot


# multicolumn
dup_plot_raster <- function(obj) {
  if (!any(colnames(obj) == "col1")) {
    p1 <- ggplot(obj, aes(.data$pos1, .data$pos2, fill = .data$delta)) +
      geom_raster()
    if (any(colnames(obj) == "type")) {
      p1 <- p1 + aes(fill = .data$type)
    }
  } else {
    p1 <- ggplot(obj, aes(.data$row1, .data$row2, fill = .data$delta)) +
      geom_raster() +
      facet_grid(rows = vars(.data$col1), cols = vars(.data$col2))
      
    if (any(colnames(obj) == "type")) {
      p1 <- p1 + aes(fill =  .data$type)
    }
    
  }
  p1
}


#' Plot duplicates as lines
#'
#' @param obj result from `dup_find` or  `dup_find_all()`
#' @importFrom ggplot2 ggplot aes geom_linerange facet_grid vars
#' @importFrom dplyr select summarise
#' @importFrom rlang .data
#' @importFrom tidyr pivot_longer
#' @export
dup_plot_lines <- function(obj) {
  type <- if(any(colnames(obj) == "type")) "type" else NULL 
  if (!any(colnames(obj) == "col1")) {
    obj |> 
      select("duplicate_no", type, "pos1", "pos2") |> 
      pivot_longer(c("pos1", "pos2"), names_to = "which", values_to = "pos") |> 
      summarise(min = min(.data$pos), max = max(.data$pos), .by = c("duplicate_no", type, "which")) |> 
      ggplot(aes(xmin = .data$min, xmax = .data$max, y = .data$duplicate_no)) +
      geom_linerange(aes(colour = "type"))
  } else {
    obj |> 
      select("duplicate_no", type, "row1", "row2", "col1", "col2") |> 
      pivot_longer(c("row1", "row2"), names_to = "which", values_to = "pos") |> 
      summarise(min = min(.data$pos), max = max(.data$pos), .by = c("duplicate_no", type, "col1", "col2", "which")) |> 
      ggplot(aes(xmin = .data$min, xmax = .data$max, y = .data$duplicate_no)) +
      geom_linerange(aes(colour = "type")) +
      facet_grid(rows = vars(.data$col1), cols = vars(.data$col2))
  }
  
}
