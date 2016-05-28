library("testthat")
library("canadaHCD")

context("Test `hcd_daily()`")

## test downloading of file from HCD dataset
test_that("hcd_daily() returns a tbl_df", {
    skip_on_cran()
    df <- hcd_daily("2855", 2015)
    expect_that(df, is_a("tbl_df"))
})

## test downloading of multiple files from HCD dataset
test_that("hcd_daily() works with multiple stations", {
    skip_on_cran()
    df <- hcd_daily(c("2855", "2855"), year = 2015)
    expect_that(df, is_a("tbl_df"))
    df <- hcd_daily(c("2855", "2855"), year = 2015, collapse = FALSE)
    expect_that(df, is_a("list"))
    expect_identical(length(df), 2L)
    expect_that(df[[1]], is_a("tbl_df"))
    expect_that(df[[2]], is_a("tbl_df"))
})

## test downloading of multiple years from a single HCD dataset
test_that("hcd_daily() works with multiple years", {
    skip_on_cran()
    df <- hcd_daily("2855", year = 2013:2015)
    expect_that(df, is_a("tbl_df"))
    df <- hcd_daily("2855", year = 2013:2015, collapse = FALSE)
    expect_that(df, is_a("list"))
    expect_identical(length(df), 3L)
    expect_that(df[[1]], is_a("tbl_df"))
    expect_that(df[[2]], is_a("tbl_df"))
    expect_that(df[[3]], is_a("tbl_df"))
})

