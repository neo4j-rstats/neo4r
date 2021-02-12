clean_query <- function(query) {
  res <- gsub("^\\/\\/.+$", "\n", query, perl = TRUE)
  res <- gsub("\n", " ", res)
  res <- gsub("\"", "'", res)
  res
}

#' @importFrom jsonlite toJSON

to_json_neo <- function(query, include_stats, meta, type) {
  toJSON(
    list(
      statement = query,
      includeStats = include_stats,
      meta = meta,
      resultDataContents = list(type)
    ),
    auto_unbox = TRUE
  )
}

#' Call Neo4J API
#'
#' @param query The cypher query
#' @param con A NEO4JAPI connection object
#' @param type Return the result as row or as graph
#' @param output Use "json" if you want the output to be printed as JSON
#' @param include_stats tShould the stats about the transaction be included?
#' @param include_meta tShould the stats about the transaction be included?
#'
#' @importFrom glue glue
#' @importFrom attempt stop_if_not
#' @importFrom httr POST status_code add_headers
#'
#' @return the result from the Neo4J Call
#' @export

call_neo4j <- function(query, con,
                       type = c("row", "graph"),
                       output = c("r", "json"),
                       include_stats = FALSE,
                       include_meta = FALSE) {
  #browser()
  stop_if_not(
    con, ~"Neo4JAPI" %in% class(.x),
    "Please use a Neo4JAPI object."
  )
  # Ensure the inputs are the one we expect
  output <- match.arg(output)
  # format <- match.arg(format)
  type <- match.arg(type)

  # Clean the query to prevent weird mess up with " and stuffs
  query_clean <- clean_query(query)

  # Transform the query to a Neo4J JSON format
  query_jsonised <- to_json_neo(query_clean, include_stats, include_meta, type)
  # Unfortunately I was not able to programmatically convert everything to JSON
  body <- glue('{"statements" : [ %query_jsonised% ]}', .open = "%", .close = "%")

  if (con$is_V4 == TRUE ) {
    turl = glue("{con$url}/db/{con$db}/tx/commit?includeStats=true")
  } else {
    turl = glue("{con$url}/db/data/transaction/commit?includeStats=true")
  }
  # Calling the API
  res <- POST(
    #must use con db here to correct endpoint
    url = glue("{turl}"),
    add_headers(.headers = c(
      "Content-Type" = "application/json",
      "accept" = "application/json",
      # "X-Stream" = "true",
      "Authorization" = paste0("Basic ", con$auth)
    )),
    body = body
  )

  # Verify the status code is 200
  if (status_code(res)!=200){
    con$last_error <- list( status=FALSE, result=res)
  }
  stop_if_not(status_code(res), ~.x == 200, "Neo4j API error")
  # return(res)

  # Return the parsed output, to json or to R
  if (output == "json") {
    toJSON(lapply(content(res)$results, function(x) x$data), pretty = TRUE)
  } else {
    parse_api_results(
      res = res,
      type = type, format = format,
      include_stats = include_stats,
      meta = include_meta
    )
  }
}

# con <- neo4j_api$new(url = "http://localhost:7474/", user = "neo4j", password = "pouetpouet")
# call_api(query = 'MATCH (n:user) RETURN COUNT (n) AS user_count;', con)

# to_json_neo('MATCH (n:user) RETURN COUNT (n) AS user_count;', TRUE, "row")


# a <- toJSON(list(statement = to_json_neo('MATCH (n:user) RETURN COUNT (n) AS user_count;', TRUE, "row")))
# cat(a)
# glue('plop {query}')

# clean_input <- function(vec){
#   vec <- gsub("^\\/\\/.+$", "\n", vec, perl = TRUE)
#   vec <- paste(gsub("\n", " ", vec), collapse = " ")
#   vec <- gsub(";", ";%", vec)
#   vec <- gsub("\"", "\'", vec)
#   unlist(strsplit(vec, "%"))
# }

# # For debug only
#
# call_api <- function(query, con, format = c("r", "json"), meta = FALSE, with_browser = FALSE, as_one = FALSE, res_api = FALSE){
#   if (with_browser){
#     browser()
#   }
#   query <- clean_query(query)
#   format <- match.arg(format)
#   url <- glue("{con$url}/db/{con$db}data/transaction/commit")
#   res <- POST(url = url,
#               add_headers(.headers = c("Content-Type"="application/json",
#                                        "accept"="application/json",
#                                        #"X-Stream" = "true",
#                                        "Authorization"= paste0("Basic ", auth))),
#               body = glue('{"statements" : [ { "statement" : "%query%"} ]}', .open = "%", .close = "%"))
#   stop_if_not(status_code(res), ~ .x == 200, "API error")
#   if (res_api){
#     return(res)
#   }
#   if (format == "json"){
#     toJSON(lapply(content(res)$results, function(x) x$data), pretty = TRUE)
#   } else {
#     parse_api_results(res, meta)
#   }
# }
