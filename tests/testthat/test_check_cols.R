
context("CHECK COLUMNS")

# NOTE YOU WILL NEED TO WRITE YOUR OWN SCRIPT TO OPEN CONNECTIONS
# TO YOUR DATABASE THAT RETURNS THESE OBJECTS:
# conn_a        (dbr style data connection)
# conn_b        (dbr style data connection)
# table_name_a  (table name required by connection)
# table_name_b  (table name required by connection)

source("open_connections.R")

library(testthat)

test_that("check_db_columns", {

  check <- check_db_columns(conn_a = conn_a,
                            table_name_a = table_name_a,
                            conn_b = conn_b,
                            table_name_b = table_name_b,
                            ignore_case = TRUE)

})

source("close_connections.R")
