##' @title Download hourly Historical Climate Data records
##'
##' @description Hourly Historical Climate Data for stated station IDs are downloaded from the Government of Canada's Historical Climate Data website.
##' @param station Character or numeric; one or more HCD station IDs.
##' @param year numeric; vector of one or more years
##' @param month numeric; vector of one or months
##' @param collapse Logical; if \code{TRUE} and multiple \code{station}s are requested a single \code{data frame} is returned, formed by row-binding the data for each station and prepending a station identifier variable.
##' @param progress Logical; if \code{TRUE}, a bar is shown indicating progress in downloading station data from the HCD website.
##' @param ... Further arguments passed to \code{\link{read_hcd}}.
##'
##' @return A \code{\link{tbl_df}} containing the requested monthly climate data
##'
##' @author Gavin L. Simpson
##'
##' @export
##'
##' @importFrom curl curl_download
##' @importFrom dplyr bind_rows mutate
`hcd_hourly` <- function(station, year, month, collapse = TRUE, progress = TRUE, ...) {
    expand <- expand.grid(station = station, year = year, month = month)
    ns <- NROW(expand)
    urls <- with(expand,
                 paste0("http://climate.weather.gc.ca/climate_data/bulk_data_e.html?stationID=",
                        station, "&Year=", year, "&Month=", month, "&Day=14&format=csv&timeframe=1",
                        "&submit=%20Download+Data"))
    ## Download data
    sdata <- process_downloads(urls, progress = progress, ...)
    ## collapse multiple stations to a single tbl_df
    if (collapse) {
        nr <- vapply(sdata, NROW, integer(1L))
        sdata <- bind_rows(sdata)
        sdata <- mutate(sdata, Station = rep(expand$station, times = nr))
    }

    sdata
}
