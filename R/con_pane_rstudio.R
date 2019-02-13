# Utils#
#' @importFrom httr GET
get_wrapper_for_connect <- function(base, url, auth) {
  GET(
    glue("{base}/{url}"),
    add_headers(.headers = c(
      "Content-Type" = "application/json",
      "accept" = "application/json",
      "Authorization" = paste0("Basic ", auth)
    ))
  )
}

# Closing connection

close_connection <- function() {
  on_connection_closed()
  print("Connection closed")
}

on_connection_closed <- function() {
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionClosed(type = "Neo4J",
                              host = "neo4jhost")
  }
}

# For connection open

list_objects <- function(includeType) {
  tables <- c(
    "Node Labels", "Relationship Types", "Constraints",
    "Property Keys"
  )
  if (includeType) {
    data.frame(
      name = tables,
      type = rep_len("table", length(tables)),
      stringsAsFactors = FALSE
    )
  } else {
    tables
  }
}

#' @importFrom tibble tibble

tibble_res <- function(label, type) {
  tibble(
    name = label,
    type = type
  )
}

#' @importFrom tibble tibble

list_columns <- function(table, url, auth) {
  if (table == "Node Labels") {
    res <- get_wrapper_for_connect(url, "db/data/labels", auth)
    res <- tibble(labels = as.character(content(res)))
    if (nrow(res) != 0) {
      res <- tibble_res(res$labels, "node label")
    }
  } else if (table == "Relationship Types") {
    res <- get_wrapper_for_connect(url, "db/data/relationship/types", auth)
    res <- tibble(labels = as.character(content(res)))
    if (nrow(res) != 0) {
      res <- tibble(
        name = res$labels,
        type = rep_len("relationship type", length(res)),
        stringsAsFactors = FALSE
      )
    }
  } else if (table == "Constraints") {
    res <- get_wrapper_for_connect(url, "db/data/schema/constraints", auth)
    res <- tibble(labels = as.character(content(res)))
    if (nrow(res) != 0) {
      res <- data.frame(
        name = res$labels,
        type = rep_len("constraint", length(res)),
        stringsAsFactors = FALSE
      )
    }
  } else if (table == "Property Keys") {
    res <- get_wrapper_for_connect(url, "db/data/propertykeys", auth)
    res <- tibble(labels = as.character(content(res)))
    if (nrow(res) != 0) {
      res <- data.frame(
        name = res$labels,
        type = rep_len("property key", length(res)),
        stringsAsFactors = FALSE
      )
    }
  }
  res
}

#' @importFrom tibble tibble
#' @importFrom utils head
#' @importFrom httr content
preview_object <- function(table, limit, url, auth) {
  if (table == "nodes") {
    res <- get_wrapper_for_connect(url, "db/data/labels", auth)
    res <- tibble(labels = as.character(content(res)))
  } else if (table == "relationship") {
    res <- get_wrapper_for_connect(url, "db/data/relationship/types", auth)
    res <- tibble(labels = as.character(content(res)))
  } else if (table == "constraints") {
    res <- get_wrapper_for_connect(url, "db/data/schema/constraints", auth)
    res <- tibble(labels = as.character(content(res)))
  } else if (table == "property keys") {
    res <- get_wrapper_for_connect(url, "db/data/propertykeys", auth)
    res <- tibble(labels = as.character(content(res)))
  }
  head(res, limit)
}

#' @importFrom utils browseURL

neo4j_actions <- function(url) {
  list(
    browser = list(
      icon = system.file("icons", "browserlogo.png", package = "neo4r"),
      callback = function() {
        browseURL(url)
      }
    ),
    help = list(
      icon = system.file("icons", "github.png", package = "neo4r"),
      callback = function() {
        browseURL("https://github.com/neo4j-rstats/neo4r")
      }
    )
  )
}

list_objects_types <- function() {
  return(
    list(
      table = list(contains = "data")
    )
  )
}

#' Opening the Neo4J connection Pane
#'
#' For intenral use
#'
#' @param con A connection object
#' @param url The url of the database
#' @param auth The auth token
#'
#' @keywords internal
#' @export

on_connection_opened <- function(con, url, auth) {
  # browser()
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionOpened(
      type = "Neo4J",
      host = "neo4jhost",
      displayName = "Neo4J server",
      icon = system.file("icons", "neologo.png", package = "neo4r"),
      connectCode = '# Connect to Neo4J \nlibrary(neo4r)\ncon <- neo4j_api$new(url = "http://localhost:7474/", user = "neo4j", password = "neo4j")\nlaunch_con_pane(con)',
      disconnect = function() {
        close_connection()
      },
      listObjectTypes = function() {
        list_objects_types()
      },
      listObjects = function(type = "table") {
        list_objects(includeType = TRUE)
      },
      listColumns = function(table) {
        list_columns(table, url = con$url, auth = con$auth)
      },
      previewObject = function(rowLimit, table) {
        preview_object(table, rowLimit, url = con$url, auth = con$auth)
      },
      actions = neo4j_actions(url),
      connectionObject = con
    )
  }
}

# Shiny APP
#' @importFrom rstudioapi updateDialog
update_dialog <- function(code) {
  rstudioapi::updateDialog(code = code)
}

#' @importFrom shiny tags div textInput

ui <- function() {
  tags$div(
    div(
      style = "table-row",
      textInput(
        "url",
        "URL (with port):"
      ),
      textInput(
        "user",
        "User:"
      ),
      textInput(
        "password",
        "Password:"
      )
    )
  )
}

#' @importFrom glue glue

build_code <- function(url, user, password) {
  paste(
    "# Connect to Neo4J\n",
    "library(neo4r)\n",
    glue("con <- neo4j_api$new(url = '{url}', user = '{user}', password = '{password}')"),
    "\ncon$ping()",
    "\nlaunch_con_pane(con)"
  )
}

#' @importFrom shiny observe

server <- function(input, output, session) {
  observe({
    update_dialog(build_code(input$url, input$user, input$password))
  })
}

#' Run the connection app
#'
#' For internal use
#'
#' @keywords internal
#' @importFrom shiny shinyApp
#' @export

run_app <- function() {
  shinyApp(ui, server)
}

#' Launch Neo4J Connection Pane
#'
#' @param con a connection object
#'
#' @importFrom attempt stop_if_not
#'
#' @return an opened Connection Pane
#' @export
#'

launch_con_pane <- function(con) {
  stop_if_not(con$ping(), ~.x == 200, "Couldn't connect to the Server")
  on_connection_opened(con = con, url = con$url, auth = con$auth)
}
# launch_con_pane(con)
