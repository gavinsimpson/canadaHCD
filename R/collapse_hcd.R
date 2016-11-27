##' @title Bind a list of HCD data sets, row-wise.
##'
##' @description Given a list of HCD data sets, \code{collapse_hcd} binds together each element of the list (HCD dataset) row-wise into a single tibble.
##' @param l a list whose elements are tibbles that should be bound, row-wise.
##' @param station Character or numeric; one station ID per element of \code{l}.
##'
##' @return A \code{\link{tbl_df}} of the data after row binding each element of input.
##'
##' @author Gavin L. Simpson
##'
##' @importFrom dplyr bind_rows
##' @importFrom tibble add_column
`collapse_hcd` <- function(l, station) {
    nr <- vapply(l, NROW, integer(1L))
    fixym <- class(l[[1]]$Date) == "yearmon"
    l <- bind_rows(l)
    if (fixym) l$Date <- as.yearmon(l$Date)
    l <- add_column(l, Station = rep(station, times = nr),
                    .before = 1)
    l
}
