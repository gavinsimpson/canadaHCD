library("testthat")
library("canadaHCD")

## test downloading of file from HCD dataset
test_that("hcd_daily() returns a tbl_df", {
    skip_on_cran()
    expect_output(df <- hcd_daily("2855", 2015))
    expect_s3_class(df, "tbl_df")
})

## test downloading of multiple files from HCD dataset
test_that("hcd_daily() works with multiple stations", {
    skip_on_cran()
    expect_output(df <- hcd_daily(c("2855", "2855"), year = 2015))
    expect_s3_class(df, "tbl_df")
    expect_output(df <- hcd_daily(c("2855", "2855"), year = 2015,
        collapse = FALSE))
    expect_type(df, "list")
    expect_identical(length(df), 2L)
    expect_s3_class(df[[1]], "tbl_df")
    expect_s3_class(df[[2]], "tbl_df")
})

## test downloading of multiple years from a single HCD dataset
test_that("hcd_daily() works with multiple years", {
    skip_on_cran()
    expect_output(df <- hcd_daily("2855", year = 2013:2015))
    expect_s3_class(df, "tbl_df")
    expect_output(df <- hcd_daily("2855", year = 2013:2015, collapse = FALSE))
    expect_type(df, "list")
    expect_identical(length(df), 3L)
    expect_s3_class(df[[1]], "tbl_df")
    expect_s3_class(df[[2]], "tbl_df")
    expect_s3_class(df[[3]], "tbl_df")
})
