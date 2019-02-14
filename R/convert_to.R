# Not in use anymore until we figure this out
#
#' #' Convert to another graph format
#' #'
#' #' @param res the res object from the API
#' #' @param format the format (either igraph or visNetwork)
#' #' @param label the column to be considered as the label columns
#' #'
#' #' @importFrom rlang enquo
#' #' @importFrom igraph graph_from_data_frame
#' #' @importFrom tidyselect everything vars_select
#' #'
#' #' @return a transformed list
#' #' @export
#' #'
#'
#' convert_to <- function(res, format = c("visNetwork", "igraph"),
#'                        label = name) {
#'   format <- match.arg(format)
#'   if (format == "visNetwork") {
#'     lab <- deparse(substitute(label))
#'     nodes <- unnest_nodes(res$nodes)
#'     rel <- unnest_relationships(res$relationships)
#'     names(nodes)[2] <- "group"
#'     label_col <- which(names(nodes) == lab)
#'     names(nodes)[label_col] <- "label"
#'     names(rel)[3] <- "from"
#'     names(rel)[4] <- "to"
#'     return(list(nodes = nodes, relationships = rel))
#'   }
#'
#'   if (format == "igraph") {
#'     lab <- enquo(label)
#'     unnested_res <- list()
#'
#'     if (!is.null(res$nodes)) {
#'       unnested_res$nodes <- unnest_nodes(res$nodes)
#'       unnested_res$nodes <- unnested_res$nodes[, vars_select(
#'         names(unnested_res$nodes),
#'         id, !!lab, everything()
#'       )]
#'     } else {
#'       unnested_res$nodes <- NULL
#'     }
#'
#'     if (!is.null(res$relationships)) {
#'       res$relationships <- unnest_relationships(res$relationships)
#'       unnested_res$relationships <- res$relationships[, vars_select(
#'         names(res$relationships),
#'         startNode, endNode, type, id, everything()
#'       )]
#'     } else {
#'       unnested_res$relationships <- NULL
#'     }
#'
#'     graph_from_data_frame(
#'       d = unnested_res$relationships,
#'       directed = TRUE,
#'       vertices = unnested_res$nodes
#'     )
#'   }
#' }
#'
#' parse_node <- function(df) {
#'   id <- df$id
#'   label <- unnest(df[, "label"])
#'   properties <- as.data.frame(unlist(df[, "properties"]))
#' }
