#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @return The result of calling `rhs(lhs)`
NULL

drop_failed_calls <- function(list){
  responses <- sapply(list, function(x) httr::status_code(x), USE.NAMES = FALSE)
  throw_out <- which(responses != "200")
  
  if(length(throw_out) == 0){
    NULL
  } else {
    bad <- list[[throw_out]]
    bad_geo <- extract_geoid(bad$url)
    # bad_geo <- extract_geoid(bad_geo, start = ":", end = ".")
    cli::cli_alert_danger("Dropping API calls for {bad_geo}. Invalid geo_id.")
    list <- list[-throw_out]
  }
  return(list)
}

extract_geoid <- function(url){
  pass1 <- gsub(".*for\\=(.*)\\&.*", "\\1", url)
  out <- gsub(".*\\:(.*)\\.*", "\\1", pass1)
  return(out)
}

# drop_empties <- function(df){
#   df[, vapply(df, function(x) !all(is.na(x)), logical(1))]
# }

drop_empty_columns <- function(df){
  df <- df[,colSums(is.na(df)) < nrow(df)]
  return(df)
}

row_to_colheaders <- function(data, row_num = 1, check_dups = FALSE){
  if(check_dups){
    data <- data[!duplicated(as.list(data))] #remove repeating columns, only issue is with places?
    names(data) <- as.character(data[row_num,])
    data <- data[-row_num,]
  } else {
    names(data) <- as.character(data[row_num,])
    data <- data[-row_num,]
  }
  return(data)
}

json_to_df <- function(content, dups = FALSE){
  jsonlite::fromJSON(httr::content(content, as = "text", encoding = "UTF-8")) |>
    as.data.frame() |>
    row_to_colheaders(check_dups = dups)
}

estimate_to_numeric <- function(df, exclude_cols = NULL){
  if(is.null(exclude_cols)){
    exclude_cols <- character(0)
  }
  
  df[] <- lapply(names(df), function(col_name){
    col <- df[[col_name]]
    
    if(col_name %in% exclude_cols){
      return(col)
    }
    
    if(all(grepl("^\\d+$", na.omit(col)))){
      return(as.integer(col))
    } else {
      return(col)
    }
  })
  return(df)
}

recode_annotations <- function(list_df){
  list_df %>%
    replace(. %in% c("*****","-555555555"), 0) %>%
    replace(. %in% c("-888888888","-999999999"), NA)
}

# drop_columns_junk <- function(list, contains){
#   list <- lapply(list, function(df){
#     cols_to_drop <- sapply(df, function(col) any(col %in% contains))
#     df <- df[,!cols_to_drop, drop = FALSE]
#     return(df)
#   })
#   return(list)
# }

return_as_df <- function(list){
  list <- lapply(list, estimate_to_numeric, exclude_cols = c("state","county","school district (unified)","tract","county (or part)","zip code tabulation area","zip code tabulation area (or part)","place"))
  out <- as.data.frame(do.call(rbind, list))
  rownames(out) <- NULL
  return(out)
}

build_url <- function(year = 2020, geography, geo_id, var, key, partial = FALSE, fips, state, dataset){
  # if(year == 2020){
  #   base <- paste("https://api.census.gov/data", as.character(year), api, dataset, sep = "/")
  # } else if (year == 2010){
  #   base <- paste("https://api.census.gov/data", as.character(year), "dec", "sf1", sep = "/")
  # } else {
  #   stop("Year not availale.")
  # }
  
  base <- base_api(year = year, dataset = dataset)
  
  vars_to_get <- paste0(var, ",NAME")
  
  geography <- trimws(tolower(geography))
  
  if(geography %in% c("tract","census tract","ctract")){
    url <- sprintf("%s?get=%s&for=tract:%s&in=state:%s&in=county:%s&key=%s", base, vars_to_get, geo_id, state, fips, key)
  }
  
  if(geography %in% c("zip code","zip","zips","zcta") & partial){
    url <- sprintf("%s?get=%s&for=county (or part):%s&in=state:%s zip code tabulation area (or part):%s&key=%s", base, vars_to_get, fips, state, geo_id, key)
  } else if (geography %in% c("zip code","zip","zips","zcta") && partial == FALSE) {
    url <- sprintf("%s?get=%s&for=zip code tabulation area:%s&key=%s", base, vars_to_get, geo_id, key)
  }
  
  if(geography %in% c("city","cities","place","places")){
    url <- sprintf("%s?get=%s&for=place:%s&in=state:%s&key=%s", base, vars_to_get, geo_id, state, key)
  }
  
  if(geography == "county"){
    url <- sprintf("%s?get=%s&for=county:%s&in=state:%s&key=%s", base, vars_to_get, fips, state, key)
  }
  
  if(geography == "school district"){
    url <- sprintf("%s?get=%s&for=school district (unified):*&in=state:%s&key=%s", base, vars_to_get, state, key)
  }
  
  return(url)
}

base_api <- function(year = 2020, dataset = "dec/dhc"){
  base <- "https://api.census.gov/data"
  
  df <- jsonlite::fromJSON(sprintf("https://api.census.gov/data/%s/", year)) %>%
    as.data.frame()
  options <- sort(sapply(df$dataset.c_dataset, paste0, collapse = "/"))
  
  dataset <- options[options == dataset]
  
  if(length(dataset) == 0){
    cli::cli_abort("Dataset not available.")
  } else {
    url <- paste(base, year, dataset, sep = "/")
  }
  return(url)
}