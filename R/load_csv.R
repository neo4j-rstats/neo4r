#' Load a CSV to Neo4J
#'
#' @inheritParams call_neo4j
#'
#' @param on_load the code to execute on load
#' @param url the url of the csv
#' @param header does the csv have a header?
#' @param periodic_commit the PERIODIC COMMIT cypher arg
#' @param as the AS cypher arg
#'
#' @importFrom glue glue
#'
#' @return a csv loaded to Neo4J
#' @export


load_csv <- function(on_load = "", con, url, header = TRUE,
                     periodic_commit = 1000, as = "csv",
                     type = c("row", "graph"), output = c("r", "json"),
                     include_stats = TRUE, include_meta = FALSE) {
  type <- match.arg(type)
  output <- match.arg(output)
  if (header) {
    q <- glue("USING PERIODIC COMMIT {periodic_commit} LOAD CSV WITH HEADERS FROM '{url}' AS {as} {on_load}")
  } else {
    q <- glue("USING PERIODIC COMMIT {periodic_commit} LOAD CSV FROM '{url}' AS {as} {on_load}")
  }
  call_neo4j(
    query = q,
    con = con,
    type = type,
    output = output,
    include_stats = include_stats,
    include_meta = include_meta
  )
}


# send_r_object <- function(object, con, on_load = "", header = TRUE,
#                           periodic_commit = NULL, as = "csv",
#                           type = c("row","graph"), output = c("r", "json"),
#                           include_stats = TRUE, meta = FALSE, port = 2811) {
#   browser()
#   type <- match.arg(type)
#   output <- match.arg(output)
#
#   tmp <- tempfile(fileext = ".csv")
#   write.csv(object, tmp)
#   port <- port
#   host <- "127.0.0.1"
#   x <- servr::httd(dir = dirname(tmp), port = port, host = "127.0.0.1")
#   url <- glue("http://{host}:{port}/{basename(tmp)}")
#   GET("http://127.0.0.1:2811")
#   if (header){
#     q <- glue("LOAD CSV WITH HEADERS FROM '{url}' AS {as} {on_load}")
#   } else {
#     q <- glue("LOAD CSV FROM '{url}' AS {as} {on_load}")
#   }
#   if (!is.null(periodic_commit)){
#     q <- glue("USING PERIODIC COMMIT {periodic_commit} {q}")
#   }
#   res <- call_api(query = q,
#            con = con,
#            type = type,
#            output = output,
#            include_stats = include_stats,
#            meta = meta)
#
#   on.exit(servr::daemon_stop(x))
#   return(res)
# }
# send_r_object(
#   dplyr::band_instruments,
#   con,
#   on_load = 'RETURN *'
#   )
#
# on_load_query <-
# # Send the csv
# load_csv(url = "https://raw.githubusercontent.com/ThinkR-open/datasets/master/tracks.csv",
#          con = con, header = TRUE, periodic_commit = 50,
#          as = "csvLine", on_load = on_load_query)
