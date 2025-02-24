% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/decennial.R
\name{get_population}
\alias{get_population}
\title{Extract Decennial Census Data}
\usage{
get_population(
  year = 2020,
  geography,
  geo_id,
  var,
  key,
  partial = FALSE,
  county,
  state = "06",
  dataset = "dec/dhc"
)
}
\arguments{
\item{year}{Currently limited to 2020.}

\item{geography}{Character, current options: census tract, zip code, places, or county.}

\item{geo_id}{Character, either zip code or place codes.}

\item{var}{Character, individual variable or group.}

\item{key}{Character, census api token.}

\item{partial}{Logical, only applicable to zip codes.}

\item{county}{Character, length of 3.}

\item{state}{Character, length of 2.}

\item{dataset}{Character, api/table.}
}
\value{
Data.frame with population data from decennial census.
}
\description{
Extract Decennial Census Data
}
