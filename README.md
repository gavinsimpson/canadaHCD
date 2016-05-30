# canadaHCD
Access Canadian Historical Climate Data from R. The Government of Canada's Historical Climate Data [website](http://climate.weather.gc.ca/index_e.html) provides access to hourly, daily, and monthly weather records for stations throughout Canada.

These are raw data that have undergone some quality control, but issues such as changes in station location are unmanged; the data for the original `stationID` stops at a certain point and a new `stationID` continues recording. For a more curated data set for climate change research at broad spatial and temporal scales see the [Adjusted and Homogenized Canadian Climate Data (AHCCD)](http://ec.gc.ca/dccha-ahccd/default.asp?lang=En&n=B1F8423A-1).

#### Released version
[![CRAN version](http://www.r-pkg.org/badges/version/canadaHCD)](http://cran.rstudio.com/web/packages/canadaHCD/index.html) [![](http://cranlogs.r-pkg.org/badges/grand-total/canadaHCD)](http://cran.rstudio.com/web/packages/canadaHCD/index.html)

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
```

```
## Source: local data frame [7 x 5]
## 
##                    Name              Province StationID LatitudeDD
##                  <fctr>                <fctr>    <fctr>      <dbl>
## 1         YELLOWKNIFE A Northwest Territories      1706      62.46
## 2         YELLOWKNIFE A Northwest Territories     51058      62.46
## 3   YELLOWKNIFE OVERLAP Northwest Territories     53898      62.46
## 4 YELLOWKNIFE-HENDERSON Northwest Territories     45467      62.45
## 5  YELLOWKNIFE CON MINE Northwest Territories      8949      62.47
## 6        YELLOWKNIFE CS Northwest Territories     27338      62.47
## 7     YELLOWKNIFE HYDRO Northwest Territories      1707      62.67
## Variables not shown: LongitudeDD <dbl>.
```

To download the monthly HCD from `YELLOWKNIFE HYDRO` I can use `hcd_monthly()`, providing it with the `StationID` for that particular weather station


```r
yh <- hcd_monthly(1707)
```

The data are returned as a [*tibble*](https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html) (a `tbl_df`), which shows a compact version of the data frame.


```r
yh
```

```
## Source: local data frame [690 x 13]
## 
##    Date/Time Mean Max Temp (°C) Mean Min Temp (°C) Mean Temp (°C)
##        <chr>              <dbl>              <dbl>          <dbl>
## 1    1943-01                 NA                 NA             NA
## 2    1943-02              -16.2              -26.4          -21.3
## 3    1943-03              -14.4              -29.4          -21.9
## 4    1943-04                1.2              -12.3           -5.6
## 5    1943-05                9.3               -3.6            2.9
## 6    1943-06               17.6                2.4           10.0
## 7    1943-07               20.6                9.6           15.1
## 8    1943-08               18.9                7.2           13.1
## 9    1943-09               10.9                2.0            6.5
## 10   1943-10                6.1               -1.9            2.1
## ..       ...                ...                ...            ...
## Variables not shown: Extr Max Temp (°C) <dbl>, Extr Min Temp (°C) <dbl>,
##   Total Rain (mm) <dbl>, Total Snow (cm) <dbl>, Total Precip (mm) <dbl>,
##   Snow Grnd Last Day (cm) <int>, Dir of Max Gust (10's deg) <int>, Spd of
##   Max Gust (km/h) <chr>, Station <dbl>.
```

You should be able to work with these objects mostly as if they were data frames.

Allthough not yet exposed through any functions in the package, you can access a snapshot of the station metadata via the `canadaHCD:::station_data` data frame.


```r
canadaHCD:::station_data
```

```
## Source: local data frame [12,565 x 19]
## 
##                      Name         Province ClimateID StationID  WMOID
##                    <fctr>           <fctr>    <fctr>    <fctr> <fctr>
## 1             ACTIVE PASS British Columbia   1010066        14     NA
## 2             ALBERT HEAD British Columbia   1010235        15     NA
## 3  BAMBERTON OCEAN CEMENT British Columbia   1010595        16     NA
## 4              BEAR CREEK British Columbia   1010720        17     NA
## 5             BEAVER LAKE British Columbia   1010774        18     NA
## 6              BECHER BAY British Columbia   1010780        19     NA
## 7         BRENTWOOD BAY 2 British Columbia   1010960        20     NA
## 8   BRENTWOOD CLARKE ROAD British Columbia   1010961        21     NA
## 9  BRENTWOOD W SAANICH RD British Columbia   1010965        22     NA
## 10             BEAR CREEK British Columbia   1010PJR      9634     NA
## ..                    ...              ...       ...       ...    ...
## Variables not shown: TCID <fctr>, LatitudeDD <dbl>, LongitudeDD <dbl>,
##   Latitude <int>, Longitude <int>, Elevation <dbl>, FirstYear <int>,
##   LastYear <int>, HourlyFirstYr <int>, HourlyLastYr <int>, DailyFirstYr
##   <int>, DailyLastYr <int>, MonthlyFirstYr <int>, MonthlyLastYr <int>.
```

If we wanted to know which resolutions of data were available for the `YELLOWKNIFE HYDRO` station, we can extract certain columns from the station data object


```r
id <- grep("YELLOWKNIFE HYDRO", canadaHCD::station_data$Name)
```

```
## Error: 'station_data' is not an exported object from 'namespace:canadaHCD'
```

```r
vars <- c("HourlyFirstYr", "HourlyLastYR", "DailyFirstYr", "DailyLastYR", "MonthlyFirstYr", "MonthlyLastYR")
canadaHCD:::station_data[id, vars]
```

```
## Error in .check_names_df(x, j): undefined columns: HourlyLastYR, DailyLastYR, MonthlyLastYR
```
