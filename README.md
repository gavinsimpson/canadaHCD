# canadaHCD

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![R build
status](https://github.com/gavinsimpson/canadaHCD/workflows/R-CMD-check/badge.svg)](https://github.com/gavinsimpson/canadaHCD/actions)
[![codecov](https://codecov.io/gh/gavinsimpson/canadaHCD/branch/main/graph/badge.svg?token=vDjUqs13Fb)](https://app.codecov.io/gh/gavinsimpson/canadaHCD)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/canadaHCD)](https://cran.r-project.org/package=canadaHCD)
[![CRAN
Downloads](https://cranlogs.r-pkg.org/badges/grand-total/canadaHCD)](https://cran.r-project.org/package=canadHCD)
<!-- badges: end -->

Access Canadian Historical Climate Data from R. The Government of
Canada’s Historical Climate Data
[website](http://climate.weather.gc.ca/index_e.html) provides access to
hourly, daily, and monthly weather records for stations throughout
Canada.

These are raw data that have undergone some quality control, but issues
such as changes in station location are unmanged; the data for the
original `stationID` stops at a certain point and a new `stationID`
continues recording. For a more curated data set for climate change
research at broad spatial and temporal scales see the [Adjusted and
Homogenized Canadian Climate Data
(AHCCD)](http://ec.gc.ca/dccha-ahccd/default.asp?lang=En&n=B1F8423A-1).

## Installation

*canadaHCD* is still under active development towards a 0.1 release. In
the meantime, if you wish to use the package, please install it from
this github repo, which is most easily achieved using Hadley Wickham’s
*remotes* package:

    ## install.packages("devtools")
    remotes::install_github("gavinsimpson/canadaHCD")

## Usage

Say I’m interested in climate data for stations in Yellowknife, I can
search for all known `stationID`s with `"Yellowknife"` in their name
using `find_station()`

    library("canadaHCD")
    find_station("Yellowknife")
    #> # A tibble: 6 × 6
    #>   Name                  Province              ClimateID StationID LatitudeDD
    #>   <chr>                 <chr>                 <chr>     <chr>          <dbl>
    #> 1 YELLOWKNIFE A         Northwest Territories 2204100   1706            62.5
    #> 2 YELLOWKNIFE A         Northwest Territories 2204101   51058           62.5
    #> 3 YELLOWKNIFE AIRPORT   Northwest Territories 2204108   55358           62.5
    #> 4 YELLOWKNIFE-HENDERSON Northwest Territories 2204110   45467           62.4
    #> 5 YELLOWKNIFE CS        Northwest Territories 2204155   27338           62.5
    #> 6 YELLOWKNIFE HYDRO     Northwest Territories 2204200   1707            62.7
    #>   LongitudeDD
    #>         <dbl>
    #> 1       -114.
    #> 2       -114.
    #> 3       -114.
    #> 4       -114.
    #> 5       -114.
    #> 6       -114.

To download the monthly HCD from `YELLOWKNIFE HYDRO` I can use
`hcd_monthly()`, providing it with the `StationID` for that particular
weather station

    yh <- hcd_monthly(1707)

The data are returned as a
[*tibble*](https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html)
(a `tbl_df`), which shows a compact version of the data frame.

    yh
    #> # A tibble: 690 × 16
    #>    Station           ClimateID Longitude Latitude Date      MaxTemp MinTemp
    #>    <chr>             <chr>         <dbl>    <dbl> <yearmon>   <dbl>   <dbl>
    #>  1 YELLOWKNIFE HYDRO 2204200       -114.     62.7 Jan 1943     NA      NA  
    #>  2 YELLOWKNIFE HYDRO 2204200       -114.     62.7 Feb 1943    -16.2   -26.4
    #>  3 YELLOWKNIFE HYDRO 2204200       -114.     62.7 Mar 1943    -14.4   -29.4
    #>  4 YELLOWKNIFE HYDRO 2204200       -114.     62.7 Apr 1943      1.2   -12.3
    #>  5 YELLOWKNIFE HYDRO 2204200       -114.     62.7 May 1943      9.3    -3.6
    #>  6 YELLOWKNIFE HYDRO 2204200       -114.     62.7 Jun 1943     17.6     2.4
    #>  7 YELLOWKNIFE HYDRO 2204200       -114.     62.7 Jul 1943     20.6     9.6
    #>  8 YELLOWKNIFE HYDRO 2204200       -114.     62.7 Aug 1943     18.9     7.2
    #>  9 YELLOWKNIFE HYDRO 2204200       -114.     62.7 Sep 1943     10.9     2  
    #> 10 YELLOWKNIFE HYDRO 2204200       -114.     62.7 Oct 1943      6.1    -1.9
    #>    MeanTemp ExtremeHigh ExtremeLow TotalRain TotalSnow TotalPrecip LastSnowGrnd
    #>       <dbl>       <dbl>      <dbl>     <dbl>     <dbl>       <dbl>        <int>
    #>  1     NA          NA         NA        NA        NA          NA             NA
    #>  2    -21.3         1.1      -44.4       0         9.4         9.4           NA
    #>  3    -21.9        -3.3      -40.6       0         2.8         2.8           NA
    #>  4     -5.6        12.2      -31.7       0        18          18             NA
    #>  5      2.9        20        -11.7       9.9       2.8        12.7           NA
    #>  6     10          27.2       -1.7       4.8       0           4.8           NA
    #>  7     15.1        27.2        4.4      36.6       0          36.6           NA
    #>  8     13.1        27.2        1.7      17.8       0          17.8           NA
    #>  9      6.5        18.3       -6.1       5.8       2.8         8.6           NA
    #> 10      2.1        17.2      -15.6      19.1       5.1        24.1           NA
    #> # ℹ 680 more rows
    #> # ℹ 2 more variables: MaxGustDir <int>, MaxGustSpeed <chr>

You should be able to work with these objects mostly as if they were
data frames.

Allthough not yet exposed through any functions in the package, you can
access a snapshot of the station metadata via the
`canadaHCD:::station_data` data frame.

    canadaHCD:::station_data
    #> # A tibble: 8,797 × 20
    #>    Name          Province ClimateID StationID WMOID TCID  LatitudeDD LongitudeDD
    #>    <chr>         <chr>    <chr>     <chr>     <chr> <chr>      <dbl>       <dbl>
    #>  1 ACTIVE PASS   British… 1010066   14        <NA>  <NA>        48.9       -123.
    #>  2 ALBERT HEAD   British… 1010235   15        <NA>  <NA>        48.4       -123.
    #>  3 BAMBERTON OC… British… 1010595   16        <NA>  <NA>        48.6       -124.
    #>  4 BEAR CREEK    British… 1010720   17        <NA>  <NA>        48.5       -124 
    #>  5 BEAVER LAKE   British… 1010774   18        <NA>  <NA>        48.5       -123.
    #>  6 BECHER BAY    British… 1010780   19        <NA>  <NA>        48.3       -124.
    #>  7 BRENTWOOD BA… British… 1010960   20        <NA>  <NA>        48.6       -123.
    #>  8 BRENTWOOD CL… British… 1010961   21        <NA>  <NA>        48.6       -123.
    #>  9 BRENTWOOD W … British… 1010965   22        <NA>  <NA>        48.6       -123.
    #> 10 CENTRAL SAAN… British… 1011467   25        <NA>  <NA>        48.6       -123.
    #>     Latitude   Longitude Elevation FirstYear LastYear HourlyFirstYr HourlyLastYr
    #>        <dbl>       <dbl>     <dbl>     <dbl>    <dbl>         <dbl>        <dbl>
    #>  1 485200000 -1231700000       4        1984     1996            NA           NA
    #>  2 482400000 -1232900000      17        1971     1995            NA           NA
    #>  3 483500000 -1233100000      85.3      1961     1980            NA           NA
    #>  4 483000000 -1240000000     350.       1910     1971            NA           NA
    #>  5 483000000 -1232100000      61        1894     1952            NA           NA
    #>  6 482000000 -1233800000      12.2      1956     1966            NA           NA
    #>  7 483600000 -1232800000      38        1987     1997            NA           NA
    #>  8 483400000 -1232700000      30.5      1972     1980            NA           NA
    #>  9 483400000 -1232600000      91.4      1960     1970            NA           NA
    #> 10 483500000 -1232500000      53.3      1963     1994            NA           NA
    #> # ℹ 8,787 more rows
    #> # ℹ 5 more variables: DailyFirstYr <dbl>, DailyLastYr <dbl>, MonthlyFirstYr <dbl>, MonthlyLastYr <dbl>, TimeZone <chr>

If we wanted to know which resolutions of data were available for the
`YELLOWKNIFE HYDRO` station, we can extract certain columns from the
station data object

    id <- grep("YELLOWKNIFE HYDRO", canadaHCD:::station_data$Name)
    vars <- c("HourlyFirstYr", "HourlyLastYr", "DailyFirstYr", "DailyLastYr",
        "MonthlyFirstYr", "MonthlyLastYr")
    canadaHCD:::station_data[id, vars]
    #> # A tibble: 1 × 6
    #>   HourlyFirstYr HourlyLastYr DailyFirstYr DailyLastYr MonthlyFirstYr
    #>           <dbl>        <dbl>        <dbl>       <dbl>          <dbl>
    #> 1            NA           NA         1943        2000           1943
    #>   MonthlyLastYr
    #>           <dbl>
    #> 1          2000

The output shows that this station has no hourly data, but daily and
monthly data sets exist.
