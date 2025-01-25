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

    ##                                                              Title
    ## 1                         Current Population Survey: Basic Monthly
    ## 2                         Current Population Survey: Basic Monthly
    ## 3                         Current Population Survey: Basic Monthly
    ## 4                         Current Population Survey: Basic Monthly
    ## 5                         Current Population Survey: Basic Monthly
    ## 6                         Current Population Survey: Basic Monthly
    ## 7  Current Population Survey Annual Social and Economic Supplement
    ## 8                         Current Population Survey: Basic Monthly
    ## 9                         Current Population Survey: Basic Monthly
    ## 10                        Current Population Survey: Basic Monthly
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Description
    ## 1                                                                                                                                                                                                To provide estimates of employment, unemployment, and other characteristics of the general labor force, of the population as a whole, and of various subgroups of the population. Monthly labor force data for the country are used by the  Bureau of Labor Statistics (BLS) to determine the distribution of funds under the Job Training Partnership Act. These data are collected through combined computer-assisted personal interviewing (CAPI) and computer-assisted telephone interviewing (CATI). In addition to the labor force data, the CPS basic funding provides annual data on work experience, income, health insurance, and migration data from the Annual Social and Economic Supplement (ASEC), and on school enrollment of the population from the October Supplement. Other supplements, some of which are sponsored by other agencies, are conducted biennially or intermittently.
    ## 2                                                                                                                                                                                                To provide estimates of employment, unemployment, and other characteristics of the general labor force, of the population as a whole, and of various subgroups of the population. Monthly labor force data for the country are used by the  Bureau of Labor Statistics (BLS) to determine the distribution of funds under the Job Training Partnership Act. These data are collected through combined computer-assisted personal interviewing (CAPI) and computer-assisted telephone interviewing (CATI). In addition to the labor force data, the CPS basic funding provides annual data on work experience, income, health insurance, and migration data from the Annual Social and Economic Supplement (ASEC), and on school enrollment of the population from the October Supplement. Other supplements, some of which are sponsored by other agencies, are conducted biennially or intermittently.
    ## 3                                                                                                                                                                                                To provide estimates of employment, unemployment, and other characteristics of the general labor force, of the population as a whole, and of various subgroups of the population. Monthly labor force data for the country are used by the  Bureau of Labor Statistics (BLS) to determine the distribution of funds under the Job Training Partnership Act. These data are collected through combined computer-assisted personal interviewing (CAPI) and computer-assisted telephone interviewing (CATI). In addition to the labor force data, the CPS basic funding provides annual data on work experience, income, health insurance, and migration data from the Annual Social and Economic Supplement (ASEC), and on school enrollment of the population from the October Supplement. Other supplements, some of which are sponsored by other agencies, are conducted biennially or intermittently.
    ## 4                                                                                                                                                                                                To provide estimates of employment, unemployment, and other characteristics of the general labor force, of the population as a whole, and of various subgroups of the population. Monthly labor force data for the country are used by the  Bureau of Labor Statistics (BLS) to determine the distribution of funds under the Job Training Partnership Act. These data are collected through combined computer-assisted personal interviewing (CAPI) and computer-assisted telephone interviewing (CATI). In addition to the labor force data, the CPS basic funding provides annual data on work experience, income, health insurance, and migration data from the Annual Social and Economic Supplement (ASEC), and on school enrollment of the population from the October Supplement. Other supplements, some of which are sponsored by other agencies, are conducted biennially or intermittently.
    ## 5                                                                                                                                                                                                To provide estimates of employment, unemployment, and other characteristics of the general labor force, of the population as a whole, and of various subgroups of the population. Monthly labor force data for the country are used by the  Bureau of Labor Statistics (BLS) to determine the distribution of funds under the Job Training Partnership Act. These data are collected through combined computer-assisted personal interviewing (CAPI) and computer-assisted telephone interviewing (CATI). In addition to the labor force data, the CPS basic funding provides annual data on work experience, income, health insurance, and migration data from the Annual Social and Economic Supplement (ASEC), and on school enrollment of the population from the October Supplement. Other supplements, some of which are sponsored by other agencies, are conducted biennially or intermittently.
    ## 6                                                                                                                                                                                                To provide estimates of employment, unemployment, and other characteristics of the general labor force, of the population as a whole, and of various subgroups of the population. Monthly labor force data for the country are used by the  Bureau of Labor Statistics (BLS) to determine the distribution of funds under the Job Training Partnership Act. These data are collected through combined computer-assisted personal interviewing (CAPI) and computer-assisted telephone interviewing (CATI). In addition to the labor force data, the CPS basic funding provides annual data on work experience, income, health insurance, and migration data from the Annual Social and Economic Supplement (ASEC), and on school enrollment of the population from the October Supplement. Other supplements, some of which are sponsored by other agencies, are conducted biennially or intermittently.
    ## 7  The Annual Social and Economic Supplement or March CPS supplement is the primary source of detailed information on income and work experience in the United States. Numerous publications based on this survey are issued each year by the Bureaus of Labor Statistics and Census. A public-use microdata file is available for private researchers, who also produce many academic and policy-related documents based on these data. The Annual Social and Economic Supplement is used to generate the annual Population Profile of the United States, reports on geographical mobility and educational attainment, and detailed analysis of money income and poverty status. The labor force and work experience data from this survey are used to profile the U.S. labor market and to make employment projections. To allow for the same type of in-depth analysis of hispanics, additional hispanic sample units are added to the basic CPS sample in March each year. Additional weighting is also performed so that estimates can be made for households and families, in addition to persons.
    ## 8                                                                                                                                                                                                To provide estimates of employment, unemployment, and other characteristics of the general labor force, of the population as a whole, and of various subgroups of the population. Monthly labor force data for the country are used by the  Bureau of Labor Statistics (BLS) to determine the distribution of funds under the Job Training Partnership Act. These data are collected through combined computer-assisted personal interviewing (CAPI) and computer-assisted telephone interviewing (CATI). In addition to the labor force data, the CPS basic funding provides annual data on work experience, income, health insurance, and migration data from the Annual Social and Economic Supplement (ASEC), and on school enrollment of the population from the October Supplement. Other supplements, some of which are sponsored by other agencies, are conducted biennially or intermittently.
    ## 9                                                                                                                                                                                                To provide estimates of employment, unemployment, and other characteristics of the general labor force, of the population as a whole, and of various subgroups of the population. Monthly labor force data for the country are used by the  Bureau of Labor Statistics (BLS) to determine the distribution of funds under the Job Training Partnership Act. These data are collected through combined computer-assisted personal interviewing (CAPI) and computer-assisted telephone interviewing (CATI). In addition to the labor force data, the CPS basic funding provides annual data on work experience, income, health insurance, and migration data from the Annual Social and Economic Supplement (ASEC), and on school enrollment of the population from the October Supplement. Other supplements, some of which are sponsored by other agencies, are conducted biennially or intermittently.
    ## 10                                                                                                                                                                                               To provide estimates of employment, unemployment, and other characteristics of the general labor force, of the population as a whole, and of various subgroups of the population. Monthly labor force data for the country are used by the  Bureau of Labor Statistics (BLS) to determine the distribution of funds under the Job Training Partnership Act. These data are collected through combined computer-assisted personal interviewing (CAPI) and computer-assisted telephone interviewing (CATI). In addition to the labor force data, the CPS basic funding provides annual data on work experience, income, health insurance, and migration data from the Annual Social and Economic Supplement (ASEC), and on school enrollment of the population from the October Supplement. Other supplements, some of which are sponsored by other agencies, are conducted biennially or intermittently.
    ##                        dataset
    ## 1                     acs/acs1
    ## 2            acs/acs1/cprofile
    ## 3             acs/acs1/profile
    ## 4                acs/acs1/pums
    ## 5              acs/acs1/pumspr
    ## 6  acs/acs1/sdataprofile/cd119
    ## 7                 acs/acs1/spp
    ## 8             acs/acs1/subject
    ## 9                     acs/acs5
    ## 10           acs/acs5/cprofile

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

    ## # A tibble: 17 × 7
    ##    NAME                              GEO_ID state county tract variable estimate
    ##    <chr>                             <chr>  <chr> <chr>  <chr> <chr>       <int>
    ##  1 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_001N      3291
    ##  2 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_002N      2530
    ##  3 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_003N      1862
    ##  4 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_004N        42
    ##  5 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_005N         1
    ##  6 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_006N       471
    ##  7 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_007N         4
    ##  8 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_008N         7
    ##  9 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_009N       143
    ## 10 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_010N       761
    ## 11 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_011N       159
    ## 12 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_012N         0
    ## 13 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_013N        13
    ## 14 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_014N        13
    ## 15 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_015N         0
    ## 16 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_016N       188
    ## 17 Census Tract 117.18; Orange Coun… 14000… 06    059    0117… P5_017N       388

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

    ## # A tibble: 3 × 6
    ##   NAME         state zip code tabulation …¹ `county (or part)` variable estimate
    ##   <chr>        <chr> <chr>                  <chr>              <chr>       <int>
    ## 1 Orange Coun… 06    92870                  059                P1_001N     52749
    ## 2 Orange Coun… 06    92886                  059                P1_001N     50001
    ## 3 Orange Coun… 06    90630                  059                P1_001N     49771
    ## # ℹ abbreviated name: ¹​`zip code tabulation area (or part)`

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

