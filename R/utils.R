#' @title rational_to_numeric
#' @description Converts rational numbers from RATIONAL/character string to a floating point representation
#'
#' @param x A vector of character strings containing rational numbers to convert.
#' @return A vector of floating point values corresponding to \code{x}.
#' @author Charles Martin & Andrew G. Brown
#' @examples
#' rational_to_numeric("1/3200")
#' @export
#' @seealso \code{\link{read_exif_tags}}
rational_to_numeric <- function(x) {
  unlist(lapply(x, function(xx) {
    p = strsplit(xx, "/")
    as.numeric(unlist(p)[1]) / as.numeric(unlist(p)[2])}))
}

#' Convert rational degrees, minutes, seconds to decimal degrees.
#' @description Convert sets of three rational numbers representing degrees,
#' minutes, and seconds to floating point values reflecting coordinate in
#' decimal degrees.
#' @param x Coordinates in rational expression of degrees, minutes and seconds to convert; a vector of character strings with each element of \code{x} containing three rational numbers separated by \code{.split}
#' @param .split Delimiter separating the rational numbers (degrees, minutes and seconds in \code{x}).
#' @return Coordinates in decimal degrees. A vector of floating point values.
#' @author Andrew G. Brown
#' @examples
#' rationalDMS_to_decimal(c("120/1 17/1 1571/50"))
#' @export
#' @seealso \code{\link{read_exif_tags}}
#' @export
rationalDMS_to_decimal <- function(dms, .split = " ") {
  comp <- lapply(dms, function(d) {
    unlist(lapply(strsplit(d, fixed = TRUE, .split)[[1]],
                  EXIFr::rational_to_numeric))
  })
  res <- lapply(comp, function(i) { i[[1]] + i[[2]]/60 + i[[3]]/3600 })
  return(as.numeric(res))
}