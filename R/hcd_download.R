##' @title Download CSV files of Historical Climate Data records
##'
##' @description Downloads raw CSV data files from the Canadian Historical Climate Data website. These are the raw files you would obtain if you accessed a data record through the HCD website.
##' @param station character; one or more HCD station IDs.
##' @param file character; one or more file names. If not supplied, file names of the form \code{station-year-month.csv}, with \code{year} and \code{month} appended as determined by argument \code{timescale}.
##' @param dir character; vector of one or more directory paths in which CSV files will be saved.scale of the requested Historical Climate Data records. If multiple paths supplied, there should be one path per station.
##' @param timescale character; the timescale of the requested Historical Climate Data records.
##' @param year numeric; vector of one or more years. Needed for daily or hourly data only.
##' @param month numeric; vector of one or months. Needed for hourly data only.
##' @param progress logical; if \code{TRUE}, a bar is shown indicating progress in downloading station data from the HCD website.
##'
##' @return A character vector containing file paths to the downloaded CSVs is returned invisibly.
##'
##' @author Gavin L. Simpson
##'
##' @importFrom curl curl_download
##' @importFrom utils txtProgressBar setTxtProgressBar
##' @export
##'
##' @examples
##' f <- hcd_download(1707, timescale = "monthly")
##' file.exists(f)
##'
##' ## specifying multiple storage folders
##' dirs <- file.path(tempdir(), c("2855", "1707"))
##' dir.create(dirs[1])
##' dir.create(dirs[2])
##' f <- hcd_download(c(2855, 1707), timescale = "monthly", dir = dirs)
##' file.exists(f)
##' ## ...and daily
##' f <- hcd_download(c(2855, 1707), timescale = "daily", dir = dirs,
##'                   year = 1999:2000)
##' file.exists(f)
`hcd_download` <- function(station, file, dir = tempdir(),
                           timescale = c("monthly", "daily", "hourly"),
                           year = NULL, month = NULL, progress = TRUE) {
    timescale <- match.arg(timescale)
    station <- as.integer(station)
    if (!is.null(year)) {
        year <- as.integer(year)
    }
    if (!is.null(month)) {
        month <- as.integer(month)
    }
    ndirs <- length(dir)
    ns <- length(station)
    urls <- hcd_url(station, timescale, year, month)
    ## dirlens <- table(urls$station)
    if (ndirs > 1L) {
        if (ndirs != ns) {
            stop(sprintf("Invalid number of directory paths: should be 1 or %s.",
                         ns))
        }
        names(dir) <- station
        dir <- dir[as.character(station)]
    }
    if (missing(file)) {
        file <- switch(timescale,
                       "monthly" = paste("station", station, sep = "-"),
                       "daily"   = {
            ex <- expand.grid(station = station, year = year)
            paste("station", ex[,1], ex[,2], sep = "-")
        },
        "hourly"  = {
            ex <- expand.grid(station = station, year = year, month = month)
            paste("station", ex[,1], ex[,2], sep = "-")}
        )
        file <- paste0(file, ".csv")
    }
    fnames <- file.path(dir, file)

    ## loop over file names
    if (isTRUE(progress)) {
        pb <- txtProgressBar(min = 0, max = length(fnames), style = 3)
    }
    on.exit(close(pb))
    URLS <- urls$url
    for (i in seq_along(fnames)) {
        curl_download(URLS[i], destfile = fnames[i])
        if (isTRUE(progress)) {
            setTxtProgressBar(pb, i)
        }
    }
    invisible(fnames)
}
