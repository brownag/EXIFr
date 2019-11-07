#' Converts a rational number from to string to its numeric representation
#'
#' @param x A string containing the number to convert.
#' @return The numerical value of x.
#' @examples
#' rational_to_numeric("1/3200")
#' @export
#' @seealso \code{\link{read_exif_tags}}
rational_to_numeric <- function(x) {
  unlist(lapply(x, function(xx) {
    p = strsplit(xx, "/")
    as.numeric(unlist(p)[1]) / as.numeric(unlist(p)[2])}))
}

#' @export
rationalDMS_to_decimal <- function(dms, .split = " ") {
  comp <- lapply(dms, function(d) {
    unlist(lapply(strsplit(d, fixed = TRUE, .split)[[1]],
                  EXIFr::rational_to_numeric))
  })
  res <- lapply(comp, function(i) { i[[1]] + i[[2]]/60 + i[[3]]/3600 })
  return(as.numeric(res))
}