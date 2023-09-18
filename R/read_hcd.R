#' @title Read Historical Climate Data files
#'
#' @description Reads data from CSV files download from the Canada Historical
#'   Climate Data website. The function knows about hourly, daily, and monthly
#'   data formatted files.
#'
#' @param file Either a path to a file, a connection. See argument \code{file}
#'   of \code{\link{read_csv}}.
#' @param flags Logical; should variable flag columns be preserved. The default
#'   results in these columns being dropped from the returned data.
#' @param clean Logical; should variable names be cleaned? The default replaces
#'   the variable identifiers from the CSV files with more useful names for use
#'   in R code.
#' @param ... Further arguments passed to \code{\link{read_csv}}.
#'
#' @return A \code{\link{tbl_df}}.
#'
#' @author Gavin L. Simpson
#'
#' ## FIXME: if hadley fixes the bug in count_fields, add it back here as
#' import from readr & remove utils import
#'
#' @importFrom readr read_csv locale tokenizer_csv type_convert
#' @importFrom zoo as.yearmon
#' @importFrom utils count.fields
#' @importFrom dplyr mutate .data
#'
#' @export
#'
#' @examples
#' ## read a monthly data file
#' read_hcd(system.file("extdata/2855-monthly-data.csv", package = "canadaHCD"))
#'
#' ## read a daily data file
#' read_hcd(system.file("extdata/2855-daily-data-2015.csv",
#'   package = "canadaHCD"))
`read_hcd` <- function(file, flags = FALSE, clean = TRUE, ...) {
    nfields <- count.fields(textConnection(readLines(file, n = 1L)), sep = ",",
        quote = "\"")
    SKIP <- which.max(nfields) - 1L
    # hourlyTypes <- "ddccTiiicdcdcicicicdcdcicicc"
    hourlyTypes  <- paste0("ddccTiiit", paste0(rep("dc", 8L), collapse = ""),
        "c")
    dailyTypes   <- paste0("ddccDiiic", paste0(rep("dc", 8L), collapse = ""),
        "iciccc")
    monthlyTypes <- paste0("ddcccii", paste0(rep("dc", 8L), collapse = ""),
        "iciccc")
    types <- switch(as.character(nfields),
                    "30" = hourlyTypes, # data May 2018 and later
                    "31" = dailyTypes,
                    "29" = monthlyTypes)
    df <- read_csv(file, col_types = types, show_col_types = FALSE,
        progress = FALSE, ...)
    ## drop Year Month Day Time columns if exist
    df <- df[, !names(df) %in% c("Year", "Month", "Day", "Time", "Time (LST)")]

    ## clean variables names
    if (isTRUE(clean)) {
        names(df) <-
            if (inherits(df[[5]], "Date")) { # must be daily
                c("Longitude","Latitude","Station","ClimateID","Date","Data Quality",
                  "MaxTemp","MaxTempFlag","MinTemp","MinTempFlag","MeanTemp",
                  "MeanTempFlag","HeatDegDays","HeatDegDaysFlag","CoolDegDays",
                  "CoolDegDaysFlag","TotalRain","TotalRainFlag","TotalSnow",
                  "TotalSnowFlag","TotalPrecip","TotalPrecipFlag","GroundSnow",
                  "GroundSnowFlag","MaxGustDir","MaxGustDirFlag","MaxGustSpeed",
                  "MaxGustSpeedFlag")
            } else if (inherits(df[[5]], "POSIXt")) { # must be hourly
                # data format changed again - reported 17 Sept 2023
                c("Longitude", "Latitude",
                "Station", "ClimateID",
                "DateTime",
                "Temp", "TempFlag",
                "DewPointTemp", "DewPointTempFlag",
                "RelHumidity", "RelHumidityFlag",
                "TotalPrecip", "TotalPrecipFlag",
                "WindDir", "WindDirFlag",
                "WindSpeed", "WindSpeedFlag",
                "Visibility", "VisibilityFlag",
                "Pressure", "PressureFlag",
                "Humidex", "HumidexFlag",
                "WindChill", "WindChillFlag",
                "Weather")
            } else {                    # must be monthly
                c("Longitude","Latitude","Station","ClimateID","Date",
                  "MaxTemp","MaxTempFlag","MinTemp","MinTempFlag",
                  "MeanTemp","MeanTempFlag","ExtremeHigh","ExtremeHighFlag","ExtremeLow",
                  "ExtremeLowFlag","TotalRain","TotalRainFlag","TotalSnow",
                  "TotalSnowFlag","TotalPrecip","TotalPrecipFlag","LastSnowGrnd",
                  "LastSnowGrndFlag","MaxGustDir","MaxGustDirFlag","MaxGustSpeed",
                  "MaxGustSpeedFlag")
            }
    }

    ## keep flag columns?
    flagCols <- grepl("Flag", names(df))
    if (!isTRUE(flags)) {
        df <- df[, !flagCols]
        df <- df[, !grepl("Data Quality", names(df))]
    }

    ## need df[[5]] as some data types are DateTime, etc
    if (!(inherits(df[[5]], "Date") || inherits(df[[5]], "POSIXt"))) {
        ## coerce Date/Time to Zoo yearmon object
        df <- mutate(df, Date = as.yearmon(.data$Date, format = "%Y-%m"))
    }

    ## reorder columns
    df <- select(df, matches("Station"), matches("ClimateID"), everything())

    ## return
    df
}
