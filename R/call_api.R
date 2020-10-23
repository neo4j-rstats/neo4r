clean_query <- function(query) {
  res <- gsub("^\\/\\/.+$", "\n", query, perl = TRUE)
  res <- gsub("\n", " ", res)
  res <- gsub("\"", "'", res)
  res
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

call_neo4j <- function(query, con, params = list(),
                       type = c("row", "graph"),
                       output = c("r", "json"),
                       include_stats = FALSE,
                       include_meta = FALSE) {
  # browser()
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

  # if parameters are empty then they need to be a vector
  # in order for the json POST body to be formatted correctly
  if (length(params) == 0) params <- c()

  post_body <- list(
    statements = list(
      list(
        statement = query_clean,
        parameters = params,
        resultDataContents = list(type)
      )
    )
  )

  # add include_stats and meta based on user preferences
  if (include_stats) body$statements[[1]]$includeStats = include_stats
  if (include_meta) body$statements[[1]]$meta = include_meta

  # POST URL (different for pre-4.x vs. 4.x)
  if (con$major_version < 4) {
    # for Neo4j versions before 4.x
    post_url <- glue("{con$url}/db/data/transaction/commit")
  } else {
    # for Neo4j version 4.x
    post_url <- glue("{con$url}/db/{con$db}/tx/commit")
  }

  # Calling the API
  res <- POST(
    url = post_url,
    add_headers(.headers = c(
      "Content-Type" = "application/json",
      "accept" = "application/json",
      # "X-Stream" = "true",
      "Authorization" = paste0("Basic ", con$auth)
    )),
    body = post_body,
    encode = "json"
  )

  # Verify the status code is 200
  stop_if_not(status_code(res), ~.x == 200, "API error")
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
#   url <- glue("{con$url}/db/data/transaction/commit")
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
