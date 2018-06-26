##' @title Read Historical Climate Data files
##'
##' @description Reads data from CSV files download from the Canada Historical Climate Data website. The function knows about hourly, daily, and monthly data formatted files.
##'
##' @param file Either a path to a file, a connection. See argument \code{file} of \code{\link{read_csv}}.
##' @param flags Logical; should variable flag columns be preserved. The default results in these columns being dropped from the returned data.
##' @param clean Logical; should variable names be cleaned? The default replaces the variable identifiers from the CSV files with more useful names for use in R code.
##' @param ... Further arguments passed to \code{\link{read_csv}}.
##'
##' @return A \code{\link{tbl_df}}.
##'
##' @author Gavin L. Simpson
##'
##' ## FIXME: if hadley fixes the bug in count_fields, add it back here as import from readr & remove utils import
##'
##' @importFrom readr read_csv locale tokenizer_csv type_convert
##' @importFrom tibble as_data_frame
##' @importFrom zoo as.yearmon
##' @importFrom utils count.fields
##' @importFrom dplyr mutate
##'
##' @export
##'
##' @examples
##' ## read a monthly data file
##' read_hcd(system.file("extdata/2855-monthly-data.csv", package = "canadaHCD"))
##'
##' ## read a daily data file
##' read_hcd(system.file("extdata/2855-daily-data-2015.csv", package = "canadaHCD"))
`read_hcd` <- function(file, flags = FALSE, clean = TRUE, ...) {
    Date <- NULL                        # to kill the global variable NOTE!
    ## FIXME: this is what we want if readr::count_fields is fixed:
    ## nfields <- count_fields(file, tokenizer_csv(), n_max = 26L)
    nfields <- count.fields(file, sep = ",", quote = "\"", blank.lines.skip = FALSE)[1:26]
    SKIP <- which.max(nfields) - 1L
    hourlyTypes  <- "Tiiicdcdcicicicdcdcicicc"
    dailyTypes   <- paste0("Diiic", paste0(rep("dc", 8L), collapse = ""), "iciccc")
    monthlyTypes <- paste0("cii", paste0(rep("dc", 8L), collapse = ""), "iciccc")
    types <- switch(as.character(SKIP),
                    "15" = hourlyTypes, # data prior to May 2018
                    "16" = hourlyTypes, # data May 2018 and later
                    "24" = dailyTypes,
                    "25" = dailyTypes,
                    "18" = monthlyTypes)
    df <- read_csv(file, skip = SKIP, locale = locale(encoding = "ISO-8859-1"),
                   col_types = types, ...)
    df <- as_data_frame(df)
    ## drop Year Month Day Time columns if exist
    df <- df[, !names(df) %in% c("Year", "Month", "Day", "Time")]

    ## clean variables names
    if (isTRUE(clean)) {
        names(df) <-
            if (inherits(df[[1]], "Date")) { # must be daily
                c("Date","Data Quality",
                  "MaxTemp","MaxTempFlag","MinTemp","MinTempFlag","MeanTemp",
                  "MeanTempFlag","HeatDegDays","HeatDegDaysFlag","CoolDegDays",
                  "CoolDegDaysFlag","TotalRain","TotalRainFlag","TotalSnow",
                  "TotalSnowFlag","TotalPrecip","TotalPrecipFlag","GroundSnow",
                  "GroundSnowFlag","MaxGustDir","MaxGustDirFlag","MaxGustSpeed",
                  "MaxGustSpeedFlag")
            } else if (inherits(df[[1]], "POSIXt")) { # must be hourly
                c("DateTime","Temp","TempFlag","DewPointTemp","DewPointTempFlag",
                  "RelHumidity","RelHumidityFlag","WindDir","WindDirFlag",
                  "WindSpeed","WindSpeedFlag","Visibility","VisibilityFlag",
                  "Pressure","PressureFlag","Humidex","HumidexFlag","WindChill",
                  "WindChillFlag","Weather")
            } else {                    # must be monthly
                c("Date","MaxTemp","MaxTempFlag","MinTemp","MinTempFlag",
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

    if (!(inherits(df[[1]], "Date") || inherits(df[[1]], "POSIXt"))) {
        ## coerce Date/Time to Zoo yearmon object
        df <- mutate(df, Date = as.yearmon(Date, format = "%Y-%m"))
    }

    ## return
    df
}
