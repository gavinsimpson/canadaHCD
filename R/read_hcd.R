##' @title Read Historical Climate Data files
##'
##' @description Reads data from CSV files download from the Canada Historical Climate Data website. The function knows about hourly, daily, and monthly data formatted files.
##'
##' @param file Either a path to a file, a connection. See argument \code{file} of \code{\link{read_csv}}.
##' @param flags Logical; should variable flag columns be preserved. The default results in these columns being dropped from the returned data.
##' @param ... Further arguments passed to \code{\link{read_csv}}.
##'
##' @return A \code{\link{tbl_df}}.
##'
##' @author Gavin L. Simpson
##'
##' @importFrom readr read_csv count_fields locale tokenizer_csv
##' @importFrom tibble as_data_frame
##'
##' @export
##'
##' @examples
##' read_hcd(system.file("extdata/2855-monthly-data.csv", package = "canadaHCD"))
`read_hcd` <- function(file, flags = FALSE, ...) {
    nfields <- count_fields(file, tokenizer_csv(), n_max = 26L)
    SKIP <- which(nfields == max(nfields))[1L] - 1L
    df <- read_csv(file, skip = SKIP, locale = locale(encoding = "ISO-8859-1"),
                   ...)
    df <- as_data_frame(df)
    if (!isTRUE(flags)) {
        df <- df[, !grepl("Flag", names(df))]
    }
    df
}
