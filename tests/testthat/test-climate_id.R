library("testthat")
library("canadaHCD")

## test finding a climate ID from a station ID
test_that("climate_id() returns station id", {
    id <- climate_id("2855")
    expect_identical(id, "4010879")
})

test_that("climate_id() works with integer station id", {
    id <- climate_id(2855)
    expect_identical(id, "4010879")
})

test_that("climate_id() returns NA is invalid station id", {
    id <- climate_id("999999999999")
    expect_identical(id, NA_character_)
    expect_length(id, 1L)
})

test_that("climate_id() works for vector of station ids", {
    id <- climate_id(c("2855", "1707"))
    expect_identical(id, c("4010879", "2204200"))
    expect_length(id, 2L)
})

## test finding a station ID from a climate ID
test_that("climate_id() returns station id", {
    id <- station_id("4010879")
    expect_identical(id, "2855")
})

test_that("station_id() works with integer climate id", {
    id <- station_id(4010879)
    expect_identical(id, "2855")
})

test_that("station_id() returns NA is invalid climate id", {
    id <- station_id("999999999999")
    expect_identical(id, NA_character_)
    expect_length(id, 1L)
})

test_that("climate_id() works for vector of station ids", {
    id <- station_id(c("4010879", "2204200"))
    expect_identical(id, c("2855", "1707"))
    expect_length(id, 2L)
})
