#' Find CA Places Codes
#'
#' @param county Character, title casing.
#'
#' @return Character, place codes.
#' @importFrom utils read.delim
#' @export
get_places <- function(county = "Orange"){
  codes <- read.delim("https://www2.census.gov/geo/docs/reference/codes2020/place/st06_ca_place2020.txt", sep = "|", colClasses = "character")
  codes <- codes[codes$COUNTIES == paste(county, "County"),]
  codes <- codes[["PLACEFP"]]
  return(codes)
}

#' Find County or State Code
#'
#' @param county Character, do not include word "county".
#' @param state Character, two letter abbreviation.
#'
#' @return Data.frame with four columns.
#' @importFrom utils read.csv
#' @importFrom tools toTitleCase
#' @importFrom stats na.omit
#' @export
get_profile <- function(county, state = "CA"){
  
  county <- paste(toTitleCase(county), "County")
  state <- toupper(state)
  
  codes <- read.csv("https://www2.census.gov/geo/docs/reference/codes/COUSUBlist.txt", colClasses = "character")
  codes <- codes[codes$STATE == state & codes$COUNTYNAME == county,]
  
  out <- codes[c(1),c("STATE","COUNTYNAME","STATEFP","COUNTYFP")]
  rownames(out) <- NULL
  return(out)
}

#' Census Variables
#'
#' @param year Character or integer, four characters in length.
#'
#' @return Data.frame, 3 columns.
#' @importFrom jsonlite fromJSON
#' @export
vars_census <- function(year = 2020){
  
  if(!inherits(year, "character")){
    year <- as.character(year)
  }
  
  var_url <- list(
    `2010` = "/dec/sf1/variables",
    `2020` = "/dec/dhc/variables"
  )
  
  base <- "https://api.census.gov/data/"
  
  url <- paste0(base, as.character(year), var_url[year])
  
  df <- jsonlite::fromJSON(url) %>%
    as.data.frame() |>
    row_to_colheaders()
  return(df)
}

#' Extract Decennial Census Data
#'
#' @param year Currently limited to 2020.
#' @param geography Character, current options: census tract, zip code, places, or county.
#' @param geo_id Character, either zip code or place codes.
#' @param var Character, individual variable or group.
#' @param key Character, census api token.
#' @param partial Logical, only applicable to zip codes.
#' @param fips Character, length of 3.
#' @param state Character, length of 2.
#'
#' @return Data.frame with population data from decennial census.
#' @export
get_population <- function(year = 2020, geography, geo_id, var, key, partial = FALSE, fips, state){
  
  if(missing(geo_id) && geography %in% c("county","school district")){
    geo_id <- "*"
  }
  
  cli::cli_alert("Preparing to fetch Census data...")
  
  urls <- sapply(geo_id, function(x) {build_url(year = year, geography = geography, geo_id = x, var = var, partial = partial, fips = fips, state = state, key = key)}, USE.NAMES = FALSE)
  
  urls <- sapply(urls, function(x) gsub("\\s", "%20", x), USE.NAMES = FALSE)
  
  # original <- purrr::map(urls, httr::GET)
  
  # original <- purrr::map(urls, httr::GET) %>%
  #   drop_failed_calls() %>%
  #   lapply(json_to_df, dups = TRUE) %>%
  #   purrr::map_dfr(drop_empties)
  
  original <- lapply(urls, httr::GET) %>%
    drop_failed_calls() %>%
    lapply(json_to_df, dups = TRUE) %>%
    lapply(drop_empties) %>%
    return_as_df()
  
  if(geography == "school district" & !missing(geo_id)){
    original <- original[grepl(geo_id, original$NAME, ignore.case = TRUE),]
  }
  
  return(original)
}

#' Extract P3 Data
#'
#' @param fips Character, length of three.
#' @param dir Full path, if NULL will use temporary directory.
#'
#' @return Data.frame with 6 columns.
#' @export
#' @importFrom cli cli_alert
#' @importFrom cli cli_alert_success
#' @importFrom utils read.csv
#' @importFrom utils download.file
#' @importFrom utils unzip
get_dof <- function(fips, dir){
  
  fips <- sprintf("6%s", fips)
  
  cli::cli_alert("Preparing to download P3 file...")
  
  if(missing(dir)) {
    dir <- tempdir()
  }
  
  if(!dir.exists(dir)){
    stop("Directory does not exist.")
  }
  
  tf = tempfile(tmpdir = dir, fileext = ".zip")
  
  utils::download.file("https://dof.ca.gov/wp-content/uploads/sites/352/2024/10/P3_Complete.zip", tf, quiet = TRUE)
  file_name = utils::unzip(tf, list = TRUE)$Name[1]
  utils::unzip(tf, files = file_name, exdir = dir, overwrite = TRUE)
  
  if(file.exists(file.path(dir, file_name))){
    cli::cli_alert_success("Download successful. File now importing...")
  } else {
    stop("Error in file download.")
  }
  
  data <- utils::read.csv(file.path(dir, file_name), na.strings = "", colClasses = "character")
  
  if(!missing(fips)){
    data <- data[data$fips == fips,]
  }
  
  file.remove(tf)
  names(data) <- c("fips","year","sex","race","age","estimate")
  return(data)
}