##' @title Generate URLs to Historical Climate Data records
##'
##' @description Form URLs to requested Canadian Historical Climate Data records.
##' @param station character; one or more HCD station IDs.
##' @param timescale character; the timescale of the requested Historical Climate Data records.
##' @param year numeric; vector of one or more years. Needed for daily or hourly data only.
##' @param month numeric; vector of one or months. Needed for hourly data only.
##'
##' @return A character vector containing URLs for the requested stations and time scales.
##'
##' @author Gavin L. Simpson
##'
##' @export
`hcd_url` <- function(station, timescale = c("monthly", "daily", "hourly"),
                      year, month) {
    timescale <- match.arg(timescale)
    urls <- switch(timescale,
                   "monthly" = hcd_url_monthly(station),
                   "daily"   = hcd_url_daily(station, year = year),
                   "hourly"  = hcd_url_hourly(station, year = year, month = month))
    urls
}

`hcd_url_monthly` <- function(station) {
    paste0("http://climate.weather.gc.ca/climate_data/bulk_data_e.html?stationID=",
           station, "&Year=2000&Month=1&Day=14&format=csv&timeframe=3",
           "&submit=%20Download+Data")
}

`hcd_url_daily` <- function(station, year) {
    paste0("http://climate.weather.gc.ca/climate_data/bulk_data_e.html?stationID=",
                station, "&Year=", year, "&Month=1&Day=14&format=csv&timeframe=2",
                "&submit=%20Download+Data")
}

`hcd_url_hourly` <- function(station, year, month) {
    paste0("http://climate.weather.gc.ca/climate_data/bulk_data_e.html?stationID=",
                station, "&Year=", year, "&Month=", month, "&Day=14&format=csv&timeframe=1",
                "&submit=%20Download+Data")
}
