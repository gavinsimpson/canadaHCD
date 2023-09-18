library("testthat")
library("canadaHCD")

context("Test `hcd_hourly()`")

## test downloading of file from HCD dataset
test_that("hcd_hourly() returns a tbl_df", {
    skip_on_cran()
    df <- hcd_hourly("2855", year = 2015, month = 1)
    expect_that(df, is_a("tbl_df"))
})

## test downloading of multiple files from HCD dataset
test_that("hcd_hourly() works with multiple stations", {
    skip_on_cran()
    df <- hcd_hourly(c("2855", "2855"), year = 2015, month = 1)
    expect_that(df, is_a("tbl_df"))
    df <- hcd_hourly(c("2855", "2855"), year = 2015, month = 1, collapse = FALSE)
    expect_that(df, is_a("list"))
    expect_identical(length(df), 2L)
    expect_that(df[[1]], is_a("tbl_df"))
    expect_that(df[[2]], is_a("tbl_df"))
})

## test downloading of multiple years from a single HCD dataset
test_that("hcd_hourly() works with multiple years", {
    skip_on_cran()
    df <- hcd_hourly("2855", year = 2013:2014, month = 1)
    expect_that(df, is_a("tbl_df"))
    df <- hcd_hourly("2855", year = 2013:2014, month = 1, collapse = FALSE)
    expect_that(df, is_a("list"))
    expect_identical(length(df), 2L)
    expect_that(df[[1]], is_a("tbl_df"))
    expect_that(df[[2]], is_a("tbl_df"))
})
