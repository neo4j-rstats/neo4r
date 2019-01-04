#' @importFrom httr content
#' @importFrom attempt stop_if
#' @importFrom purrr flatten transpose modify_depth map map_df as_vector map_chr compact flatten_dfr
#' @importFrom tidyr gather

parse_api_results <- function(res, type, include_stats, meta, format){

  # Get the content as an R list
  api_content <- content(res)

  # Test if there are errors
  if (length(api_content$errors) > 0) {
    # Return the errors if there are any (code + message)
    return(list(error_code = api_content$errors[[1]]$code,
                error_message = api_content$errors[[1]]$message))
  }
  # Get the result element
  results <- api_content$results[[1]]
  # Get the stats (if any)
  if (!is.null(results$stats)){
    stats <- tibble(type = names(results$stats), value = as.numeric(results$stats))
  } else {
    stats <- NULL
  }

  if (length(results$data) == 0){
    message("No data returned.")
    if (include_stats){
      return(stats)
    }
  }

  # Get the name of the columns
  res_names <- results$columns
  # Get the data
  res_data <- results$data
  #res_data <- readRDS("inst/res_data.RDS")
  #res_names <- readRDS("inst/res_names.RDS")
  if (meta) {
    res_meta <- map(res_data, "meta")
  }

  res_data <- map(res_data, function(x){
    x$meta <- NULL
    x
  })

  if (type == "row"){
    # Type = row
    # Special case for handling arrays
    #browser()
    res <- attempt::attempt({
      flatten(res_data) %>%
        transpose() %>%
        map(flatten_dfr)
    }, silent = TRUE)
    if (class(res) == "try-error"){
      res <- flatten(res_data) %>%
        purrr::map_dfr(purrr::flatten_dfc) %>%
        list()
    }
    # if (is.null(names(flatten(flatten(flatten(res_data)))))) {
    #   res <- flatten(res_data) %>%
    #     purrr::map_dfr(purrr::flatten_dfc)
    # } else {
      res <-  res %>%
        setNames(res_names)
    #}
    if (include_stats){
      c(res, list(stats = stats))
    } else {
      res
    }

  } else if (type == "graph") {
    # Get the graph sublist
    graph <- map(res_data, "graph")
    # Get the nodes
    nodes <- compact(map(graph, "nodes"))
    # Get the relationships
    relations <- compact(map(graph, "relationships"))
    # Set the tbl upfront
    nodes_tbl <- NULL
    relations_tbl <- NULL

    # Verify that there is something to return
    if (length(nodes) == 0 & length(relations) == 0){
      message("No graph data found.")
      message("Either your call can't be converted to a graph \nor there is no data at all matching your call.")
      message("Verify your call or try type = \"row\".")
    }

    # Do something only if there are nodes
    if (length(nodes) !=0){
      # Tbl
      nodes <- purrr::flatten(nodes)
      nodes_tbl <- unique(tibble(id = map_chr(nodes, ~ .x$id),
                                 label = map(nodes, ~ as.character(.x$labels)),
                                 properties = map(nodes, ~ .x$properties)))
    }

    # Do something only if there are relations
    if (length(relations) !=0){
      # Tbl
      relations <- purrr::flatten(relations)
      relations_tbl <- unique(tibble(id = as.character(map(relations, ~ .x$id)),
                                     type = as.character(map(relations, ~ .x$type)),
                                     startNode = as.character(map(relations, ~ .x$startNode)),
                                     endNode = as.character(map(relations, ~ .x$endNode)),
                                     properties = map(relations, ~ .x$properties)))
    }

    # Should we include stats?
    if (include_stats){
      res <- compact(list(nodes = nodes_tbl, relationships = relations_tbl, stats = stats))
      class(res) <- c("neo", class(res))

    } else {
      res <- compact(list(nodes = nodes_tbl, relationships = relations_tbl))
      if (length(res) != 0){
        class(res) <- c("neo", class(res))

      }
    }
    if (meta){
      return(c(res, res_meta))
    } else {
      return(res)
    }
  }


}

#' #' @importFrom dplyr as_tibble
#' #' @importFrom attempt attempt
#'
#' try_to_tibble <- function(vec){
#'   res <- attempt(as_tibble(vec), silent = TRUE)
#'   if (class(res)[1] == "try-error"){
#'     return(vec)
#'   } else {
#'     return(res)
#'   }
#' }
#' try_to_bind_rows <- function(vec){
#'   res <- attempt(bind_rows(vec), silent = TRUE)
#'   if (class(res)[1] == "try-error"){
#'     return(vec)
#'   } else {
#'     return(res)
#'   }
#' }
#'
#' #' @importFrom dplyr bind_cols
#' #' @importFrom attempt attempt
#'
#' try_to_bind_cols <- function(vec){
#'   res <- attempt(bind_cols(vec), silent = TRUE)
#'   if (class(res)[1] == "try-error"){
#'     return(vec)
#'   } else {
#'     return(res)
#'   }
#' }
#'
#' #' @importFrom tidyr unnest
#' #' @importFrom attempt attempt
#'
#' try_to_unnest <- function(vec){
#'   res <- attempt(unnest(vec), silent = TRUE)
#'   if (class(res)[1] == "try-error"){
#'     return(vec)
#'   } else {
#'     return(res)
#'   }
#' }
#'
#' #' @importFrom purrr transpose modify_depth discard map set_names
#' #' @importFrom attempt attempt
#'
#' gather_row_meta <- function(x, list_names){
#'   suppressWarnings(transpose(x)) %>%
#'     modify_depth(2, try_to_tibble) %>%
#'     modify_depth(1, ~ discard(.x, ~ length(.x) == 0)) %>%
#'     map(try_to_bind_cols) %>%
#'     set_names(list_names)
#' }
