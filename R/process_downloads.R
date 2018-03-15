##' @importFrom utils txtProgressBar setTxtProgressBar
`process_downloads` <- function(urls, progress = TRUE, cache = FALSE, ...) {
    nurls <- length(urls)
    sdata <- vector(mode = "list", length = nurls)
    if (isTRUE(progress)) {
        pb <- txtProgressBar(min = 0, max = nurls, style = 3)
    }
    on.exit(close(pb))
    for (i in seq_along(sdata)) {
        sdata[[i]] <- if (isTRUE(cache) && hcd_cache("check", digest(urls[i]))) {
          hcd_cache("get", digest(urls[i]))
          } else {
            get_hcd_from_url(urls[i], ...)
          }
        if (isTRUE(cache) & !hcd_cache("check", digest(urls[i]))) hcd_cache("set", digest(urls[i]), sdata[[i]])
        if (isTRUE(progress)) {
            setTxtProgressBar(pb, i)
        }
    }
    sdata
}
