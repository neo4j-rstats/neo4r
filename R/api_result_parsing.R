#' @importFrom httr content
#' @importFrom attempt stop_if
#' @importFrom purrr flatten transpose modify_depth map map_df as_vector map_chr  compact flatten_dfr vec_depth
#' @importFrom tidyr gather
#' @importFrom stats setNames
#' @importFrom tibble tibble

parse_api_results <- function(res, type, include_stats, meta, format) {

  # Get the content as an R list
  api_content <- content(res)

  # Test if there are errors
  if (length(api_content$errors) > 0) {
    # Return the errors if there are any (code + message)
    return(list(
      error_code = api_content$errors[[1]]$code,
      error_message = api_content$errors[[1]]$message
    ))
  }
  # Get the result element
  results <- api_content$results[[1]]

  # turn the null to NA
  results <- modify_depth(
    results, vec_depth(results) - 1, function(x){
      if (is.null(x)){
        NA
      } else {
        x
      }
    }, .ragged = TRUE
  )

  # Get the stats (if any)
  if (!is.null(results$stats)) {
    stats <- tibble(
      type = names(results$stats),
      value = as.numeric(results$stats)
    )
  } else {
    stats <- NULL
  }

  if (length(results$data) == 0) {
    message("No data returned.")
    if (include_stats) {
      return(stats)
    }
  }

  # Get the name of the columns
  res_names <- results$columns
  # Get the data
  res_data <- results$data

  if (meta) {
    res_meta <- map(res_data, "meta") %>%
      map(flatten_dfr) %>%
      setNames(paste(res_names, "meta", sep = "_"))
  }

  res_data <- map(res_data, function(x) {
    x$meta <- NULL
    x
  })

  if (type == "row") {
    # Type = row
    # Special case for handling arrays
    # browser()
    res <- attempt::attempt({
      purrr::map_depth(res_data, 3, tibble::as_tibble) %>%
        purrr::map(purrr::flatten) %>%
        purrr::transpose() %>%
        purrr::map(rbindlist_to_tibble)
    }, silent = TRUE)
    if (class(res)[1] == "try-error") {
      res <- flatten(res_data) %>%
        purrr::map_dfr(purrr::flatten_dfc) %>%
        list()
    }
    if (length(res_data) != 0){
      res <- res %>%
        setNames(res_names)
    }

    if (include_stats) {
      res <- c(res, list(stats = stats))
    } else {
      class(res) <- c("neo", class(res))
    }

    if (meta) {
      res <- c(res, res_meta)
    }
    class(res) <- c("neo", class(res))
    return(res)

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
    if (length(nodes) == 0 & length(relations) == 0) {
      message("No graph data found.")
      message("Either your call can't be converted to a graph \nor there is no data at all matching your call.")
      message("Verify your call or try type = \"row\".")
    }

    # Do something only if there are nodes
    if (length(nodes) != 0) {
      # Tbl
      nodes <- purrr::flatten(nodes)
      nodes_tbl <- unique(tibble(
        id = map_chr(nodes, ~.x$id),
        label = map(nodes, ~as.character(.x$labels)),
        properties = map(nodes, ~.x$properties)
      ))
    }

    # Do something only if there are relations
    if (length(relations) != 0) {
      # Tbl
      relations <- flatten(relations)
      relations_tbl <- unique(tibble(
        id = as.character(map(relations, ~.x$id)),
        type = as.character(map(relations, ~.x$type)),
        startNode = as.character(map(relations, ~.x$startNode)),
        endNode = as.character(map(relations, ~.x$endNode)),
        properties = map(relations, ~.x$properties)
      ))
    }

    # Should we include stats?
    if (include_stats) {
      res <- compact(list(nodes = nodes_tbl, relationships = relations_tbl, stats = stats))
      class(res) <- c("neo", class(res))
    } else {
      res <- compact(list(nodes = nodes_tbl, relationships = relations_tbl))
      if (length(res) != 0) {
        class(res) <- c("neo", class(res))
      }
    }
    res
  }
}


rbindlist_to_tibble <- function(l){
  tibble::as_tibble(data.table::rbindlist(l))
}

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

#' try_to_bind_cols <- function(vec){
#'   res <- attempt(bind_cols(vec), silent = TRUE)
#'   if (class(res)[1] == "try-error"){
#'     return(vec)
#'   } else {
#'     return(res)
#'   }
#' }
#'
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
#'
#' gather_row_meta <- function(x, list_names){
#'   suppressWarnings(transpose(x)) %>%
#'     modify_depth(2, try_to_tibble) %>%
#'     modify_depth(1, ~ discard(.x, ~ length(.x) == 0)) %>%
#'     map(try_to_bind_cols) %>%
#'     set_names(list_names)
#' }
