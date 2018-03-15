fetch_hook_hcd <- function(key, namespace) {
  fmt <- "http://climate.weather.gc.ca/climate_data/bulk_data_e.html?stationID=%s&Year=%s&Month=%s&Day=14&format=csv&timeframe=%s&submit=%%20Download+Data"
  path <- tempfile()
  on.exit(file.remove(path))
  code <- download.file(do.call(sprintf, c(list(fmt), unlist(strsplit(key, "_")))),
                        path, quiet = TRUE, mode = "wb")
  if (code != 0L) {
    stop("Error downloading file")
  }
  res <- capture_warnings(read_hcd(path))
  df <- res$value
  attr(df, "warnings") <- res$warnings
  df
}