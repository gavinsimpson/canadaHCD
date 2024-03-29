#' @title Generate URLs to Historical Climate Data records
#'
#' @description Form URLs to requested Canadian Historical Climate Data records.
#' @param station character; one or more HCD station IDs.
#' @param timescale character; the timescale of the requested Historical Climate Data records.
#' @param year numeric; vector of one or more years. Needed for daily or hourly data only.
#' @param month numeric; vector of one or months. Needed for hourly data only.
#'
#' @return A character vector containing URLs for the requested stations and time scales.
#'
#' @author Gavin L. Simpson
#'
#' @importFrom tibble tibble
#' @export
#'
#' @examples
#' urls <- hcd_url(c(2855, 1707), timescale = "monthly")
#' urls
#' head(urls$url)
`hcd_url` <- function(station, timescale = c("monthly", "daily", "hourly"),
                      year, month) {
    timescale <- match.arg(timescale)
    station <- as.character(station)
    urls <- switch(timescale,
                   "monthly" = hcd_url_monthly(station),
                   "daily"   = hcd_url_daily(station,
                                             year = as.integer(year)),
                   "hourly"  = hcd_url_hourly(station,
                                              year = as.integer(year),
                                              month = as.integer(month)))
    urls
}

#' @importFrom tibble data_frame
`hcd_url_monthly` <- function(station) {
    urls <- paste0("http://climate.weather.gc.ca/climate_data/bulk_data_e.html?stationID=",
                   station, "&Year=2000&Month=1&Day=14&format=csv&timeframe=3",
                   "&submit=%20Download+Data")
    urls <- tibble(station = station, url = urls)
    urls
}

#' @importFrom tibble as_tibble add_column
#' @importFrom tidyr expand_grid
`hcd_url_daily` <- function(station, year) {
    expand <- expand_grid(station = station, year = year)
    urls <- paste0("http://climate.weather.gc.ca/climate_data/bulk_data_e.html?stationID=",
                   expand$station, "&Year=", expand$year, "&Month=1&Day=14&format=csv&timeframe=2",
                   "&submit=%20Download+Data")
    urls <- add_column(expand, url = urls)
    urls
}

#' @importFrom tibble as_tibble add_column
#' @importFrom tidyr expand_grid
`hcd_url_hourly` <- function(station, year, month) {
    expand <- expand_grid(station = station, year = year, month = month)
    urls <- paste0("http://climate.weather.gc.ca/climate_data/bulk_data_e.html?stationID=",
                   expand$station, "&Year=", expand$year, "&Month=", expand$month,
                   "&Day=14&format=csv&timeframe=1", "&submit=%20Download+Data")
    urls <- add_column(expand, url = urls)
    urls
}
