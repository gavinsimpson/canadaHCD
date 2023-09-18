##' @title Find a Historical Climate Data station
##'
##' @description Search for stations in the Historical Climate Data inventory by name.
##'
##' @param name character; character string or a regular expression to be matched against known station names. See \code{\link{grep}} for details.
##' @param ignore.case logical; by default the search for station names is not case-sensitive.
##' @param glob logical; use wildcards (e.g. \code{"yell*"}) in the \code{name}. See \code{link{glob2rx}} for details.
##' @param ... Additional arguments passed to \code{\link{grep}}.
##'
##' @return An object of class \code{"hcd_station_list"}, which is a \code{"tbl_df"}, containing details of any matching HCD stations.
##'
##' @importFrom utils glob2rx
##'
##' @export
##'
##' @author Gavin L. Simpson
##'
##' @examples
##' find_station("Regina")
##'
##' find_station("Yellowknife")
##'
##' find_station("Yell*", glob = TRUE)
`find_station` <- function(name = NULL, ignore.case = TRUE, glob = FALSE,
                           ...) {
    if (glob) {
        name <- glob2rx(name)
    }
    take <- grep(name, station_data$Name, ignore.case = ignore.case, ...)
    vars_wanted <- c("Name", "Province", "StationID", "LatitudeDD", "LongitudeDD")
    df <- station_data[take, vars_wanted]
    class(df) <- c("hcd_station_list", class(df))
    df
}
