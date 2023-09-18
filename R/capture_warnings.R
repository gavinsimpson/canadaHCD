`capture_warnings` <- function(expr) {
    warns <- NULL
    handler <- function(w) {
        warns <<- append(warns, list(w))
        invokeRestart("muffleWarning")
    }
    res <- withCallingHandlers(expr, warning = handler)
    list(value = res, warnings = warns)
}
