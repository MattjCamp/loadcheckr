
#' Check Column Meta Data
#'
#' Checks the column names, column lengths and data types in both data tables
#' @param ref \link[loadcheckr]{check_db_references} object that holds the connections and tables that you are comparing
#' @export
#' @return dataframe listing out the results of the test

check_db_columns <- function(ref) {

  library(magrittr)

  x <- dbr::show_columns(ref$conn_x, ref$schema_x, ref$table_name_x)
  y <- dbr::show_columns(ref$conn_y, ref$schema_y, ref$table_name_y)

  both <-
    inner_join(x, y, by = c("table_name", "column_name")) %>%
    mutate(is = "both") %>%
    select(is, table_name, column_name, data_type.x, data_type.y,
           col_order.x = column_order.x, col_order.y = column_order.y,
           col_length.x, col_length.y)

  only_in_x <-
    anti_join(x, y, by = c("table_name", "column_name")) %>%
    mutate(is = "only_in_x") %>%
    select(is, everything(), -table_schema) %>%
    rename(data_type.x = data_type,
           col_length.x = col_length,
           col_order.x = column_order)

  only_in_y <-
    anti_join(y, x, by = c("table_name", "column_name")) %>%
    mutate(is = "only_in_y") %>%
    select(is, everything(), -table_schema) %>%
    rename(data_type.y = data_type,
           col_length.y = col_length,
           col_order.y = column_order)

  ds <- bind_rows(both, only_in_x, only_in_y)

  ds <-
    ds %>%
    mutate(match_data_type =  data_type.x ==  data_type.y,
           match_col_length = col_length.x == col_length.y,
           match_col_order = col_order.x == col_order.y,
           match_data_type = ifelse(is.na(match_data_type), ifelse(is.na(data_type.x) & is.na(data_type.y), TRUE, FALSE), match_data_type),
           match_col_length = ifelse(is.na(match_col_length), ifelse(is.na(col_length.x) & is.na(col_length.y), TRUE, FALSE), match_col_length),
           match_col_order = ifelse(is.na(match_col_order), ifelse(is.na(col_order.x) & is.na(col_order.y), TRUE, FALSE), match_col_order)) %>%
    select(is, table_name, column_name, match_data_type, match_col_length, match_col_order, everything())

  ds

}
