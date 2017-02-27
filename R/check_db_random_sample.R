
#' Check Random Row Sample
#'
#' Checks all the content in a randomly selected set of rows. This function ignores data column case.
#' @param conn_a the first dbr data connection
#' @param table_a the first table name
#' @param conn_b the second dbr data connection
#' @param table_b the second table name
#' @param key_field what you are using as a primary key to compare rows, if you make a composite put it in parenthesis (person + date)
#' @param num_rows the number of rows that you want to look at
#' @export
#' @return output of a datapointsr::show_values object

check_db_random_sample <- function(conn_a, table_name_a, conn_b, table_name_b,
                                   key_field, key_field_index, num_rows) {

  library(tidyverse)

  r <-
    sprintf("select %s as key_field from %s", key_field, table_name_a) %>%
    pull_data(conn) %>%
    distinct(key_field) %>%
    sample_n(size = num_rows)

  r <- coderr::code_vector_to_csv_list(r$key_field,
                                       add.quotes = TRUE,
                                       enclose.in.parenthesis = TRUE)

  get_records_for_key <- function(conn, table_name) {

    d <-
      sprintf("select * from %s where %s in %s",
          table_name, key_field, r) %>%
      pull_data(conn)

    names(d) <- str_to_lower(names(d))

    d[, key_field_index] <-  as.character(d[, key_field_index])

    d

  }

  a <- get_records_for_key(conn = conn_a, table_name = table_name_a) %>%
    long(key_field_index)
  b <- get_records_for_key(conn = conn_b, table_name = table_name_b) %>%
    long(key_field_index)

  dp <- datapointsr::data_points(a, b)
  dm <- datapointsr::show_values(dp)

  print(dm)

  dm

}
