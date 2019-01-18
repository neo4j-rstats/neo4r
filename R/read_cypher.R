#' Read a cypher file
#'
#' @param file the path to the cypher file
#'
#' @return a tibble with the queries
#' @export
#'
#' @importFrom purrr map_lgl as_vector map_chr
#' @importFrom tibble tibble
#'
#' @examples
#' \dontrun{
#' read_cypher("random/create.cypher")
#' }

read_cypher <- function(file) {
  res <- readLines(file)
  where <- map_lgl(res, ~grepl("//", .x))
  res <- res[!where]
  res <- paste(res, sep = "", collapse = " ")
  res <- gsub(";", ";%", res)
  res <- gsub("   ", " ", res)
  cypher <- as_vector(strsplit(res, "%"))
  res <- map_chr(cypher, clean_query)
  cypher <- gsub("^ *", "", cypher)
  tbl <- tibble(cypher = cypher)
  class(tbl) <- c("cypher", class(tbl))
  tbl
}

#' Send a cypher file to be executed
#'
#' @param path the path to the cypher file
#' @param con a connexion object created with neo4j_api$new()
#' @param type the type of the format to query for (row or graph)
#' @param output the printing method (r or json)
#' @param include_stats whether of not to include stats
#' @param meta whether of not to include meta info
#' @return a cypher call
#' @export
#'
#' @examples
#' \dontrun{
#' send_cypher("random/create.cypher")
#' path <- "data-raw/constraints.cypher"
#' }

send_cypher <- function(path, con, type = c("row", "graph"), output = c("r", "json"),
                        include_stats = TRUE, meta = FALSE) {
  type <- match.arg(type)
  output <- match.arg(output)
  res <- read_cypher(path)
  map(res$cypher, ~call_neo4j(.x, con, type, output, include_stats, meta))
}

# con <- neo4r::neo4j_api$new(url = "http://localhost:7474", user = "neo4j",
#                            password = "pouetpouet")
# con$ping()

# read_cypher("random/create.cypher")
# cypher_script_to_api("random/create.cypher", con, type = "row")
