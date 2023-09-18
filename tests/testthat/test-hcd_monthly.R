library("testthat")
library("canadaHCD")

context("Test `hcd_monthly()`")

df <- hcd_monthly("2855")

## test downloading of file from HCD dataset
test_that("hcd_monthly(n) returns a tbl_df", {
    skip_on_cran()
    expect_that(df, is_a("tbl_df"))
})

## test that a HCD Monthly object always has a yearmon class Date variable
test_that("hcd_monthly(n) Date variables is class 'yearmon'", {
    skip_on_cran()
    expect_that(df$Date, is_a("yearmon"))
})

## test downloading of multiple files from HCD dataset
test_that("hcd_monthly(n) works with multiple stations", {
    skip_on_cran()
    dfs <- hcd_monthly(c("2855", "2855"))
    expect_that(dfs, is_a("tbl_df"))
    dfs <- hcd_monthly(c("2855", "2855"), collapse = FALSE)
    expect_that(dfs, is_a("list"))
    expect_identical(length(dfs), 2L)
    expect_that(dfs[[1]], is_a("tbl_df"))
    expect_that(dfs[[2]], is_a("tbl_df"))
})
