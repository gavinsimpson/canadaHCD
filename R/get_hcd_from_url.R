get_hcd_from_url <- function(URL, ...) {
    tmp <- tempfile()
    f <- curl_download(URL, destfile = tmp)
    df <- read_hcd(f, ...)
    df
}
