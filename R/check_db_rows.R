
#' Check Row Counts
#'
#' Checks the number of rows in both data tables
#' @param ref \link[loadcheckr]{check_db_references} object that holds the connections and tables that you are comparing
#' @export
#' @return dataframe listing out the results of the test

check_db_rows <- function(ref) {

  library(magrittr)

  x <- sprintf("select * from %s.%s", ref$schema_x, ref$table_name_x) %>%
    coderr::code_sql_count() %>%
    dbr::pull_data(ref$conn_x)

  y <- sprintf("select * from %s.%s", ref$schema_y, ref$table_name_y) %>%
    coderr::code_sql_count() %>%
    dbr::pull_data(ref$conn_y)

  d <- data.frame(list(check = "check_db_rows",
                       match = x$n == y$n,
                       n_x = x$n,
                       n_y = y$n),
                       tables = sprintf("%s.%s :: %s.%s", ref$schema_x, ref$table_name_x,
                                        ref$schema_y, ref$table_name_y))

  d

}
