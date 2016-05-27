##' @title Download monthly Historical Climate Data records
##'
##' @description Monthly Historical Climate Data for stated station IDs are downloaded from the Government of Canada's Historical Climate Data website.
##' @param station Character; one or more (latter not currently implemented) HCD station IDs.
##' @param collapse Logical; if multiple \code{station}s are requested a single \code{data_frame} is returned, formed by row-binding the data for each station and prepending a station identifier variable.
##' @param ... Further arguments passed to \code{\link{read_hcd}}.
##'
##' @return A \code{\link{tbl_df}} containing the requested monthly climate data
##'
##' @author Gavin L. Simpson
##'
##' @export
##'
##' @importFrom curl curl_download
`hcd_monthly` <- function(station, collapse = TRUE, ...) {
    URL <- paste0("http://climate.weather.gc.ca/climate_data/bulk_data_e.html?stationID=",
                  station, "&Year=2000&Month=1&Day=14&format=csv&timeframe=3",
                  "&submit=%20Download+Data")
    tmp <- tempfile()
    f <- curl_download(URL, destfile = tmp)
    df <- read_hcd(f, ...)
    df
}
