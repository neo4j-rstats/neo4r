row_to_cypher <- function(vec, label){
  names_vec <- paste0("`", names(vec), "`")
  vecs <- paste0("'", vec, "'")
  res <- paste(names_vec, vecs, sep = ": ", collapse = ", ")
  paste0("(:`", label, "` {", res, "})")
}

row_to_cypher_with_var <- function(vec, label, variable){
  names_vec <- paste0("`", names(vec), "`")
  vecs <- paste0("'", vec, "'")
  res <- paste(names_vec, vecs, sep = ": ", collapse = ", ")
  paste0("(", variable,":`", label, "` {", res, "})")
}



# row_to_cypher(iris[1, 1:3], "Species")

#' @importFrom tidyselect vars_select
#' @importFrom dplyr quos
#' @importFrom purrr is_empty map_chr
#'
#' @export

as_nodes <- function(tbl, label, ...){
  selection <- quos(...)
  label <- tbl[[deparse(substitute(label))]]
  if (!is_empty(selection)){
    tbl <- tbl[vars_select(names(tbl), !!! selection)]
  }
  index <- 1:nrow(tbl)
  map_chr(index, ~ row_to_cypher(tbl[.x, , drop = FALSE], label[.x])) %>%
    paste(collapse = ", ") %>%
    paste("CREATE ", ., collapse = " ")
}


#' iris %>%
#'   filter(Species == "setosa") %>%
#'   as_nodes(label = Species) %>%
#'   call_api(con, include_stats = TRUE)
#
# 'MATCH (n:versicolor) RETURN COUNT(*) AS count' %>%
#   call_api(con)


# a <- data.frame(snl = "setosa", Sepal.Length = 5.1, link = "LOVES",
#                 end = "Person", Petal.Length = 5.2)

#' @importFrom dplyr enquo

as_relationships <- function(tbl, start_node_label, start_node_properties,
                             relationships, end_node_label, end_node_properties){

  start_node_properties <- enquo(start_node_properties)
  start_node_label <- tbl[[deparse(substitute(start_node_label))]]
  start_node_tbl <- tbl[vars_select(names(tbl), !! start_node_properties)]

  index <- 1:nrow(tbl)
  lhs <- map_chr(index, ~ row_to_cypher_with_var(start_node_tbl[.x, , drop = FALSE], start_node_label[.x], "a"))

  end_node_properties <- enquo(end_node_properties)
  end_node_label <- tbl[[deparse(substitute(end_node_label))]]
  end_node_tbl <- tbl[vars_select(names(tbl), !! end_node_properties)]
  rhs <- map_chr(index, ~ row_to_cypher_with_var(end_node_tbl[.x, , drop = FALSE], end_node_label[.x], var = "b"))
  paste0("MATCH ", lhs, ", MATCH ", rhs,", CREATE (a) -[:", tbl[[deparse(substitute(relationships))]], "]->(b)")

}

# "MATCH (a:setosa {Sepal.Length : '5.1'}), MATCH (b:Person {Petal.Length : '5.2'}), CREATE (a) -[:LOVES]->(b)"
#
# a <- data.frame(snl = c("setosa", "versicolor"),
#                 Sepal.Length = 1:2,
#                 link = c("LOVES", "LOVES"),
#                 end = c("Person", "Person"),
#                 Petal.Length = 2:3)
#
#
# as_relationships(tbl = a, start_node_label = snl, start_node_properties = 2,
#                  relationships = link, end_node_label = end, end_node_properties = Sepal.Length)
#
