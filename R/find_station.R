##' @title Find a Historical Climate Data station
##'
##' @description Search for stations in the Historical Climate Data inventory by name.
##'
##' @param name character; character string or a regular expression to be matched against known station names. See \code{\link{grep}} for details.
##' @param ignore.case logical; by default the search for station names is not case-sensitive.
##' @param ... Additional arguments passed to \code{\link{grep}}.
##'
##' @return An object of class \code{"hcd_station_list"}, which is a \code{"tbl_df"}, containing details of any matching HCD stations.
##'
##' @export
##'
##' @author Gavin L. Simpson
##'
##' @examples
##' find_station("Regina")
##'
##' find_station("Yellowknife")
`find_station` <- function(name = NULL, ignore.case = TRUE, ...) {
    take <- grep(name, station_data$Name, ignore.case = ignore.case, ...)
    vars_wanted <- c("Name", "Province", "StationID", "LatitudeDD", "LongitudeDD")
    df <- station_data[take, vars_wanted]
    class(df) <- c("hcd_station_list", class(df))
    df
}
