get_hcd_from_url <- function(URL, ...) {
    tmp <- tempfile()
    f <- curl_download(URL, destfile = tmp)
    res <- capture_warnings(read_hcd(f, ...))
    df <- res$value
    attr(df, "warnings") <- res$warnings
    df
}
