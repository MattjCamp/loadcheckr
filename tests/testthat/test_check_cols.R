
context("CHECK COLUMNS")

source("open_connections.R")

library(testthat)

test_that("check_db_columns", {

  t <- check_db_columns(ref3)

  t %>% group_by(is, match_data_type, match_col_length, match_col_order) %>% count()

})

source("close_connections.R")
