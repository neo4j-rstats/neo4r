#' Unnest a node data.frame
#'
#' @param nodes_tbl the node table
#' @param what what to unnest
#'
#' @importFrom purrr map_df
#' @importFrom tidyr unnest
#' @importFrom tibble as_tibble
#'
#' @return a new dataframe
#' @export
#'

unnest_nodes <- function(nodes_tbl, what = c("all", "label", "properties")) {
  what <- match.arg(what)
  if (what == "label") {
    res <- unnest(nodes_tbl, label, .drop = FALSE)
  } else if (what == "properties") {
    df <- map_df(nodes_tbl$properties, as_tibble)
    res <- cbind(nodes_tbl[, c("id", "label")], df)
  } else {
    lab <- unnest(nodes_tbl, label, .drop = TRUE)
    df <- map_df(nodes_tbl$properties, as_tibble)
    res <- cbind(lab, df)
  }
  as_tibble(res)
}

# nodes_tbl <- res$nodes
# unnest(nodes_tbl, label)

na_or_self <- function(x) {
  if (length(x) == 0) return(NA)
  x
}

#' Unnest a Relationships table
#'
#' @param relationships_tbl a relationship table
#' @importFrom purrr map_chr
#' @importFrom tidyr unnest
#'
#' @return an unnested table
#' @export
#'

unnest_relationships <- function(relationships_tbl) {
  relationships_tbl$properties <- map_chr(relationships_tbl$properties, na_or_self)
  unnest(relationships_tbl, properties)
}

#' Unnest both relationships and nodes
#'
#' @param res an api graph result
#'
#' @return a list of two unnested data.frames
#' @export
#'

unnest_graph <- function(res) {
  res$nodes <- unnest_nodes(res$nodes)
  res$relationships <- unnest_relationships(res$relationships)
  res
}
