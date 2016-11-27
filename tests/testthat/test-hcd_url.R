library("testthat")
library("canadaHCD")

context("Test `hcd_url()`")

## test URL generation
test_that("hcd_url() returns a tbl_df for timescale = hourly", {
    df <- hcd_url("2855", timescale = "hourly", year = 2015, month = 1)
    expect_that(df, is_a("tbl_df"))
    expect_identical(ncol(df), 4L)
    expect_named(df, expected = c("station", "year", "month", "url"))
})

## test URL generation
test_that("hcd_url() returns a tbl_df for timescale = daily", {
    df <- hcd_url("2855", timescale = "daily", year = 2015)
    expect_that(df, is_a("tbl_df"))
    expect_identical(ncol(df), 3L)
    expect_named(df, expected = c("station", "year", "url"))
})

## test URL generation
test_that("hcd_url() returns a tbl_df for timescale = monthly", {
    df <- hcd_url("2855", timescale = "monthly")
    expect_that(df, is_a("tbl_df"))
    expect_identical(ncol(df), 2L)
})

## Test variable types
test_that("hcd_url() returns correct variables types: monthly", {
    df <- hcd_url("2855", timescale = "monthly")
    expect_named(df, expected = c("station", "url"))
    expect_type(df$station, "integer")
    expect_type(df$url, "character")
})

test_that("hcd_url() returns correct variables types: daily", {
    df <- hcd_url("2855", timescale = "daily", year = 2015)
    expect_named(df, expected = c("station", "year", "url"))
    expect_type(df$station, "integer")
    expect_type(df$year, "integer")
    expect_type(df$url, "character")
})

test_that("hcd_url() returns correct variables types: hourly", {
    df <- hcd_url("2855", timescale = "hourly", year = 2015, month = 1)
    expect_named(df, expected = c("station", "year", "month", "url"))
    expect_type(df$station, "integer")
    expect_type(df$year, "integer")
    expect_type(df$month, "integer")
    expect_type(df$url, "character")
})
