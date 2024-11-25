people
================

![](https://img.shields.io/badge/lifecycle-experimental-brightgreen.svg)
This experimental package will extract common population datasets from
the Decennial Census (Demographic and Housing Characteristics File) as
well as CA Department of Finance. While there are many interesting data
points from the Census, the purpose of this package is to quickly pull
denominator data. A list of other R packages that extract Census data
are listed below in the resources section.

*An API key is required*. If you don’t have one, you can request (for
free) from <https://api.census.gov/data/key_signup.html>. **Do not share
this key with anyone**. You may elect to store your API key using a
package like [keyring](https://r-lib.github.io/keyring/index.html), but
research all packages and their strengths/weaknesses for security.

## Overview

The primary function to retrieve data from the 2020 decennial census is
`people::get_population`. To retrieve data, specify the following
arguments:

- `geography`: currently works for census tract, zip code, places (aka
  city), county, or school district.
- `geo_id`: either zip code or place name. For places, use
  `people::get_places(county = "Orange")` to pull place codes for your
  jurisdiction. If you need to pull data for multiple geo_id’s, supply
  the argument a vector e.g. `geo_id = c("92701","92702")`.
- `var`: variable or group you want to extract. For most purposes, you
  can use P1_001N for total population, group(P5) for race/ethnicity,
  group(P12) for age groups and gender, or group(PCT12) for single age
  year and gender.
- `key`: your census API key, either specified as character or retrieved
  from `keyring`.
- `state`: two character state code.
- `fips`: three character fips code.

Bonus argument - if pulling data at the zip code, you can use
`partial = TRUE` to get data that falls within your jurisdiction. This
is particularly useful for zip codes that border neighboring
jurisdictions where you might share populations. All other geographies
ignore this argument.

For epidemiologists/research analysts working in California,
`people::get_dof` will import the latest P3 file from the Department of
Finance. This function has two arguments:

- `fips`: three character fips code. If you specify your fips code, the
  P3 file will be filtered for your jurisdiction’s data. Otherwise, the
  entire dataset is imported.
- `dir`: directory where you want the P3 file saved. If you don’t
  specify one, a temporary directory will be created.

## Helpers

If you don’t know your jurisdictions FIPS code, `people::get_profile`
will provide you with your county and state codes. Do not add the word
“county” after your jurisdiction name, and state should be capitalized
two letter abbreviation.

``` r
profile <- get_profile(county = "Orange", state = "CA")

print(profile)
```

    ##   STATE    COUNTYNAME STATEFP COUNTYFP
    ## 1    CA Orange County      06      059

Data returned from the Census API contains variable names that are not
immediately obvious e.g. P1_001N for total population.
`people::vars_census` will return a data frame of all variables with
labels from the 2020 Decennial Census Demographic and Housing
Characteristics File. After reshaping data from wide to long, you can
join the variable labels to census extraction for further processing.

``` r
census_vars <- vars_census()
```

## Examples

### CA Department of Finance

``` r
oc_dof <- get_dof(fips = "059", dir = "C:\\Users\\user name\\Documents")

sm_dof <- get_dof(fips = "081")
```

### 2020 Decennial Census

``` r
#Race/ethnicity data at the census tract level

ttt <- get_population(
  geography = "census tract",
  geo_id = "011718",
  var = "group(P5)",
  key = keyring::key_get("census_key"),
  state = "06",
  fips = "059"
)

print(ttt)
```

    ##                                             NAME               GEO_ID P5_001N
    ## 1 Census Tract 117.18; Orange County; California 1400000US06059011718    3291
    ##   P5_002N P5_003N P5_004N P5_005N P5_006N P5_007N P5_008N P5_009N P5_010N
    ## 1    2530    1862      42       1     471       4       7     143     761
    ##   P5_011N P5_012N P5_013N P5_014N P5_015N P5_016N P5_017N state county  tract
    ## 1     159       0      13      13       0     188     388    06    059 011718

``` r
# Total population at four zip codes
xxx <- get_population(
   geography = "zip code",
   geo_id = c("92862","92870","92886","90630"),
   var = "P1_001N",
   key = keyring::key_get("census_key"),
   state = "06",
   fips = "059",
   partial = TRUE
   )

print(xxx)
```

    ##   P1_001N                                          NAME state
    ## 1   52749 Orange County (part), ZCTA5 92870, California    06
    ## 2   50001 Orange County (part), ZCTA5 92886, California    06
    ## 3   49771 Orange County (part), ZCTA5 90630, California    06
    ##   zip code tabulation area (or part) county (or part)
    ## 1                              92870              059
    ## 2                              92886              059
    ## 3                              90630              059

``` r
# Total population for San Mateo county cities

san_mateo_cities <- get_places(county = "San Mateo")

lll <- get_population(
  geography = "City",
  geo_id = san_mateo_cities,
  var = "P1_001N",
  key = keyring::key_get("census_key"),
  state = "06",
  fips = "081"
)

print(lll)
```

    ##    P1_001N                                 NAME state place
    ## 1     7188            Atherton town, California    06 03092
    ## 2     1693         Baywood Park CDP, California    06 04549
    ## 3    28335             Belmont city, California    06 05108
    ## 4     4851            Brisbane city, California    06 08310
    ## 5     4411            Broadmoor CDP, California    06 08338
    ## 6    31386          Burlingame city, California    06 09066
    ## 7     1507               Colma town, California    06 14736
    ## 8   104901           Daly City city, California    06 17918
    ## 9    30034      East Palo Alto city, California    06 20956
    ## 10    5481           El Granada CDP, California    06 21936
    ## 11    4406   Emerald Lake Hills CDP, California    06 22587
    ## 12   33805         Foster City city, California    06 25338
    ## 13   11795       Half Moon Bay city, California    06 31708
    ## 14    2359            Highlands CDP, California    06 33632
    ## 15   11387        Hillsborough town, California    06 33798
    ## 16    1557               Ladera CDP, California    06 39094
    ## 17     979             La Honda CDP, California    06 39318
    ## 18     134             Loma Mar CDP, California    06 42384
    ## 19   33780          Menlo Park city, California    06 46870
    ## 20   23216            Millbrae city, California    06 47486
    ## 21    2833              Montara CDP, California    06 48760
    ## 22    3214           Moss Beach CDP, California    06 49446
    ## 23   14027      North Fair Oaks CDP, California    06 51840
    ## 24   38640            Pacifica city, California    06 54806
    ## 25     595            Pescadero CDP, California    06 56756
    ## 26    4456      Portola Valley town, California    06 58380
    ## 27   84292        Redwood City city, California    06 60102
    ## 28   43908           San Bruno city, California    06 65028
    ## 29   30722          San Carlos city, California    06 65070
    ## 30  105661           San Mateo city, California    06 68252
    ## 31   66105 South San Francisco city, California    06 73262
    ## 32    3930      West Menlo Park CDP, California    06 84536
    ## 33    5309            Woodside town, California    06 86440

**Resources:**

- [Datasets](https://www.census.gov/data/developers/data-sets/decennial-census.html)
  from Decennial 2020
- [API Key Signup](https://api.census.gov/data/key_signup.html)
- Other R packages that extract census data:
  - [tidycensus](https://walker-data.com/tidycensus/)
  - [censusapi](https://www.hrecht.com/censusapi/)
