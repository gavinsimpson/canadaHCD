##' @title Find a Historical Climate Data station (advanced)
##'
##' @description Search for stations in the Historical Climate Data inventory name, available data, and/or distance to a target.
##'
##' @param name character; optional character string or a regular expression to be matched against known station names. See \code{\link{grep}} for details.
##' @param ignore.case logical; by default the search for station names is not case-sensitive.
##' @param baseline vector; optional vector with a start and end year for a desired baseline.
##' @param type character; type of data to search for. Only used if a baseline is specified. Defaults to "hourly".
##' @param target numeric; optional numeric value of the target (reference) station, or a vector of length 2 containing latitude and longitude (in that order).
##' @param mindist numeric; minimum distance from the target in km. Only used if a target is specified. (defaults to 0)
##' @param maxdist numeric; maximum distance from the target in km. Only used if a target is specified. (defaults to 100)
##' @param sort Boolean; if TRUE (default), will sort the resultant table by distance from `target`. Only used if a target is specified.
##' @param ... Additional arguments passed to \code{\link{grep}}.
##'
##' @return An object of class \code{"hcd_station_list"}, which is a \code{"tbl_df"}, containing details of any matching HCD stations.
##' 
##' @importFrom geosphere distGeo 
##' 
##' @export
##'
##' @author Gavin L. Simpson
##' @author Conor I. Anderson
##'
##' @examples
##' # Find all stations containing "Regina" in their name.
##' find_station_adv("Regina")
##' 
##' # Find stations named "Yellowknife", with hourly data available from 1971 to 2000.
##' find_station_adv("Yellowknife", baseline = c(1971, 2000), type = "hourly")
##' 
##' # Find all stations between 0 and 100 km from Station No. 5051.
##' find_station_adv(target = 5051, mindist = 0, maxdist = 100)
##' 

`find_station_adv` <- function(name = NULL, baseline = NULL, type = "hourly", ignore.case = TRUE, target = NULL, mindist = 0, maxdist = 100, sort = TRUE, ...) {
    
  # If `name` is not NULL, filter by name
  if (!is.null(name)) {
    take <- grep(name, station_data$Name, ignore.case = ignore.case, ...)
  } else {
    take <- 1:nrow(station_data)
  }
  
  # Next, set the data we are interested in, if necessary
  data_vars <- NULL
  if (!is.null(baseline)) {
    if (length(baseline) != 2 | baseline[1] > baseline[2]) stop("error: check baseline format")
    if (type == "hourly") data_vars <- c("HourlyFirstYr", "HourlyLastYr")
    if (type == "daily") data_vars <- c("DailyFirstYr", "DailyLastYr")
    if (type == "monthly") data_vars <- c("MonthlyFirstYr", "MonthlyLastYr")
  } 
  
  # Make a table with the info we want
  vars_wanted <- c("Name", "Province", "StationID", "LatitudeDD", "LongitudeDD", data_vars)
  df <- station_data[take, vars_wanted]
  class(df) <- c("hcd_station_list", class(df))
  
  # If `baseline` is not NULL, filter by available data
  if (!is.null(baseline)) {
    index = NULL
    # Identify all stations outside of our baseline
    for (i in 1:nrow(df)) {
      if (is.na(df[i,6]) | df[i,6] > baseline[1]) index <- c(index, i)
      else if (is.na(df[i,7]) | df[i,7] < baseline[2]) index <- c(index, i)
    }
    # Delete those stations
    df <- df[-index,]
  }
  
  # If `target` is not NULL, filter by distance to target
  if (!is.null(target)) {
    if (length(target) == 1L) {
      p1 <- c(df$LongitudeDD[grep(paste0("\\b", as.character(target), "\\b"), df$StationID)], df$LatitudeDD[grep(paste0("\\b", as.character(target), "\\b"), df$StationID)])
    }
    else if (length(target) == 2L) {
      p1 <- c(target[2], target[1])
    } else stop("error: check target format")
    df$Dist <- rep(NA, nrow(df))
    for (j in 1:nrow(df)) {
      df$Dist[j] <- (distGeo(p1, c(df$LongitudeDD[j], df$LatitudeDD[j]))/1000)
    }
    df <- df[(!is.na(df$Dist) & (df$Dist >= mindist) & (df$Dist <= maxdist)),]
    if (sort == TRUE) df <- df[order(df$Dist),]
  }
  df
}
