#' Load a CSV to Neo4J
#'
#' @param on_load the code to execute on load
#' @param con the connexion object
#' @param url the url of the csv
#' @param header does the csv have a header?
#' @param periodic_commit the PERIODIC COMMIT cypher arg
#' @param as the AS cypher arg
#' @param format the format to return
#' @param meta should the result include meta ?
#'
#' @importFrom glue glue
#'
#' @return a csv loaded to Neo4J
#' @export
#'


load_csv <- function(on_load = "", con, url, header = TRUE,
                     periodic_commit = 1000, as = "csv",
                     type = c("row","graph"), output = c("r", "json"),
                     include_stats = TRUE, meta = FALSE){
  type <- match.arg(type)
  output <- match.arg(output)
  if (header){
    q <- glue("USING PERIODIC COMMIT {periodic_commit} LOAD CSV WITH HEADERS FROM '{url}' AS {as} {on_load}")
  } else {
    q <- glue("USING PERIODIC COMMIT {periodic_commit} LOAD CSV FROM '{url}' AS {as} {on_load}")
  }
  call_api(query = q, con = con,type = type, output = output, include_stats = include_stats, meta = meta)
}
