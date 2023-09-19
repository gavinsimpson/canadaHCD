library("testthat")
library("canadaHCD")

## test downloading of file from HCD dataset
test_that("hcd_hourly() returns a tbl_df", {
    skip_on_cran()
    expect_output(df <- hcd_hourly("2855", year = 2015, month = 1))
    expect_s3_class(df, "tbl_df")
})

## test downloading of multiple files from HCD dataset
test_that("hcd_hourly() works with multiple stations", {
    skip_on_cran()
    expect_output(df <- hcd_hourly(c("2855", "2855"), year = 2015, month = 1))
    expect_s3_class(df, "tbl_df")
    expect_output(df <- hcd_hourly(c("2855", "2855"), year = 2015, month = 1,
        collapse = FALSE))
    expect_type(df, "list")
    expect_identical(length(df), 2L)
    expect_s3_class(df[[1]], "tbl_df")
    expect_s3_class(df[[2]], "tbl_df")
})

## test downloading of multiple years from a single HCD dataset
test_that("hcd_hourly() works with multiple years", {
    skip_on_cran()
    expect_output(df <- hcd_hourly("2855", year = 2013:2014, month = 1))
    expect_s3_class(df, "tbl_df")
    expect_output(df <- hcd_hourly("2855", year = 2013:2014, month = 1,
        collapse = FALSE))
    expect_type(df, "list")
    expect_identical(length(df), 2L)
    expect_s3_class(df[[1]], "tbl_df")
    expect_s3_class(df[[2]], "tbl_df")
})
