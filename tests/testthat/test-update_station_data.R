library("testthat")
library("canadaHCD")

## test finding a station by name
test_that("update_station_data() works", {
    skip_on_cran()
    skip_if_offline()
    expect_silent(df <- update_station_data())
    expect_s3_class(df, "hcd_station_list")
    expect_s3_class(df, "tbl_df")
    expect_s3_class(df, "data.frame")
})