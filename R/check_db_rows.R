
#' Check Row Counts
#'
#' Checks the number of rows in both data tables
#' @param conn_a the first dbr data connection
#' @param table_a the first table name
#' @param conn_b the second dbr data connection
#' @param table_b the second table name
#' @export
#' @return a list of objects describing the results, prints out to the log as well

check_db_rows <- function(conn_a, table_name_a, conn_b, table_name_b) {

  library(tidyverse)

  a <- sprintf("select * from %s", table_name_a) %>%
    coderr::code_sql_count() %>%
    dbr::pull_data(conn_a)

  b <- sprintf("select * from %s", table_name_b) %>%
    coderr::code_sql_count() %>%
    dbr::pull_data(conn_b)

  report <- data.frame(list(check = "num rows",
                            table_a = a$n,
                            table_b = b$n,
                            match = a$n == b$n))

  print(report)

  report

}
