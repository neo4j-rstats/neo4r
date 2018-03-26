# con <- neo4r::neo4j_api$new(url = "http://localhost:7474", user = "neo4j", password = "pouetpouet")
# con$ping()
# res <- call_api("MATCH p=()-[r:PROGRAMS_IN]->() RETURN p, r LIMIT 25", con, type = "graph")
# res <- call_api("MATCH p=()-[r:MAINTAINS]->() RETURN p LIMIT 25", con, type = "graph")

#' Convert to another graph format
#'
#' @param res the res object from the API
#' @param format the format (either igraph or visNetwork)
#' @param label the column to be considered as the label columns
#'
#' @importFrom dplyr select
#' @importFrom igraph graph_from_data_frame
#' @importFrom tidyselect everything
#'
#' @return a transformed list
#' @export
#'

convert_to <- function(res, format = c("visNetwork", "igraph"), label = name){
  if (format == "visNetwork"){
    lab <- deparse(substitute(label))
    nodes <- unnest_nodes(res$nodes)
    rel <- unnest_relationships(res$relationships)
    names(nodes)[2] <- "group"
    label_col <- which(names(nodes) == lab)
    names(nodes)[label_col] <- "label"
    names(rel)[3] <- "from"
    names(rel)[4] <- "to"
    return(list(nodes = nodes, relationships = rel))
  }

  if (format == "igraph"){
    lab <- enquo(label)
    unnested_res <- list()

    if (!is.null(res$nodes)){
      unnested_res$nodes <- unnest_nodes(res$nodes)
      unnested_res$nodes <- select(unnested_res$nodes, id, name = !! lab, group = label, everything())
    } else {
      unnested_res$nodes <- NULL
    }

    if (!is.null(res$relationships)){
      unnested_res$relationships <- select(res$relationships, startNode,
                                           endNode, type, id, properties)
    } else {
      unnested_res$relationships <- NULL
    }

    graph_from_data_frame(d = unnested_res$relationships,
                          directed = TRUE,
                          vertices = unnested_res$nodes)

  }
}


# convert_to(res, "visNetwork")
# df <- res$nodes

parse_node <- function(df){
  id <- df$id
  label <- unnest(df[, "label"])
  properties <- as.data.frame(unlist(df[, "properties"]))
}
