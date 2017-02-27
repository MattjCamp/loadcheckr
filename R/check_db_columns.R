
#' Check Columns
#'
#' Checks the column names and data types in both data tables
#' @param conn_a the first dbr data connection
#' @param table_a the first table name
#' @param conn_b the second dbr data connection
#' @param table_b the second table name
#' @param ignore_case ignore case when comparing column names
#' @description Checks whether the data sources agree on data types: any numeric == any numeric, any character == any character
#' @export
#' @return a list of objects describing the results, prints out to the log as well

check_db_columns <- function(conn_a, table_name_a, conn_b, table_name_b, ignore_case = FALSE) {

  library(tidyverse)

  get_column_information <- function(conn, table_name){

    d <- sprintf("select * from %s", table_name) %>%
      coderr::code_sql_head(1) %>%
      dbr::pull_data(conn)
    n <- str_to_upper(names(d))
    m <- sapply(d, mode)[1:length(d)]
    m <- as.character(m)
    o <- row.names(d)

    d <- data.frame(list(data_type = m,
                         column = n,
                         order = o)) %>%
      long(2)

    d

  }

  a <- get_column_information(conn = conn_a,
                              table_name = table_name_a)

  b <- get_column_information(conn = conn_b,
                              table_name = table_name_b)

  # CLEAN

  if (ignore_case) {
    a <- a %>% mutate(column = str_to_lower(column))
    b <- b %>% mutate(column = str_to_lower(column))
  }

  # COMPARE

  dp <- datapointsr::data_points(a, b)
  comp <- show_values(dp)

  # NUM COLUMNS

  report <- data.frame(list(check = "num columns",
                            table_a = a %>% filter(variable == "data_type") %>% nrow(),
                            table_b = b %>% filter(variable == "data_type") %>% nrow(),
                            match = isTRUE(comp$match$equal == TRUE)))

  print(report)

  me <- list()

  me$report <- report
  if (!is.null(comp$mis_matched))
    me$mis_matched <- comp$mis_matched

  me

}
