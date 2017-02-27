
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

  check <- check_db_rows(conn_a = conn_a,
                         table_name_a = table_name_a,
                         conn_b = conn_b,
                         table_name_b = table_name_b)

})

test_that("check_db_row_keys_match", {

  check <- check_db_row_keys_match(conn_a = conn_a,
                                   table_name_a = table_name_a,
                                   conn_b = conn_b,
                                   table_name_b = table_name_b,
                                   key_field = "person_id")

})

test_that("check_db_random_sample", {

  check <- check_db_random_sample(conn_a = conn_a,
                                  table_name_a = table_name_a,
                                  conn_b = conn_b,
                                  table_name_b = table_name_b,
                                  key_field = "person_id",
                                  key_field_index = c(2,41),
                                  num_rows = 1)

})


source("close_connections.R")