lll <- merge(lll, vars, by.x = "variable", by.y = "name")
```

    ##    variable                         NAME         GEO_ID state county estimate
    ## 1 PCT012001 San Mateo County, California 0500000US06081    06    081   718451
    ## 2 PCT012002 San Mateo County, California 0500000US06081    06    081   353168
    ## 3 PCT012003 San Mateo County, California 0500000US06081    06    081     4746
    ## 4 PCT012004 San Mateo County, California 0500000US06081    06    081     4673
    ## 5 PCT012005 San Mateo County, California 0500000US06081    06    081     4786
    ## 6 PCT012006 San Mateo County, California 0500000US06081    06    081     4743
    ##                       label    concept
    ## 1                     Total SEX BY AGE
    ## 2               Total!!Male SEX BY AGE
    ## 3 Total!!Male!!Under 1 year SEX BY AGE
    ## 4       Total!!Male!!1 year SEX BY AGE
    ## 5      Total!!Male!!2 years SEX BY AGE
    ## 6      Total!!Male!!3 years SEX BY AGE

**Resources:**

- [Datasets](https://www.census.gov/data/developers/data-sets/decennial-census.html)
  from Decennial 2020
- [API Key Signup](https://api.census.gov/data/key_signup.html)
- Other R packages that extract census data:
  - [tidycensus](https://walker-data.com/tidycensus/)
  - [censusapi](https://www.hrecht.com/censusapi/)
