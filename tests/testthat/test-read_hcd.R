library("testthat")
library("canadaHCD")

context("Test `read_hcd()`")

## test reading a monthly HCD dataset file
test_that("read_hcd() returns a tbl_df", {
    df <- read_hcd(system.file("extdata/2855-monthly-data.csv",
                               package = "canadaHCD"))
    expect_that(df, is_a("tbl_df"))
})


