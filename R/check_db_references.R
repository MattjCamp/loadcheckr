
#' Holds References to Connections
#'
#' Holds references to both data connections and the tables being compared
#' @param conn_x the first dbr data connection
#' @param schema_x the first database schema name
#' @param table_x the first table name
#' @param conn_y the second dbr data connection
#' @param schema_y the second database schema name
#' @param table_y the second table name
#' @export
#' @return a list of dbr data connections and table names that can be compared

check_db_references <- function(conn_x, schema_x, table_name_x,
                                conn_y, schema_y, table_name_y) {

  me <- list()
  me$conn_x = conn_x
  me$schema_x = schema_x
  me$table_name_x = table_name_x
  me$conn_y = conn_y
  me$schema_y = schema_y
  me$table_name_y = table_name_y

  me

}
