#' Returns the ClimateID for a supplied StationID
#'
#' @param station numeric or character; the StationIDs whose ClimateIDs are to
#'   be returned.
#'
#' @return A character vector of ClimateIDs.
#'
#' @importFrom dplyr filter pull
#'
#' @export
`climate_id` <- function(station) {
    station <- as.character(station)
    df <- station_data |>
        filter(.data$StationID %in% station) |>
        select(all_of(c("ClimateID", "StationID")))
    if (nrow(df) == 0L) {
        out <- NA_character_
    } else {
        out <- pull(df, "ClimateID") |> as.character()
        names(out) <- pull(df, "StationID") |> as.character()
        out <- unname(out[station])
    }
    out
}
#' Returns the StationID for a supplied ClimateID
#'
#' @param id numeric or character; the ClimateIDs whose StationIDs are to be
#'   returned.
#'
#' @return A character vector of StationIDs
#'
#' @importFrom dplyr filter pull
#'
#' @export
`station_id` <- function(id) {
    id <- as.character(id)
    df <- station_data |>
        filter(.data$ClimateID %in% id) |>
        select(all_of(c("ClimateID", "StationID")))
    if (nrow(df) == 0L) {
        out <- NA_character_
    } else {
        out <- pull(df, "StationID") |> as.character()
        names(out) <- pull(df, "ClimateID") |> as.character()
        out <- unname(out[id])
    }
    out
}
