#' Returns the ClimateID for a supplied StationID
#'
#' @param station numeric or character; the ClimateIDs whose StationIDs are to
#'   be returned.
#'
#' @importFrom dplyr filter pull
#'
#' @export
`climate_id` <- function(station) {
    station_data |>
        filter(.data$StationID %in% as.character(station)) |>
        pull("ClimateID") |>
        as.character()
}
#' Returns the StationID for a supplied ClimateID
#'
#' @param id numeric or character; the ClimateIDs whose StationIDs are to be
#'   returned.
#'
#' @importFrom dplyr filter pull
#'
#' @export
`station_id` <- function(id) {
    station_data |>
        filter(.data$ClimateID %in% as.character(id)) |>
        pull("StationID") |>
        as.character()
}