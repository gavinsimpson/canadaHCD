library("testthat")
library("canadaHCD")

## test finding a station by name
test_that("find_station() can locate a station", {
    df <- find_station("Yellowknife")
    expect_s3_class(df, "hcd_station_list")
    expect_s3_class(df, "tbl_df")
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 6L)
})
