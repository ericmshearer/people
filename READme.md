people
================

![](https://img.shields.io/badge/lifecycle-experimental-brightgreen.svg)
[![R-CMD-check](https://github.com/ericmshearer/people/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ericmshearer/people/actions/workflows/R-CMD-check.yaml)

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

- `year`: year of interest, character or numeric.
- `dataset`: need to specify api and table to pull from; ex: “dec/dhc”
  pulls from Decennial/Demographic and Housing Characteristics File. To
  view all available datasets for the year of interest, use
  `people::census_datasets(year = x)`.
- `geography`: currently works for census tract, zip code, places (aka
  city), county, or school district.
- `geo_id`: either zip code or place name. For places, use
  `people::get_places(county = "Orange")` to pull place codes for your
  jurisdiction. If you need to pull data for multiple geo_id’s, supply
  the argument a vector e.g. `geo_id = c("92701","92702")`.
- `var`: variable or group you want to extract. If you’re wanting a
  single variable, for example, set `var` equal to “P1_001N”. If you
  need a group, set `var` equal to “group(P5)”.
- `key`: your census API key, either specified as character or retrieved
  from `keyring`.
- `state`: two character state fips code.
- `county`: three character county fips code.

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

## Examples

### CA Department of Finance

``` r
oc_dof <- get_dof(fips = "059", dir = "C:\\Users\\user name\\Documents")

sm_dof <- get_dof(fips = "081")
```

### Setup

If you don’t know your jurisdictions FIPS code, `people::get_profile`
will provide you with your county and state codes. Do not add the word
“county” after your jurisdiction name. State should be a capitalized two
letter abbreviation.

``` r
profile <- get_profile(county = "Orange", state = "CA")

print(profile)
```

    ##   STATE    COUNTYNAME STATEFP COUNTYFP
    ## 1    CA Orange County      06      059

To see all available datasets for a given year, supply year to
`people::census_datasets`. Review the titles and descriptions, and when
you know which dataset you need, copy and paste dataset code (“x/x”) to
`people::vars_census` to view all available variables in that dataset.

``` r
cen_datasets <- census_datasets(year = 2023)

head(cen_datasets, 10)
```

    ##              Dataset
    ## 46             abscb
    ## 47            abscbo
    ## 48             abscs
    ## 49            absmcb
    ## 50           absnesd
    ## 51          absnesdo
    ## 18          acs/acs1
    ## 20 acs/acs1/cprofile
    ## 19  acs/acs1/profile
    ## 26     acs/acs1/pums
    ##                                                                                                     Title
    ## 46                                             2023 Annual Business Survey: Characteristics of Businesses
    ## 47                                        2023 Annual Business Survey: Characteristics of Business Owners
    ## 48                                                           2023 Annual Business Survey: Company Summary
    ## 49                                      2023 Annual Business Survey: Module Characteristics of Businesses
    ## 50                            2023 Nonemployer Statistics by Demographics Series (NES-D): Company Summary
    ## 51 2023 Nonemployer Statistics by Demographics Series (NES-D): Owner Characteristics of Nonemployer Firms
    ## 18                                                                             ACS 1-Year Detailed Tables
    ## 20                                                                         ACS 1-Year Comparison Profiles
    ## 19                                                                               ACS 1-Year Data Profiles
    ## 26                         2023 American Community Survey: 1-Year Estimates - Public Use Microdata Sample
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Description
    ## 46                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               The Annual Business Survey (ABS) provides information on selected economic and demographic characteristics for businesses and business owners by sex, ethnicity, race, and veteran status. Further, the survey measures research and development (for microbusinesses), new business topics such as innovation and technology, as well as other business characteristics. The U.S. Census Bureau and the National Center conduct the ABS jointly for Science and Engineering Statistics within the National Science Foundation. The ABS replaces the five-year Survey of Business Owners (SBO) for employer businesses, the Annual Survey of Entrepreneurs (ASE), the Business R&D and Innovation for Microbusinesses survey (BRDI-M), and the innovation section of the Business R&D and Innovation Survey (BRDI-S). https://www.census.gov/programs-surveys/abs.html
    ## 47                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               The Annual Business Survey (ABS) provides information on selected economic and demographic characteristics for businesses and business owners by sex, ethnicity, race, and veteran status. Further, the survey measures research and development (for microbusinesses), new business topics such as innovation and technology, as well as other business characteristics. The U.S. Census Bureau and the National Center conduct the ABS jointly for Science and Engineering Statistics within the National Science Foundation. The ABS replaces the five-year Survey of Business Owners (SBO) for employer businesses, the Annual Survey of Entrepreneurs (ASE), the Business R&D and Innovation for Microbusinesses survey (BRDI-M), and the innovation section of the Business R&D and Innovation Survey (BRDI-S). https://www.census.gov/programs-surveys/abs.html
    ## 48                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               The Annual Business Survey (ABS) provides information on selected economic and demographic characteristics for businesses and business owners by sex, ethnicity, race, and veteran status. Further, the survey measures research and development (for microbusinesses), new business topics such as innovation and technology, as well as other business characteristics. The U.S. Census Bureau and the National Center conduct the ABS jointly for Science and Engineering Statistics within the National Science Foundation. The ABS replaces the five-year Survey of Business Owners (SBO) for employer businesses, the Annual Survey of Entrepreneurs (ASE), the Business R&D and Innovation for Microbusinesses survey (BRDI-M), and the innovation section of the Business R&D and Innovation Survey (BRDI-S). https://www.census.gov/programs-surveys/abs.html
    ## 49                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               The Annual Business Survey (ABS) provides information on selected economic and demographic characteristics for businesses and business owners by sex, ethnicity, race, and veteran status. Further, the survey measures research and development (for microbusinesses), new business topics such as innovation and technology, as well as other business characteristics. The U.S. Census Bureau and the National Center conduct the ABS jointly for Science and Engineering Statistics within the National Science Foundation. The ABS replaces the five-year Survey of Business Owners (SBO) for employer businesses, the Annual Survey of Entrepreneurs (ASE), the Business R&D and Innovation for Microbusinesses survey (BRDI-M), and the innovation section of the Business R&D and Innovation Survey (BRDI-S). https://www.census.gov/programs-surveys/abs.html
    ## 50                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              The Nonemployer Statistics by Demographics (NES-D): Company Summary estimates provide economic data classified by sex, ethnicity, race, and veteran status of nonemployer firms. The NES-D is not a survey; rather, it leverages existing administrative records to assign demographic characteristics to the universe of nonemployer businesses. The nonemployer universe is comprised of businesses with no paid employment or payroll, annual receipts of $1,000 or more ($1 or more in the construction industries), and filing IRS tax forms for sole proprietorships (Form 1040, Schedule C), partnerships (Form 1065), or corporations (the Form 1120 series). Data for all firms are also presented. These estimates are produced by combining estimates for nonemployer firms from the Nonemployer Statistics by Demographics (NESD) and employer firms from the Annual Business Survey (ABS).
    ## 51                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   The Nonemployer Statistics by Demographics (NES-D): Characteristics of Business Owners estimates provide information on selected economic and demographic characteristics of business owners tabulated by sex, ethnicity, race, and veteran status of an owner. Included in the universe are nonemployer businesses with no paid employment or payroll, annual receipts of $1,000 or more ($1 or more in the construction industries) and filing IRS tax forms for sole proprietorships (Form 1040, Schedule C), partnerships (Form 1065), or corporations (the Form 1120 series).
    ## 18                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                The American Community Survey (ACS) is an ongoing survey that provides data every year -- giving communities the current information they need to plan investments and services. The ACS covers a broad range of topics about social, economic, demographic, and housing characteristics of the U.S. population. Much of the ACS data provided on the Census Bureau's Web site are available separately by age group, race, Hispanic origin, and sex. Summary files, Subject tables, Data profiles, and Comparison profiles are available for the nation, all 50 states, the District of Columbia, Puerto Rico, every congressional district, every metropolitan area, and all counties and places with populations of 65,000 or more. Detailed Tables contain the most detailed cross-tabulations published for areas 65k and more. The data are population counts. There are over 31,000 variables in this dataset.
    ## 20                                                                                                                                                                                                                                                                                                                                                                                                                                  The American Community Survey (ACS) is an ongoing survey that provides data every year -- giving communities the current information they need to plan investments and services. The ACS covers a broad range of topics about social, economic, demographic, and housing characteristics of the U.S. population. Much of the ACS data provided on the Census Bureau's Web site are available separately by age group, race, Hispanic origin, and sex. Summary files, Subject tables, Data profiles, and Comparison profiles are available for the nation, all 50 states, the District of Columbia, Puerto Rico, every congressional district, every metropolitan area, and all counties and places with populations of 65,000 or more. Comparison profiles are similar to Data profiles but also include comparisons with past-year data. The current year data are compared with each of the last four years of data and include statistical significance testing. There are over 1,000 variables in this dataset.
    ## 19 The American Community Survey (ACS) is a US-wide survey designed to provide communities a fresh look at how they are changing. The ACS replaced the decennial census long form in 2010 and thereafter by collecting long form type information throughout the decade rather than only once every 10 years. Questionnaires are mailed to a sample of addresses to obtain information about households -- that is, about each person and the housing unit itself. The American Community Survey produces demographic, social, housing and economic estimates in the form of 1 and 5-year estimates based on population thresholds. The strength of the ACS is in estimating population and housing characteristics. The data profiles provide key estimates for each of the topic areas covered by the ACS for the us, all 50 states, the District of Columbia, Puerto Rico, every congressional district, every metropolitan area, and all counties and places with populations of 65,000 or more. Although the ACS produces population, demographic and housing unit estimates, it is the Census Bureau's Population Estimates Program that produces and disseminates the official estimates of the population for the US, states, counties, cities and towns, and estimates of housing units for states and counties. For 2010 and other decennial census years, the Decennial Census provides the official counts of population and housing units.
    ## 26                                                                                                                                                                                                                                                                                                                        The American Community Survey (ACS) Public Use Microdata Sample (PUMS) contains a sample of responses to the ACS. The ACS PUMS dataset includes variables for nearly every question on the survey, as well as many new variables that were derived after the fact from multiple survey responses (such as poverty status). Each record in the file represents a single person, or, in the household-level dataset, a single housing unit. In the person-level file, individuals are organized into households, making possible the study of people within the contexts of their families and other household members. Individuals living in Group Quarters, such as nursing facilities or college facilities, are also included on the person file. ACS PUMS data are available at the nation, state, and Public Use Microdata Area (PUMA) levels. PUMAs are special non-overlapping areas that partition each state into contiguous geographic units containing roughly 100,000 people each. ACS PUMS files for an individual year, such as 2022, contain data on approximately one percent of the United States population.

``` r
cen_vars <- census_vars(year = 2023, dataset = "acs/acs1")

head(cen_vars, 10)
```

    ##             name
    ## 2            for
    ## 3             in
    ## 4          ucgid
    ## 5    B24022_060E
    ## 6   B19001B_014E
    ## 7  B07007PR_019E
    ## 8   B19101A_004E
    ## 9    B24022_061E
    ## 10  B19001B_013E
    ## 11 B07007PR_018E
    ##                                                                                                         label
    ## 2                                                                                Census API FIPS 'for' clause
    ## 3                                                                                 Census API FIPS 'in' clause
    ## 4                                                                  Uniform Census Geography Identifier clause
    ## 5           Estimate!!Total:!!Female:!!Service occupations:!!Food preparation and serving related occupations
    ## 6                                                                      Estimate!!Total:!!$100,000 to $124,999
    ## 7                  Estimate!!Total:!!Moved from different municipio:!!Foreign born:!!Naturalized U.S. citizen
    ## 8                                                                        Estimate!!Total:!!$15,000 to $19,999
    ## 9  Estimate!!Total:!!Female:!!Service occupations:!!Building and grounds cleaning and maintenance occupations
    ## 10                                                                       Estimate!!Total:!!$75,000 to $99,999
    ## 11                                           Estimate!!Total:!!Moved from different municipio:!!Foreign born:
    ##                                                                                                                                                                          concept
    ## 2                                                                                                                                             Census API Geography Specification
    ## 3                                                                                                                                             Census API Geography Specification
    ## 4                                                                                                                                             Census API Geography Specification
    ## 5  Sex by Occupation and Median Earnings in the Past 12 Months (in 2023 Inflation-Adjusted Dollars) for the Full-Time, Year-Round Civilian Employed Population 16 Years and Over
    ## 6                                                      Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars) (Black or African American Alone Householder)
    ## 7                                                                              Geographical Mobility in the Past Year by Citizenship Status for Current Residence in Puerto Rico
    ## 8                                                                             Family Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars) (White Alone Householder)
    ## 9  Sex by Occupation and Median Earnings in the Past 12 Months (in 2023 Inflation-Adjusted Dollars) for the Full-Time, Year-Round Civilian Employed Population 16 Years and Over
    ## 10                                                     Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars) (Black or African American Alone Householder)
    ## 11                                                                             Geographical Mobility in the Past Year by Citizenship Status for Current Residence in Puerto Rico

### 2020 Decennial Census

``` r
#Race/ethnicity data at the census tract level
ttt <- get_population(
  year = 2020,
  geography = "census tract",
  geo_id = "011718",
  var = "group(P5)",
  key = keyring::key_get("census_key"),
  state = "06",
  county = "059",
  dataset = "dec/dhc"
)
```

    ## [1] "Pulling data for geo_id: 011718"

    ## # A tibble: 17 × 9
    ##    NAME                 GEO_ID state county tract variable estimate source  year
    ##    <chr>                <chr>  <chr> <chr>  <chr> <chr>       <int> <chr>  <dbl>
    ##  1 Census Tract 117.18… 14000… 06    059    0117… P5_001N      3291 dec/d…  2020
    ##  2 Census Tract 117.18… 14000… 06    059    0117… P5_002N      2530 dec/d…  2020
    ##  3 Census Tract 117.18… 14000… 06    059    0117… P5_003N      1862 dec/d…  2020
    ##  4 Census Tract 117.18… 14000… 06    059    0117… P5_004N        42 dec/d…  2020
    ##  5 Census Tract 117.18… 14000… 06    059    0117… P5_005N         1 dec/d…  2020
    ##  6 Census Tract 117.18… 14000… 06    059    0117… P5_006N       471 dec/d…  2020
    ##  7 Census Tract 117.18… 14000… 06    059    0117… P5_007N         4 dec/d…  2020
    ##  8 Census Tract 117.18… 14000… 06    059    0117… P5_008N         7 dec/d…  2020
    ##  9 Census Tract 117.18… 14000… 06    059    0117… P5_009N       143 dec/d…  2020
    ## 10 Census Tract 117.18… 14000… 06    059    0117… P5_010N       761 dec/d…  2020
    ## 11 Census Tract 117.18… 14000… 06    059    0117… P5_011N       159 dec/d…  2020
    ## 12 Census Tract 117.18… 14000… 06    059    0117… P5_012N         0 dec/d…  2020
    ## 13 Census Tract 117.18… 14000… 06    059    0117… P5_013N        13 dec/d…  2020
    ## 14 Census Tract 117.18… 14000… 06    059    0117… P5_014N        13 dec/d…  2020
    ## 15 Census Tract 117.18… 14000… 06    059    0117… P5_015N         0 dec/d…  2020
    ## 16 Census Tract 117.18… 14000… 06    059    0117… P5_016N       188 dec/d…  2020
    ## 17 Census Tract 117.18… 14000… 06    059    0117… P5_017N       388 dec/d…  2020

``` r
# Total population at four zip codes
xxx <- get_population(
  year = 2020,
  geography = "zip code",
  geo_id = c("92870","92886","90630"),
  var = "P1_001N",
  key = keyring::key_get("census_key"),
  state = "06",
  county = "059",
  partial = TRUE,
  dataset = "dec/dhc"
  )
```

    ## [1] "Pulling data for geo_id: https://api.census.gov/data/2020/dec/dhc?get=P1_001N,NAME&for=county(orpart):059&in=state:06zipcodetabulationarea(orpart):92870&key=5787bcec1d4b4483a857642911bad64057bc3e94"
    ## [1] "Pulling data for geo_id: https://api.census.gov/data/2020/dec/dhc?get=P1_001N,NAME&for=county(orpart):059&in=state:06zipcodetabulationarea(orpart):92886&key=5787bcec1d4b4483a857642911bad64057bc3e94"
    ## [1] "Pulling data for geo_id: https://api.census.gov/data/2020/dec/dhc?get=P1_001N,NAME&for=county(orpart):059&in=state:06zipcodetabulationarea(orpart):90630&key=5787bcec1d4b4483a857642911bad64057bc3e94"

    ## # A tibble: 3 × 8
    ##   NAME  state zip code tabulation …¹ `county (or part)` variable estimate source
    ##   <chr> <chr> <chr>                  <chr>              <chr>       <int> <chr> 
    ## 1 Oran… 06    92870                  059                P1_001N     52749 dec/d…
    ## 2 Oran… 06    92886                  059                P1_001N     50001 dec/d…
    ## 3 Oran… 06    90630                  059                P1_001N     49771 dec/d…
    ## # ℹ abbreviated name: ¹​`zip code tabulation area (or part)`
    ## # ℹ 1 more variable: year <dbl>

### 2010 Decennial Census

``` r
vars <- census_vars(year = 2010, dataset = "dec/sf1")

# Total population for San Mateo County
lll <- get_population(
  year = 2010,
  geography = "county",
  var = "group(PCT12)",
  key = keyring::key_get("census_key"),
  state = "06",
  county = "081",
  dataset = "dec/sf1"
  )
```

    ## [1] "Pulling data for geo_id: 081"

``` r
lll <- merge(lll, vars, by.x = "variable", by.y = "name")
```

    ##    variable                         NAME         GEO_ID state county     NA
    ## 1 PCT012001 San Mateo County, California 0500000US06081    06    081 718451
    ## 2 PCT012002 San Mateo County, California 0500000US06081    06    081 353168
    ## 3 PCT012003 San Mateo County, California 0500000US06081    06    081   4746
    ## 4 PCT012004 San Mateo County, California 0500000US06081    06    081   4673
    ## 5 PCT012005 San Mateo County, California 0500000US06081    06    081   4786
    ## 6 PCT012006 San Mateo County, California 0500000US06081    06    081   4743
    ##    source year                     label    concept
    ## 1 dec/sf1 2010                     Total SEX BY AGE
    ## 2 dec/sf1 2010               Total!!Male SEX BY AGE
    ## 3 dec/sf1 2010 Total!!Male!!Under 1 year SEX BY AGE
    ## 4 dec/sf1 2010       Total!!Male!!1 year SEX BY AGE
    ## 5 dec/sf1 2010      Total!!Male!!2 years SEX BY AGE
    ## 6 dec/sf1 2010      Total!!Male!!3 years SEX BY AGE

**Resources:**

- [Datasets](https://www.census.gov/data/developers/data-sets/decennial-census.html)
  from Decennial 2020
- [API Key Signup](https://api.census.gov/data/key_signup.html)
- Other R packages that extract census data:
  - [tidycensus](https://walker-data.com/tidycensus/)
  - [censusapi](https://www.hrecht.com/censusapi/)
