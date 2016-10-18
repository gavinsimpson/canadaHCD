
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
#> # A tibble: 7 × 5
#>                    Name              Province StationID LatitudeDD
#>                  <fctr>                <fctr>    <fctr>      <dbl>
#> 1         YELLOWKNIFE A Northwest Territories      1706      62.46
#> 2         YELLOWKNIFE A Northwest Territories     51058      62.46
#> 3   YELLOWKNIFE OVERLAP Northwest Territories     53898      62.46
#> 4 YELLOWKNIFE-HENDERSON Northwest Territories     45467      62.45
#> 5  YELLOWKNIFE CON MINE Northwest Territories      8949      62.47
#> 6        YELLOWKNIFE CS Northwest Territories     27338      62.47
#> 7     YELLOWKNIFE HYDRO Northwest Territories      1707      62.67
#>   LongitudeDD
#>         <dbl>
#> 1     -114.44
#> 2     -114.44
#> 3     -114.44
#> 4     -114.38
#> 5     -114.33
#> 6     -114.45
#> 7     -114.25
```

To download the monthly HCD from `YELLOWKNIFE HYDRO` I can use `hcd_monthly()`, providing it with the `StationID` for that particular weather station


```r
yh <- hcd_monthly(1707)
```

The data are returned as a [*tibble*](https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html) (a `tbl_df`), which shows a compact version of the data frame.


```r
yh
#> # A tibble: 690 × 13
#>    Station     Date MaxTemp MinTemp MeanTemp ExtremeHigh ExtremeLow
#>      <dbl>    <dbl>   <dbl>   <dbl>    <dbl>       <dbl>      <dbl>
#> 1     1707 1943.000      NA      NA       NA          NA         NA
#> 2     1707 1943.083   -16.2   -26.4    -21.3         1.1      -44.4
#> 3     1707 1943.167   -14.4   -29.4    -21.9        -3.3      -40.6
#> 4     1707 1943.250     1.2   -12.3     -5.6        12.2      -31.7
#> 5     1707 1943.333     9.3    -3.6      2.9        20.0      -11.7
#> 6     1707 1943.417    17.6     2.4     10.0        27.2       -1.7
#> 7     1707 1943.500    20.6     9.6     15.1        27.2        4.4
#> 8     1707 1943.583    18.9     7.2     13.1        27.2        1.7
#> 9     1707 1943.667    10.9     2.0      6.5        18.3       -6.1
#> 10    1707 1943.750     6.1    -1.9      2.1        17.2      -15.6
#>    TotalRain TotalSnow TotalPrecip LastSnowGrnd
#>        <dbl>     <dbl>       <dbl>        <int>
#> 1         NA        NA          NA           NA
#> 2        0.0       9.4         9.4           NA
#> 3        0.0       2.8         2.8           NA
#> 4        0.0      18.0        18.0           NA
#> 5        9.9       2.8        12.7           NA
#> 6        4.8       0.0         4.8           NA
#> 7       36.6       0.0        36.6           NA
#> 8       17.8       0.0        17.8           NA
#> 9        5.8       2.8         8.6           NA
#> 10      19.1       5.1        24.1           NA
#> # ... with 680 more rows, and 2 more variables: MaxGustDir <int>,
#> #   MaxGustSpeed <chr>
```

You should be able to work with these objects mostly as if they were data frames.

Allthough not yet exposed through any functions in the package, you can access a snapshot of the station metadata via the `canadaHCD:::station_data` data frame.


```r
canadaHCD:::station_data
#> # A tibble: 12,565 × 19
#>                      Name         Province ClimateID StationID  WMOID
#>                    <fctr>           <fctr>    <fctr>    <fctr> <fctr>
#> 1             ACTIVE PASS British Columbia   1010066        14     NA
#> 2             ALBERT HEAD British Columbia   1010235        15     NA
#> 3  BAMBERTON OCEAN CEMENT British Columbia   1010595        16     NA
#> 4              BEAR CREEK British Columbia   1010720        17     NA
#> 5             BEAVER LAKE British Columbia   1010774        18     NA
#> 6              BECHER BAY British Columbia   1010780        19     NA
#> 7         BRENTWOOD BAY 2 British Columbia   1010960        20     NA
#> 8   BRENTWOOD CLARKE ROAD British Columbia   1010961        21     NA
#> 9  BRENTWOOD W SAANICH RD British Columbia   1010965        22     NA
#> 10             BEAR CREEK British Columbia   1010PJR      9634     NA
#>      TCID LatitudeDD LongitudeDD  Latitude
#>    <fctr>      <dbl>       <dbl>     <int>
#> 1      NA      48.87     -123.28 485200000
#> 2      NA      48.40     -123.48 482400000
#> 3      NA      48.58     -123.52 483500000
#> 4      NA      48.50     -124.00 483000000
#> 5      NA      48.50     -123.35 483000000
#> 6      NA      48.33     -123.63 482000000
#> 7      NA      48.60     -123.47 483600000
#> 8      NA      48.57     -123.45 483400000
#> 9      NA      48.57     -123.43 483400000
#> 10     NA      48.50     -123.90 483000000
#> # ... with 12,555 more rows, and 10 more variables: Longitude <int>,
#> #   Elevation <dbl>, FirstYear <int>, LastYear <int>, HourlyFirstYr <int>,
#> #   HourlyLastYr <int>, DailyFirstYr <int>, DailyLastYr <int>,
#> #   MonthlyFirstYr <int>, MonthlyLastYr <int>
```

If we wanted to know which resolutions of data were available for the `YELLOWKNIFE HYDRO` station, we can extract certain columns from the station data object


```r
id <- grep("YELLOWKNIFE HYDRO", canadaHCD:::station_data$Name)
vars <- c("HourlyFirstYr", "HourlyLastYr", "DailyFirstYr", "DailyLastYr", "MonthlyFirstYr", 
    "MonthlyLastYr")
canadaHCD:::station_data[id, vars]
#> # A tibble: 1 × 6
#>   HourlyFirstYr HourlyLastYr DailyFirstYr DailyLastYr MonthlyFirstYr
#>           <int>        <int>        <int>       <int>          <int>
#> 1            NA           NA         1943        2000           1943
#>   MonthlyLastYr
#>           <int>
#> 1          2000
```

The output shows that this station has no hourly data, but daily and monthly data sets exist.
