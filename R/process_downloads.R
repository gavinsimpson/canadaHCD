##' @importFrom utils txtProgressBar setTxtProgressBar
##' @importFrom rappdirs user_cache_dir
##' @importFrom storr storr_external driver_rds driver_environment
`process_downloads` <- function(keys, progress = TRUE, cache = FALSE, ...) {
  
    st_driver <- if (isTRUE(cache)) driver_rds(user_cache_dir("canadaHCD")) else driver_environment()
    st <- storr_external(st_driver, fetch_hook_hcd)
    
    nkeys <- length(keys)
    sdata <- vector(mode = "list", length = nkeys)
    if (isTRUE(progress)) {
        pb <- txtProgressBar(min = 0, max = nkeys, style = 3)
    }
    on.exit(close(pb))
    for (i in seq_along(sdata)) {
        sdata[[i]] <- st$get(keys[i])
        if (isTRUE(progress)) {
            setTxtProgressBar(pb, i)
        }
    }
    sdata
}
