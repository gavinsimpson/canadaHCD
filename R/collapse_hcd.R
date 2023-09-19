#' @title Bind a list of HCD data sets, row-wise.
#'
#' @description Given a list of HCD data sets, `collapse_hcd` binds together
#'   each element of the list (HCD dataset) row-wise into a single tibble.
#' @param l a list whose elements are tibbles that should be bound, row-wise.
#'
#' @return A \code{\link{tbl_df}} of the data after row binding each element of input.
#'
#' @author Gavin L. Simpson
#'
#' @importFrom dplyr bind_rows select everything matches arrange left_join join_by all_of
#' @importFrom tibble add_column has_name
#' @importFrom zoo as.yearmon
#' @importFrom lubridate force_tz
`collapse_hcd` <- function(l) {
    nr <- vapply(l, NROW, integer(1L))

    ## do we need to fix-up the yearmon column?
    fixym <- if (has_name(l[[1]], "Date")) {
        inherits(l[[1]][["Date"]], "yearmon")
    } else {
        FALSE
    }

    ## form a data frame from individual objects in `l`
    l <- suppressWarnings(bind_rows(l))

    ## fix-up yearmon column if present
    if (fixym) {
        l[["Date"]] <- as.yearmon(l[["Date"]])
    }

    # arrange by DateTime to ensure all in correct order as per #26
    l <- if (has_name(l, "DateTime")) {
        # add time zone info
        l |> left_join(select(station_data, all_of(c("ClimateID", "TimeZone"))),
            join_by("ClimateID" == "ClimateID")) |>
            mutate(DateTime = force_tz(.data$DateTime,
                tzone = .data$TimeZone)) |>
            select(!all_of("TimeZone")) |>
            arrange(.data$ClimateID, .data$DateTime)
    } else {
        l |> arrange(.data$ClimateID, .data$Date)
    }
    ## return
    l
}
