#' Parse Place
#'
#' @param x Expects "NAME" variable.
#'
#' @return Character, removed suffixes.
#' @export
parse_place <- function(x){
  gsub("\\scity\\,\\s\\w+|\\sCDP\\,\\s\\w+|\\stown\\,\\s\\w+", "", x)
}