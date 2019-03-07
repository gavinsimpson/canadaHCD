##' @importFrom utils txtProgressBar setTxtProgressBar
##' @importFrom rappdirs user_cache_dir
##' @importFrom storr storr_external driver_rds driver_environment
##' @importFrom tibble has_name
`process_downloads` <- function(keys, progress = TRUE, cache = FALSE, ...) {
  
    st_driver <- if (isTRUE(cache)) driver_rds(user_cache_dir("canadaHCD")) else driver_environment()
    st <- storr_external(st_driver, fetch_hook_hcd)
    year <- function(date) as.integer(format(date, format = "%Y"))
    
    nkeys <- length(keys$key)
    sdata <- vector(mode = "list", length = nkeys)
    if (isTRUE(progress)) {
        pb <- txtProgressBar(min = 0, max = nkeys, style = 3)
        on.exit(close(pb))
    }
    for (i in seq_along(sdata)) {
        # Grab the data form the cache, downloading it if it does not exist
        sdata[[i]] <- st$get(keys$key[i])
        # We don't want to cache and keep incomplete data, e.g. March data downloaded in mid-March. Brute-forcing...
        # We will always re-download monthly data, and we will re-download the past 1-2 years of daily and hourly data.
        # FIXME: Find a more elegant way to handle this
        if (!has_name(keys, "year")) {
          # Monthly data is not divided by year, so I have to always re-download it.
          redownload = TRUE
        } else if (year(attr(sdata[[i]], "download_date")) - keys$year[i] <= 1) {
          # This was downloaded within 1-2 years of the data period
          redownload = TRUE
        }
        if (redownload && attr(sdata[[i]], "download_date") - Sys.Date() > 7) {
          # This was downloaded more than a week ago. Re-download to see if there is more data.
          message("Redownloading ", keys$key[i])
          st$del(keys$key[i])
          sdata[[i]] <- st$get(keys$key[i])
        }
        redownload = FALSE
        if (isTRUE(progress)) {
            setTxtProgressBar(pb, i)
        }
    }
    sdata
}
