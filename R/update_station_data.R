#' @importFrom tools toTitleCase
#' @importFrom dplyr na_if mutate
#' @importFrom lutz tz_lookup_coords
#'
#' @keywords internal
`update_station_data` <- function() {
    stn_url <- "https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/Station%20Inventory%20EN.csv"
    stns <- read_csv(stn_url, skip = 3L,
        col_types = "ccccccddddddddddddd", na = c("", "NA"), progress = FALSE)
    nams <- c("Name", "Province", "ClimateID", "StationID", "WMOID", "TCID",
        "LatitudeDD", "LongitudeDD", "Latitude", "Longitude",
        "Elevation", "FirstYear", "LastYear",
        "HourlyFirstYr", "HourlyLastYr",
        "DailyFirstYr", "DailyLastYr",
        "MonthlyFirstYr", "MonthlyLastYr")

    names(stns) <- nams
    stns <- stns |>
        mutate(LatitudeDD = na_if(.data$LatitudeDD, y = 0),
            LongitudeDD = na_if(.data$LongitudeDD, y = 0),
            Latitude = na_if(.data$Latitude, y = 0),
            Longitude = na_if(.data$Longitude, y = 0),
            Province = toTitleCase(tolower(as.character(.data$Province))),
            TimeZone = tz_lookup_coords(.data$LatitudeDD, .data$LongitudeDD,
                method = "accurate"))

    stn_ts <- readLines(stn_url, n = 1)
    stn_ts <- sub("Modified Date: ", "", stn_ts) |> as.POSIXct()
    class(stns) <- c("hcd_stn", class(stns))
    attr(stns, "timestamp") <- stn_ts
    stns
}
