#' Unnest a node data.frame
#'
#' @param nodes_tbl the node table
#' @param what what to unnest
#'
#' @importFrom purrr map_df map_int
#' @importFrom tidyr unnest
#' @importFrom tibble as_tibble
#' @importFrom attempt warn_if_any
#'
#' @return a new dataframe
#' @export
#'

unnest_nodes <- function(nodes_tbl, what = c("all", "label", "properties")) {
  what <- match.arg(what)

  if (what == "label") {

    nodes_tbl$label <- map(nodes_tbl$label, na_or_self)
    nodes_tbl$label <- map(nodes_tbl$label, as_tibble)
    nodes_tbl <- nodes_tbl %>% unnest(label, .drop = FALSE)

  } else if (what == "properties") {

    nodes_tbl$properties <- map(nodes_tbl$properties, na_or_self)
    nodes_tbl$properties <- map(nodes_tbl$properties, as_tibble)

    nodes_tbl <- nodes_tbl %>% unnest(properties, .drop = FALSE)

  } else {

    nodes_tbl$label <- map(nodes_tbl$label, na_or_self)
    nodes_tbl$label <- map(nodes_tbl$label, as_tibble)
    #nodes_tbl$label <- map(nodes_tbl$label, ~ .x[1, ])
    nodes_tbl <- nodes_tbl %>% unnest(label, .drop = FALSE)

    nodes_tbl$properties <- map(nodes_tbl$properties, na_or_self)
    nodes_tbl$properties <- map(nodes_tbl$properties, as_tibble)
    nodes_tbl <- nodes_tbl %>% unnest(properties, .drop = FALSE)

  }
  as_tibble(nodes_tbl)
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
#' @note Please note that the properties will be converted to character if the class
#'    is not unique.
#'
#' @return an unnested table
#' @export
#'

unnest_relationships <- function(relationships_tbl) {
  relationships_tbl$properties <- map(relationships_tbl$properties, na_or_self)
  relationships_tbl$properties <- map(relationships_tbl$properties, as_tibble)
  relationships_tbl <- unnest(relationships_tbl, properties)
  while (
    any( map_chr(relationships_tbl, class) == "list" )
  ) {
    relationships_tbl <- unnest(relationships_tbl)
  }
  relationships_tbl
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
