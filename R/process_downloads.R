##' @importFrom utils txtProgressBar setTxtProgressBar
`process_downloads` <- function(urls, progress = TRUE, ...) {
    nurls <- length(urls)
    sdata <- vector(mode = "list", length = nurls)
    if (isTRUE(progress)) {
        pb <- txtProgressBar(min = 0, max = nurls, style = 3)
        on.exit(close(pb))
    }
    for (i in seq_along(sdata)) {
        sdata[[i]] <- get_hcd_from_url(urls[i], ...)
        if (isTRUE(progress)) {
            setTxtProgressBar(pb, i)
        }
    }
    sdata
}
