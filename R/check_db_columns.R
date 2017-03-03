
#' Check Column Meta Data
#'
#' Checks the column names, column lengths and data types in both data tables
#' @param ref \link[loadcheckr]{check_db_references} object that holds the connections and tables that you are comparing
#' @export
#' @return dataframe listing out the results of the test

check_db_columns <- function(ref) {

  library(magrittr)

  x <- show_columns(ref$conn_x, ref$schema_x, ref$table_name_x)
  y <- show_columns(ref$conn_y, ref$schema_y, ref$table_name_y)

  common <-
    inner_join(x, y, by = c("table_name", "column_name")) %>%
    mutate(check = "check_db_columns",
           match = "common") %>%
    select(check, match, everything()) %>%
    mutate(match_data_type =  data_type.x ==  data_type.y,
           match_col_length = col_length.x == col_length.y,
           match_col_order = column_order.x == column_order.y)
  only_in_x <- anti_join(x, y, by = c("table_name", "column_name")) %>%
    mutate(check = "check_db_columns",
           match = "only_in_x") %>%
    select(check, match, everything())
  only_in_y <- anti_join(y, x, by = c("table_name", "column_name")) %>%
    mutate(check = "check_db_columns",
           match = "only_in_y") %>%
    select(check, match, everything())

  me <- list()
  me$common <- common

  if (nrow(only_in_x) != 0 & nrow(only_in_y) != 0 )
      me$mismatched <- bind_rows(only_in_x, only_in_y)

  me

}
