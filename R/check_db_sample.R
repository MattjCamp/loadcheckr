
#' Check Random Row Sample
#'
#' Checks all the content in a randomly selected set of rows. This function ignores data column case.
#' @param ref \link[loadcheckr]{check_db_references} object that holds the connections and tables that you are comparing
#' @param keys the list of keys that will uniquely identify rows
#' @param num_rows the number of rows that you will randomly sample
#' @export
#' @return dataframe listing out the results of the test

check_db_random_sample <- function(ref, keys, num_rows) {

  library(magrittr)

  k <- stringr::str_to_lower(coderr::code_vector_to_csv_list(keys, FALSE, FALSE))

  k <-
    sprintf("select %s from %s.%s", k, ref$schema_x, ref$table_name_x) %>%
    dbr::pull_data(ref$conn_x) %>%
    sample_n(size = num_rows)

  # MAKE WHERE STATEMENT FOR KEY COMBOS

  f <- NULL
  for (rows in 1:nrow(k)) {
    l <- NULL
    for (cols in 1:length(names(k))) {
      l <- c(l, sprintf("%s = '%s'", names(k)[cols], k[rows, cols]))
    }
    l <- paste(l, collapse = " and ")
    l <- sprintf("(%s)", l)
    f <- c(f, l)
  }
  f <- paste(f, collapse = " or ")

  # PULL OUT THE RANDOM ROWS

  get_records_for_key <- function(conn, schema, table_name) {

    d <-
      sprintf("select * from %s.%s where %s", schema, table_name, f) %>%
      pull_data(conn)

    names(d) <- str_to_lower(names(d))

    d

  }

  x <- get_records_for_key(conn = ref$conn_x, schema = ref$schema_x,
                           table_name = ref$table_name_x)
  x <- x %>% long(match(keys, table = names(x)))

  y <- get_records_for_key(conn = ref$conn_y, schema = ref$schema_y,
                           table_name = ref$table_name_y)
  y <- y %>% long(match(keys, table = names(y)))

  for (i in 1:length(names(x)))
    x[i] <- as.vector(sapply(x[i], as.character))
  for (i in 1:length(names(y)))
    y[i] <- as.vector(sapply(y[i], as.character))

  dp <- data_points(x, y)

  show_values(dp)

}
