library("testthat")
library("canadaHCD")

## test downloading of file from HCD dataset
test_that("hcd_monthly(n) returns a tbl_df", {
    skip_on_cran()
    expect_output(df <- hcd_monthly("2855"))
    expect_s3_class(df, "tbl_df")
    expect_s3_class(df$Date, "yearmon")
})

## test downloading of multiple files from HCD dataset
test_that("hcd_monthly(n) works with multiple stations", {
    skip_on_cran()
    expect_output(dfs <- hcd_monthly(c("2855", "2855")))
    expect_s3_class(dfs, "tbl_df")
    expect_output(dfs <- hcd_monthly(c("2855", "2855"), collapse = FALSE))
    expect_type(dfs, "list")
    expect_identical(length(dfs), 2L)
    expect_s3_class(dfs[[1]], "tbl_df")
    expect_s3_class(dfs[[2]], "tbl_df")
})
