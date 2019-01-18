#' Extract nodes or relationships
#'
#' @param x a result from Neo4J
#'
#' @return a tibble
#' @export
#' @rdname extract
#'

extract_nodes <- function(x) {
  x$nodes
}

#' @export
#' @rdname extract

extract_relationships <- function(x) {
  x$relationships
}
