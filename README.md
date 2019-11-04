
# canadaHCD
Access Canadian Historical Climate Data from R. The Government of Canada's Historical Climate Data [website](http://climate.weather.gc.ca/index_e.html) provides access to hourly, daily, and monthly weather records for stations throughout Canada.

These are raw data that have undergone some quality control, but issues such as changes in station location are unmanged; the data for the original `stationID` stops at a certain point and a new `stationID` continues recording. For a more curated data set for climate change research at broad spatial and temporal scales see the [Adjusted and Homogenized Canadian Climate Data (AHCCD)](http://ec.gc.ca/dccha-ahccd/default.asp?lang=En&n=B1F8423A-1).

#### Released version
[![CRAN version](http://www.r-pkg.org/badges/version/canadaHCD)](https://cran.r-project.org/package=canadaHCD) [![](http://cranlogs.r-pkg.org/badges/grand-total/canadaHCD)](https://cran.r-project.org/package=canadaHCD)

#### Build status
[![Build Status](https://travis-ci.org/gavinsimpson/canadaHCD.svg?branch=master)](https://travis-ci.org/gavinsimpson/canadaHCD)  [![Build status](https://ci.appveyor.com/api/projects/status/e3ptg9drviavci71/branch/master?svg=true)](https://ci.appveyor.com/project/gavinsimpson/canadahcd/branch/master)  [![codecov.io](https://codecov.io/github/gavinsimpson/canadaHCD/coverage.svg?branch=master)](https://codecov.io/github/gavinsimpson/canadaHCD?branch=master)

## Installation

*canadaHCD* is still under active development towards a 0.1 release. In the meantime, if you wish to use the package, please install it from this github repo, which is most easily achieved using Hadley Wickham's *devtools* package:


```r
## install.packages("devtools")
devtools::install_github("gavinsimpson/canadaHCD")
```

## Usage

Say I'm interested in climate data for stations in Yellowknife, I can search for all known `stationID`s with `"Yellowknife"` in their name using `find_station()`


```r
library("canadaHCD")
find_station("Yellowknife")
#> # A tibble: 7 x 5
#>   Name                  Province              StationID LatitudeDD
#>   <fct>                 <fct>                 <fct>          <dbl>
#> 1 YELLOWKNIFE A         Northwest Territories 1706            62.5
#> 2 YELLOWKNIFE A         Northwest Territories 51058           62.5
#> 3 YELLOWKNIFE OVERLAP   Northwest Territories 53898           62.5
#> 4 YELLOWKNIFE-HENDERSON Northwest Territories 45467           62.4
#> 5 YELLOWKNIFE CON MINE  Northwest Territories 8949            62.5
#> 6 YELLOWKNIFE CS        Northwest Territories 27338           62.5
#> 7 YELLOWKNIFE HYDRO     Northwest Territories 1707            62.7
#>   LongitudeDD
#>         <dbl>
#> 1       -114.
#> 2       -114.
#> 3       -114.
#> 4       -114.
#> 5       -114.
#> 6       -114.
#> 7       -114.
```

To download the monthly HCD from `YELLOWKNIFE HYDRO` I can use `hcd_monthly()`, providing it with the `StationID` for that particular weather station


```r
yh <- hcd_monthly(1707)
```

The data are returned as a [*tibble*](https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html) (a `tbl_df`), which shows a compact version of the data frame.


```r
yh
#> # A tibble: 690 x 16
#>    Station StationID Longitude Latitude Date  MaxTemp MinTemp MeanTemp
#>    <chr>   <chr>         <dbl>    <dbl> <yea>   <dbl>   <dbl>    <dbl>
#>  1 YELLOW… 2204200       -114.     62.7 Jan …    NA      NA       NA  
#>  2 YELLOW… 2204200       -114.     62.7 Feb …   -16.2   -26.4    -21.3
#>  3 YELLOW… 2204200       -114.     62.7 Mar …   -14.4   -29.4    -21.9
#>  4 YELLOW… 2204200       -114.     62.7 Apr …     1.2   -12.3     -5.6
#>  5 YELLOW… 2204200       -114.     62.7 May …     9.3    -3.6      2.9
#>  6 YELLOW… 2204200       -114.     62.7 Jun …    17.6     2.4     10  
#>  7 YELLOW… 2204200       -114.     62.7 Jul …    20.6     9.6     15.1
#>  8 YELLOW… 2204200       -114.     62.7 Aug …    18.9     7.2     13.1
#>  9 YELLOW… 2204200       -114.     62.7 Sep …    10.9     2        6.5
#> 10 YELLOW… 2204200       -114.     62.7 Oct …     6.1    -1.9      2.1
#>    ExtremeHigh ExtremeLow TotalRain TotalSnow TotalPrecip LastSnowGrnd
#>          <dbl>      <dbl>     <dbl>     <dbl>       <dbl>        <int>
#>  1        NA         NA        NA        NA          NA             NA
#>  2         1.1      -44.4       0         9.4         9.4           NA
#>  3        -3.3      -40.6       0         2.8         2.8           NA
#>  4        12.2      -31.7       0        18          18             NA
#>  5        20        -11.7       9.9       2.8        12.7           NA
#>  6        27.2       -1.7       4.8       0           4.8           NA
#>  7        27.2        4.4      36.6       0          36.6           NA
#>  8        27.2        1.7      17.8       0          17.8           NA
#>  9        18.3       -6.1       5.8       2.8         8.6           NA
#> 10        17.2      -15.6      19.1       5.1        24.1           NA
#> # … with 680 more rows, and 2 more variables: MaxGustDir <int>,
#> #   MaxGustSpeed <chr>
```

You should be able to work with these objects mostly as if they were data frames.

Allthough not yet exposed through any functions in the package, you can access a snapshot of the station metadata via the `canadaHCD:::station_data` data frame.


```r
canadaHCD:::station_data
#> # A tibble: 12,565 x 19
#>    Name  Province ClimateID StationID WMOID TCID  LatitudeDD LongitudeDD
#>    <fct> <fct>    <fct>     <fct>     <fct> <fct>      <dbl>       <dbl>
#>  1 ACTI… British… 1010066   14        <NA>  <NA>        48.9       -123.
#>  2 ALBE… British… 1010235   15        <NA>  <NA>        48.4       -123.
#>  3 BAMB… British… 1010595   16        <NA>  <NA>        48.6       -124.
#>  4 BEAR… British… 1010720   17        <NA>  <NA>        48.5       -124 
#>  5 BEAV… British… 1010774   18        <NA>  <NA>        48.5       -123.
#>  6 BECH… British… 1010780   19        <NA>  <NA>        48.3       -124.
#>  7 BREN… British… 1010960   20        <NA>  <NA>        48.6       -123.
#>  8 BREN… British… 1010961   21        <NA>  <NA>        48.6       -123.
#>  9 BREN… British… 1010965   22        <NA>  <NA>        48.6       -123.
#> 10 BEAR… British… 1010PJR   9634      <NA>  <NA>        48.5       -124.
#>    Latitude Longitude Elevation FirstYear LastYear HourlyFirstYr
#>       <int>     <int>     <dbl>     <int>    <int>         <int>
#>  1   4.85e8   -1.23e9       4        1984     1996            NA
#>  2   4.82e8   -1.23e9      17        1971     1995            NA
#>  3   4.84e8   -1.23e9      85.3      1961     1980            NA
#>  4   4.83e8   -1.24e9     350.       1910     1971            NA
#>  5   4.83e8   -1.23e9      61        1894     1952            NA
#>  6   4.82e8   -1.23e9      12.2      1956     1966            NA
#>  7   4.84e8   -1.23e9      38        1987     1997            NA
#>  8   4.83e8   -1.23e9      30.5      1972     1980            NA
#>  9   4.83e8   -1.23e9      91.4      1960     1970            NA
#> 10   4.83e8   -1.24e9     419          NA       NA            NA
#> # … with 12,555 more rows, and 5 more variables: HourlyLastYr <int>,
#> #   DailyFirstYr <int>, DailyLastYr <int>, MonthlyFirstYr <int>,
#> #   MonthlyLastYr <int>
```

If we wanted to know which resolutions of data were available for the `YELLOWKNIFE HYDRO` station, we can extract certain columns from the station data object


```r
id <- grep("YELLOWKNIFE HYDRO", canadaHCD:::station_data$Name)
vars <- c("HourlyFirstYr", "HourlyLastYr", "DailyFirstYr", "DailyLastYr", "MonthlyFirstYr", 
    "MonthlyLastYr")
canadaHCD:::station_data[id, vars]
#> # A tibble: 1 x 6
#>   HourlyFirstYr HourlyLastYr DailyFirstYr DailyLastYr MonthlyFirstYr
#>           <int>        <int>        <int>       <int>          <int>
#> 1            NA           NA         1943        2000           1943
#>   MonthlyLastYr
#>           <int>
#> 1          2000
```

The output shows that this station has no hourly data, but daily and monthly data sets exist.
