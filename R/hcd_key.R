##' @title Generate keys to Historical Climate Data records
##'
##' @description Form keys to requested Canadian Historical Climate Data records.
##' @param station character; one or more HCD station IDs.
##' @param timescale character; the timescale of the requested Historical Climate Data records.
##' @param year numeric; vector of one or more years. Needed for daily or hourly data only.
##' @param month numeric; vector of one or months. Needed for hourly data only.
##'
##' @return A character vector containing keys for the requested stations and time scales.
##'
##' @author Gavin L. Simpson
##'
##' @export
##'
##' @examples
##' keys <- hcd_key(c(2855, 1707), timescale = "monthly")
##' keys
##' head(keys$key)
`hcd_key` <- function(station, timescale = c("monthly", "daily", "hourly"),
                      year, month) {
    timescale <- match.arg(timescale)
    station <- as.integer(station)
    keys <- switch(timescale,
                   "monthly" = hcd_key_monthly(station),
                   "daily"   = hcd_key_daily(station,
                                             year = as.integer(year)),
                   "hourly"  = hcd_key_hourly(station,
                                              year = as.integer(year),
                                              month = as.integer(month)))
    keys
}

##' @importFrom tibble data_frame
`hcd_key_monthly` <- function(station) {
    keys <- paste(station, 2000, 1, 3, sep = "_")
    keys <- data_frame(station = station, key = keys)
    keys
}

##' @importFrom tibble as_data_frame add_column
`hcd_key_daily` <- function(station, year) {
    expand <- expand.grid(station = station, year = year)
    keys <- paste(expand$station, expand$year, 1, 2, sep = "_")
    keys <- add_column(as_data_frame(expand), key = keys)
    keys
}

##' @importFrom tibble as_data_frame add_column
`hcd_key_hourly` <- function(station, year, month) {
    expand <- expand.grid(station = station, year = year, month = month)
    keys <- paste(expand$station, expand$year, expand$month, 1, sep = "_")
    keys <- add_column(as_data_frame(expand), key = keys)
    keys
}
