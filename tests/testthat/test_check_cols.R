
context("CHECK COLUMNS")

source("open_connections.R")

library(testthat)

test_that("check_db_columns", {

  check_db_columns(ref3)

})

source("close_connections.R")
