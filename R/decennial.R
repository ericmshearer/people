#' Find CA Places Codes
#'
#' @param county Character, title casing.
#' @param state Character, length of two capitalized.
#'
#' @return Character, place codes.
#' @importFrom utils read.delim
#' @export
get_places <- function(county = "Orange", state = "CA"){
  ppp <- get_profile(county, state)
  
  state <- tolower(state)
  
  codes <- read.delim(sprintf("https://www2.census.gov/geo/docs/reference/codes2020/place/st%s_%s_place2020.txt", ppp$STATEFP, state), sep = "|", colClasses = "character")
  codes <- codes[codes$COUNTIES == paste(county, "County"),]
  
  stopifnot("Warning: no place codes found." = nrow(codes) > 1)
  
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
#' @param dataset Dataset of interest. Example: dec/dhc.
#'
#' @return Data.frame, 3 columns.
#' @importFrom jsonlite fromJSON
#' @export
census_vars <- function(year = 2020, dataset = "dec/dhc"){
  
  if(!inherits(year, "character")){
    year <- as.character(year)
  }
  
  url <- base_api(year = year, dataset = dataset)
  url <- paste(url, "variables", sep = "/")
  
  df <- jsonlite::fromJSON(url) %>%
    as.data.frame() |>
    row_to_colheaders()
  
  # if(substr(dataset,1,3) %in% c("acs","dec")){
  #   df <- df[grepl("[[:digit:]][[:alpha:]]$", df$name),]
  # }
  
  return(df)
}

#' View Census Datasets
#'
#' @param year Character or numeric, year of interest.
#'
#' @return Data frame with three columns.
#' @export
census_datasets <- function(year){
  df <- jsonlite::fromJSON(sprintf("https://api.census.gov/data/%s/", year)) %>%
    as.data.frame()
  options <- sort(sapply(df$dataset.c_dataset, paste0, collapse = "/"))
  df <- df[,c("dataset.title","dataset.description")]
  df <- cbind(df, options)
  colnames(df) <- c("Title","Description","dataset")
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
#' @param county Character, length of 3.
#' @param state Character, length of 2.
#' @param dataset Character, api/table.
#'
#' @return Data.frame with population data from decennial census.
#' @export
#' @importFrom tidyr pivot_wider
#' @importFrom tidyr pivot_longer
#' @importFrom cli cli_alert_warning
#' @importFrom purrr discard_at
#' @importFrom httr GET
get_population <- function(year = 2020, geography, geo_id, var, key, partial = FALSE, county, state = "06", dataset = "dec/dhc"){
  
  if(missing(geo_id) && geography %in% c("county","school district")){
    geo_id <- "*"
  }
  
  cli::cli_alert("Preparing to fetch Census data...")
  
  urls <- sapply(geo_id, function(x) {build_url(year = year, geography = geography, geo_id = x, var = var, partial = partial, county = county, state = state, key = key, dataset = dataset)}, USE.NAMES = FALSE)
  
  urls <- sapply(urls, function(x) gsub("\\s", "%20", x), USE.NAMES = FALSE)
  
  original <- lapply(urls, call_api) %>%
    drop_failed_calls() %>%
    lapply(json_to_df, dups = TRUE) %>%
    lapply(recode_annotations) %>%
    lapply(drop_empty_columns) %>%
    return_as_df()
  
  if(geography == "school district" & !missing(geo_id)){
    original <- original[grepl(geo_id, original$NAME, ignore.case = TRUE),]
  }
  
  original <- pivot_census(original)

  original <- original[, colSums(original != 0) > 0]

  if(substr(dataset,1,3) == "acs"){
    original$variable <- sprintf("%sE", original$variable)
  }

  if(substr(dataset,1,3) == "dec" & year == 2020){
    original$variable <- sprintf("%sN", original$variable)
  }
  
  original$source <- dataset
  original$year <- year

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
#' @importFrom cli cli_abort
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
    cli::cli_abort("Directory does not exist.")
  }
  
  tf = tempfile(tmpdir = dir, fileext = ".zip")
  
  utils::download.file("https://dof.ca.gov/wp-content/uploads/sites/352/2024/10/P3_Complete.zip", tf, quiet = TRUE)
  file_name = utils::unzip(tf, list = TRUE)$Name[1]
  utils::unzip(tf, files = file_name, exdir = dir, overwrite = TRUE)
  
  if(file.exists(file.path(dir, file_name))){
    cli::cli_alert_success("Download successful. File now importing...")
  } else {
    cli::cli_abort("Error in file download.")
  }
  
  data <- utils::read.csv(file.path(dir, file_name), na.strings = "", colClasses = "character")
  
  if(!missing(fips)){
    data <- data[data$fips == fips,]
  }
  
  file.remove(tf)
  names(data) <- c("fips","year","sex","race","age","estimate")
  return(data)
}