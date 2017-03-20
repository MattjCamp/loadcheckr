
context("CHECK ROWS")

# NOTE YOU WILL NEED TO WRITE YOUR OWN SCRIPT TO OPEN CONNECTIONS
# TO YOUR DATABASE THAT RETURNS A check_db_references OBJECT WITH THIS STUFF:
# conn_x        (dbr style data connection)
# conn_y        (dbr style data connection)
# table_name_x  (table name required by connection)
# table_name_y  (table name required by connection)

source("open_connections.R")

library(testthat)

test_that("check_db_rows", {
  check_db_rows(ref1)
})

test_that("check_db_keys", {
  check_db_keys(ref2)
})

test_that("check_db_random_sample", {

  t <- check_db_random_sample(ref = ref1,
                              num_rows = 5)
  t <- t$ds
  t %>% group_by(is, variable) %>% count()

})

source("close_connections.R")
