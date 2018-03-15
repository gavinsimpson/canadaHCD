##' @title Download daily Historical Climate Data records
##'
##' @description Daily Historical Climate Data for stated station IDs are downloaded from the Government of Canada's Historical Climate Data website.
##' @param station Character or numeric; one or more HCD station IDs.
##' @param year numeric; vector of one or more years
##' @param collapse Logical; if \code{TRUE} and multiple \code{station}s are requested a single \code{data frame} is returned, formed by row-binding the data for each station and prepending a station identifier variable.
##' @param progress Logical; if \code{TRUE}, a bar is shown indicating progress in downloading station data from the HCD website.
##' @param cache Logical; if \code{TRUE}, processed HCD \code{.csv} files will be cached for future use.
##' @param ... Further arguments passed to \code{\link{read_hcd}}.
##'
##' @return A \code{\link{tbl_df}} containing the requested monthly climate data
##'
##' @author Gavin L. Simpson
##'
##' @export
`hcd_daily` <- function(station, year, collapse = TRUE, progress = TRUE, cache = FALSE, ...) {
    ## Generate URLs
    urls <- hcd_url(station, timescale = "daily", year = year)
    ## Download data
    sdata <- process_downloads(urls$url, progress = progress, cache = cache, ...)
    ## collapse multiple stations to a single tbl_df
    if (collapse) {
        sdata <- collapse_hcd(sdata, urls$station)
    }
    sdata
}
