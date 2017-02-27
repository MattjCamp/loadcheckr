
#' Check All Records
#'
#' Checks whether the same records appear in both data tables based on a primary key
#' @param conn_a the first dbr data connection
#' @param table_a the first table name
#' @param conn_b the second dbr data connection
#' @param table_b the second table name
#' @param key_field what you are using as a primary key to compare rows, if you make a composite put it in parenthesis (person + date)
#' @export
#' @return output of a datapointsr::show_values object

check_db_row_keys_match <- function(conn_a, table_name_a, conn_b, table_name_b, key_field) {

  library(tidyverse)

  get_row_keys <- function(conn, table_name, key_field){

    d <-
      sprintf("select %s as key_field from %s", key_field, table_name) %>%
      pull_data(conn)

    d <- data.frame(list(cat = "Key_Field",
                         variable = as.character(d$key_field),
                         value = as.character(d$key_field)))

    d

  }

  a <- get_row_keys(conn = conn_a,
                    table_name = table_name_a,
                    key_field = key_field)

  b <- get_row_keys(conn = conn_b,
                    table_name = table_name_b,
                    key_field = key_field)

  dp <- datapointsr::data_points(a, b)

  dm <- datapointsr::show_values(dp)

  print(dm)

  dm

}
