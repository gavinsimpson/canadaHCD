#' @title Download station data
#'
#' @param force logical; should we force the station data to be updated?
#'
#' @importFrom tools toTitleCase resaveRdaFiles
#' @importFrom dplyr na_if mutate across
#' @importFrom tidyselect all_of
#' @importFrom lutz tz_lookup_coords
#' @importFrom curl curl_download
#'
#' @keywords internal
`update_station_data` <- function(force = FALSE) {
    # downlod the file using curl_download
    # extract the timestamp and compare it to the saved one
    # if the saved file is older than the downloaded one, update the saved one
    # then process the downloaded file and store it
    stn_url <- "https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/Station%20Inventory%20EN.csv"
    tmp <- tempfile() # tempfile to download file to
    f <- curl_download(stn_url, destfile = tmp) # download stn data file
    
    # do the timestamp work
    stn_ts <- readLines(f, n = 1)
    stn_ts <- sub("Modified Date: ", "", stn_ts) |> as.POSIXct()
    
    stns <- read_csv(f, skip = 3L,
        col_types = "ccccccddddddddddddd", na = c("", "NA"), progress = FALSE)
    nams <- c("Name", "Province", "ClimateID", "StationID", "WMOID", "TCID",
        "LatitudeDD", "LongitudeDD", "Latitude", "Longitude",
        "Elevation", "FirstYear", "LastYear",
        "HourlyFirstYr", "HourlyLastYr",
        "DailyFirstYr", "DailyLastYr",
        "MonthlyFirstYr", "MonthlyLastYr")
    names(stns) <- nams
    stns <- stns |>
        mutate(across(all_of(c("LatitudeDD", "LongitudeDD", "Latitude",
          "Longitude")), .fns = ~ na_if(.x, y = 0)),
            Province = toTitleCase(tolower(as.character(.data$Province))),
            TimeZone = tz_lookup_coords(.data$LatitudeDD, .data$LongitudeDD,
                method = "accurate"))

    class(stns) <- c("hcd_stn", class(stns))
    attr(stns, "timestamp") <- stn_ts
    stns
}
