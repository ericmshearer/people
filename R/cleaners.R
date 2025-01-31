#' Parse Variable Label
#'
#' @param x Expects "name" variable from variable list.
#'
#' @return Character.
#' @export
parse_label <- function(x){
  x <- gsub("^Estimate!!Total:!!", "", x)
  x <- gsub("^Estimate!!", "", x)
  x <- gsub("^!!Total:!!", "", x)
  x <- gsub("\\:$|^!!", "", x)
  return(x)
}

#' Parse Place
#'
#' @param x Expects "NAME" variable.
#'
#' @return Character, removed suffixes.
#' @export
parse_place <- function(x){
  gsub("\\scity\\,\\s\\w+|\\sCDP\\,\\s\\w+|\\stown\\,\\s\\w+", "", x)
}