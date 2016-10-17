##' @title Download monthly Historical Climate Data records
##'
##' @description Monthly Historical Climate Data for stated station IDs are downloaded from the Government of Canada's Historical Climate Data website.
##' @param station Character; one or more HCD station IDs.
##' @param collapse Logical; if \code{TRUE} and multiple \code{station}s are requested a single \code{data frame} is returned, formed by row-binding the data for each station and prepending a station identifier variable.
##' @param progress Logical; if \code{TRUE}, a bar is shown indicating progress in downloading station data from the HCD website.
##' @param ... Further arguments passed to \code{\link{read_hcd}}.
##'
##' @return A \code{\link{tbl_df}} containing the requested monthly climate data
##'
##' @author Gavin L. Simpson
##'
##' @export
`hcd_monthly` <- function(station, collapse = TRUE, progress = TRUE, ...) {
    ns <- length(station)
    urls <- paste0("http://climate.weather.gc.ca/climate_data/bulk_data_e.html?stationID=",
                  station, "&Year=2000&Month=1&Day=14&format=csv&timeframe=3",
                  "&submit=%20Download+Data")
    ## Download data
    sdata <- process_downloads(urls, progress = progress, ...)

    ## collapse multiple stations to a single tbl_df
    if (collapse) {
        sdata <- collapse_hcd(sdata, station)
    }

    sdata
}
