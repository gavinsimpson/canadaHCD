##' @title Find a Climate Data station by proximity to a target
##'
##' @description Search for stations in the Historical Climate Data inventory by proximity to a target station.
##'
##' @param target numeric; either the number of the target (reference) station, or a vector of length 2 containing latitude and longitude
##' @param mindist numeric; minimum distance from the target in km (defaults to 0)
##' @param maxdist numeric; maximum distance from the target in km (defaults to 100)
##' @param sort Boolean; if TRUE (default), will sort the resultant table by distance from `target`
##'
##' @return An object of class \code{"hcd_station_list"}, which is a \code{"tbl_df"}, containing details of any matching HCD stations.
##'
##' @importFrom geosphere distGeo 
##'
##' @export
##'
##' @author Conor I. Anderson
##'
##' @examples
##' find_proximity(5051)

find_proximity <- function(target, mindist = 0, maxdist = 100, sort = TRUE) {
  
  tempdata <- station_data
  if (length(target) == 1L) {
    p1 <- c(tempdata$LongitudeDD[grep(paste0("\\b", as.character(target), "\\b"), tempdata$StationID)], tempdata$LatitudeDD[grep(paste0("\\b", as.character(target), "\\b"), tempdata$StationID)])
  }
  else if (length(target) == 2L) {
    p1 <- c(target[2], target[1])
  }
    
  library(geosphere)
  
  tempdata$Dist <- rep(NA, nrow(tempdata))
  
  for (i in 1:nrow(tempdata)) {
    tempdata$Dist[i] <- (geosphere::distGeo(p1, c(tempdata$LongitudeDD[i], tempdata$LatitudeDD[i]))/1000)
  }
  tempdata <- tempdata[(!is.na(tempdata$Dist) & (tempdata$Dist >= mindist) & (tempdata$Dist <= maxdist)),]
  if (sort == TRUE) tempdata <- tempdata[order(tempdata$Dist),]
  return(tempdata)
  
}
