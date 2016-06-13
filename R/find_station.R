##' @title Find a Historical Climate Data station
##'
##' @description Search for stations in the Historical Climate Data inventory by name, with the option to filter by available data.
##'
##' @param name character; character string or a regular expression to be matched against known station names. See \code{\link{grep}} for details.
##' @param ignore.case logical; by default the search for station names is not case-sensitive.
##' @param baseline vector; a vector with a start and end year for a desired baseline. It is not used by default.
##' @param type character; only used if a baseline is specified. Defaults to "hourly".
##' @param ignore.case logical; by default the search for station names is not case-sensitive.
##' @param ... Additional arguments passed to \code{\link{grep}}.
##'
##' @return An object of class \code{"hcd_station_list"}, which is a \code{"tbl_df"}, containing details of any matching HCD stations.
##'
##' @export
##'
##' @author Gavin L. Simpson
##' @author Conor I. Anderson
##'
##' @examples
##' find_station("Regina")
##'
##' find_station("Yellowknife", baseline = c(1971, 2000), type = "hourly")
`find_station` <- function(name = NULL, baseline = NULL, type = "hourly", ignore.case = TRUE, ...) {
    take <- grep(name, station_data$Name, ignore.case = ignore.case, ...)
    data_vars <- NULL
    if (!is.null(baseline)) {
      if (length(baseline) != 2 | baseline[1] > baseline[2]) stop("error: check baseline format")
      if (type == "hourly") data_vars <- c("HourlyFirstYr", "HourlyLastYr")
      if (type == "daily") data_vars <- c("DailyFirstYr", "DailyLastYr")
      if (type == "monthly") data_vars <- c("MonthlyFirstYr", "MonthlyLastYr")
    } 
    vars_wanted <- c("Name", "Province", "StationID", "LatitudeDD", "LongitudeDD", data_vars)
    df <- station_data[take, vars_wanted]
    class(df) <- c("hcd_station_list", class(df))
    if (!is.null(baseline)) {
      i = 1
      index = NULL
      while (i <= nrow(df)) {
        if (is.na(df[i,6]) | df[i,6] > baseline[1]) index <- c(index, i)
        else if (is.na(df[i,7]) | df[i,7] < baseline[2]) index <- c(index, i)
        i <- i+1
      }
      df <- df[-index,]
    }
    df
}
