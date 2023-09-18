library("testthat")
library("canadaHCD")

context("Test `find_station()`")

## test finding a station by name
test_that("find_station() can locate a station", {
    df <- find_station("Yellowknife")
    expect_that(df, is_a("hcd_station_list"))
    expect_that(df, is_a("tbl_df"))
    expect_that(df, is_a("data.frame"))
    expect_equal(nrow(df), 6L)
})
