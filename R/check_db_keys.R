
#' Check Keys
#'
#' Checks whether the same records appear in both data tables based on a set of keys
#' @param ref \link[loadcheckr]{check_db_references} object that holds the connections and tables that you are comparing
#' @export
#' @return dataframe listing out the results of the test

check_db_keys <- function(ref) {

  library(magrittr)

  k <- stringr::str_to_lower(coderr::code_vector_to_csv_list(ref$keys, FALSE, FALSE))

  x <-
    sprintf("select %s from %s.%s", k, ref$schema_x, ref$table_name_x) %>%
    dbr::pull_data(ref$conn_x)

  y <-
    sprintf("select %s from %s.%s", k, ref$schema_y, ref$table_name_y) %>%
    dbr::pull_data(ref$conn_y)

  common <-
    inner_join(x, y) %>%
    mutate(check = "check_db_keys", match = "common") %>%
    select(check, match, everything())
  only_in_x <-
    anti_join(x, y) %>%
    mutate(check = "check_db_keys", match = "only_in_x") %>%
    select(check, match, everything())
  only_in_y <-
    anti_join(y, x) %>%
    mutate(check = "check_db_keys", match = "only_in_y") %>%
    select(check, match, everything())
  d <-
    bind_rows(common, only_in_x, only_in_y) %>%
    mutate(tables = sprintf("%s.%s :: %s.%s", ref$schema_x, ref$table_name_x,
                            ref$schema_y, ref$table_name_y))

  d

}
