##' @title Find a Historical Climate Data station (GUI)
##'
##' @description A function to launch a shiny web app to search for Historical Climate Data stations.
##'
##' @return none
##'
##' @export
##' 

find_station_GUI <- function() {
  if ("shiny" %in% rownames(installed.packages()) == FALSE) {
    stop("This function requires the shiny package. Try (re)installing `shiny`.", call. = FALSE)
  }
  appDir <- system.file("shiny", "ShinyStationFinder", package = "canadaHCD")
  if (appDir == "") {
    stop("Could not find the shiny directory. Try re-installing `canadaHCD`.", call. = FALSE)
  }
  shiny::runApp(appDir, display.mode = "normal")
}