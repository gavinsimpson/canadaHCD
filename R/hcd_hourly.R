#' @title Download hourly Historical Climate Data records
#'
#' @description Hourly Historical Climate Data for stated station IDs are
#'   downloaded from the Government of Canada's Historical Climate Data website.
#' @param station Character or numeric; one or more HCD station IDs.
#' @param year numeric; vector of one or more years
#' @param month numeric; vector of one or months
#' @param collapse Logical; if \code{TRUE} and multiple \code{station}s are
#'   requested a single \code{data frame} is returned, formed by row-binding
#'   the data for each station and prepending a station identifier variable.
#' @param progress Logical; if \code{TRUE}, a bar is shown indicating progress
#'   in downloading station data from the HCD website.
#' @param ... Further arguments passed to \code{\link{read_hcd}}.
#'
#' @return A [`tibble::tbl_df-class`] containing the requested hourly climate
#'   data.
#'
#' @author Gavin L. Simpson
#'
#' @export
`hcd_hourly` <- function(station, year, month, collapse = TRUE,
    progress = TRUE, ...) {
    ## Generate URLs
    urls <- hcd_url(station, timescale = "hourly", year = year, month = month)
    ## Download data
    sdata <- process_downloads(urls$url, progress = progress, ...)
    ## collapse multiple stations to a single tbl_df
    if (collapse) {
        sdata <- collapse_hcd(sdata)
    }

    sdata
}
