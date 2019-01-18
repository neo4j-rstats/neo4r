#' Turn a named vector into a cypher list
#'
#' `vec_to_cypher()` creates a list, and `vec_to_cypher_with_var()`
#' creates a cypher call starting with a variable.
#'
#' @details
#' This function can be used with small vectors you want to send
#' to the server. It can for example be used this way :
#' ```
#' paste("MERGE", vec_to_cypher(iris[1, 1:3], "Species"))
#' ```
#' to create a cypher call.
#'
#' @param vec the vector
#' @param label the label of each vector
#' @param variable the variable to use (for `vec_to_cypher()`)
#'
#' @return a character vector
#' @export
#'
#' @importFrom attempt stop_if
#' @rdname vec_to_cypher
#'
#' @examples
#'
#' vec_to_cypher(iris[1, 1:3], "Species")
#' vec_to_cypher_with_var(iris[1, 1:3], "Species", a)

vec_to_cypher <- function(vec, label) {
  stop_if(names(vec), is.null, "Please insert a named vector")
  names_vec <- paste0("`", names(vec), "`")
  vecs <- paste0("'", vec, "'")
  res <- paste(names_vec, vecs, sep = ": ", collapse = ", ")
  paste0("(:`", label, "` {", res, "})")
}

#' @rdname vec_to_cypher
#' @export
vec_to_cypher_with_var <- function(vec, label, variable) {
  stop_if(names(vec), is.null, "Please insert a named vector")
  variable <- as.character(substitute(variable))
  names_vec <- paste0("`", names(vec), "`")
  vecs <- paste0("'", vec, "'")
  res <- paste(names_vec, vecs, sep = ": ", collapse = ", ")
  paste0("(", variable, ":`", label, "` {", res, "})")
}
