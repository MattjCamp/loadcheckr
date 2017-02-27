
context("CHECK ROWS")

# NOTE YOU WILL NEED TO WRITE YOUR OWN SCRIPT TO OPEN CONNECTIONS
# TO YOUR DATABASE THAT RETURNS THESE OBJECTS:
# conn_a        (dbr style data connection)
# conn_b        (dbr style data connection)
# table_name_a  (table name required by connection)
# table_name_b  (table name required by connection)

source("open_connections.R")

library(testthat)

test_that("check_db_rows", {

  expect_error({1 == 0})

})

source("close_connections.R")
