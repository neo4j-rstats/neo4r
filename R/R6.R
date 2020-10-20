#' A Neo4J Connexion
#'
#' @section Methods:
#' \describe{
#' \item{\code{access}}{list url, user and password}
#' \item{\code{ping}}{test your connexion}
#' \item{\code{version}}{Neo4J version}
#' \item{\code{get}}{Get a list of either relationship, labels, }
#' \item{\code{get}}{Get a list of either relationship, labels, }
#' \item{\code{get}}{Get a list of either relationship, labels, }
#' \item{\code{get}}{Get a list of either relationship, labels, }
#' \item{\code{get}}{Get a list of either relationship, labels, }
#' }
#' @section Data:
#' \describe{
#' \item{\code{url}}{list url, user and password}
#' \item{\code{user}}{test your connexion}
#' }
#'
#' @return A Neo4J Connexion
#'
#' @importFrom attempt attempt
#' @importFrom R6 R6Class
#' @importFrom httr GET status_code add_headers content
#' @importFrom purrr map map_dfr as_vector
#' @importFrom tibble as_tibble tibble
#' @importFrom data.table rbindlist
#' @importFrom tidyr unnest
#' @importFrom jsonlite base64_enc
#' @export
#'
#' @examples
#' \dontrun{
#' con <- neo4j_api$new(url = "http://localhost:7474", user = "neo4j", password = "password")
#' }
#'
#'
neo4j_api <- R6::R6Class(
  "Neo4JAPI",
  private = list(
    password = character(0)
  ),
  public = list(
    url = character(0),
    user = character(0),
    relationships = data.frame(0),
    auth = character(0),
    labels = data.frame(0),
    print = function() {
      cat("<neo4j connection object>\n")
      if (self$ping() == 200) {
        cat("Connected at", self$url, "\n")
        cat("User:", self$user, "\n")
        cat("Neo4j version:", self$get_version(), "\n")
      } else {
        cat("No registered Connection\n")
        cat("(Wrong credentials or hostname)\n")
      }
    },
    initialize = function(url, user, password) {
      # browser()
      # Clean url in case it ends with a /
      if (grepl("bolt", url)) {
        message("We've detected the pattern `bolt` in your url.")
        message("{neo4r} doesn't provide support for bolt")
        message("in the current version.")
        x <- readline("Do you wish to proceed anyway? [Y/n] ")
        if (x != "Y") {
          stop("Stopped")
        }
      }
      url <- gsub("(.*)/$", "\\1", url)
      self$url <- url
      self$user <- user
      private$password <- password
      self$auth <- base64_enc(paste0(user, ":", password))
    },
    reset_url = function(url) {
      self$url <- url
    },
    reset_user = function(user) {
      self$user <- user
      self$auth <- base64_enc(paste0(self$user, ":", private$password))
    },
    reset_password = function(password) {
      private$password <- password
      self$auth <- base64_enc(paste0(self$user, ":", private$password))
    },
    # List elements
    access = function() {
      list(
        url = self$url,
        user = self$user
      )
    },
    # Test if the endpoint is accessible
    # This only return the status code for now so I wonder
    # if we should make if verbose instead of just returning SC
    ping = function() {
      # browser()
      attempt(status_code(GET(self$url)))
    },
    # Get Neo4J version
    get_version = function() {
      # get the root endpoint for the connection
      res <- GET(self$url)
      root <- content(res)

      # determine if root endpoint content indicates v3.x or v4.x of Neo4j
      # there may be better ways to discover the version, but this works for now
      if ("neo4j_version" %in% names(root)) {
        version <- root$neo4j_version # this is version 4.x
      }
      else {
        res <- get_wrapper(self, "db/data")
        version <- content(res)$neo4j_version # this is version 3.x
      }
      version
    },
    # Get a list of relationship registered in the db
    # return it as a data.frame because data.frame are cool
    get_relationships = function() {
      if (self$major_version < 4) {
        res <- get_wrapper(self, "db/data/relationship/types")
        typs <- tibble(labels = as.character(content(res)))
      } else {
        typs <- 'CALL db.relationshipTypes' %>%
          call_neo4j(self) %>%
          map(unlist) %>%
          as_tibble()
      }
      typs
    },
    # Get a list of labels registered in the db
    # Tibbles are awesome
    get_labels = function() {
      if (self$major_version < 4) {
        res <- get_wrapper(self, "db/data/labels")
        labs <- tibble(labels = as.character(content(res)))
      } else {
        labs <- 'CALL db.labels' %>%
          call_neo4j(self) %>%
          map(unlist) %>%
          as_tibble()
      }
      labs
    },
    get_property_keys = function() {
      if (self$major_version < 4) {
        res <- get_wrapper(self, "db/data/propertykeys")
        props <- tibble(labels = as.character(content(res)))
      } else {
        props <- 'CALL db.propertyKeys' %>%
          call_neo4j(self) %>%
          map(unlist) %>%
          as_tibble()
      }
      props
    },
    # Get the schema of the db
    # There must be a better way to parse this
    get_index = function() {
      if (self$major_version < 4) {
        res <- get_wrapper(self, "db/data/schema/index")
        idx <- map_dfr(content(res), as_tibble) %>% unnest(c(property_keys, labels))
      } else {
        idx <- glue("CALL db.indexes() yield id, name, state, populationPercent, uniqueness, type, entityType, labelsOrTypes, properties, provider ",
                    "UNWIND labelsOrTypes as label ",
                    "UNWIND properties as property ",
                    "RETURN id, name, state, populationPercent, uniqueness, type, entityType, label, property, provider") %>%
          call_neo4j(con4) %>%
          map(unlist) %>%
          as_tibble()
      }
      idx
    },
    # Get a list of constraints registered in the db
    # Same here
    get_constraints = function() {
      if (self$major_version < 4) {
        res <- get_wrapper(self, "db/data/schema/constraint")
        cons <- map_dfr(content(res), as_tibble) %>% unnest(c(property_keys, type))
      } else {
        cons <- "CALL db.constraints" %>%
          call_neo4j(self) %>%
          map(unlist) %>%
          as_tibble()
      }
      cons
    }
  ),
  active = list(
    # get the major version of Neo4j as a number
    # save converting this later from the get_version() string
    major_version = function() {
      self$get_version() %>%
        substr(1,1) %>%
        as.integer()
    }
  )
)

# "If you need to copy and paste something more than twice, write a function"

get_wrapper <- function(self, url) {
  # browser()
  GET(
    glue("{self$url}/{url}"),
    add_headers(.headers = c(
      "Content-Type" = "application/json",
      "accept" = "application/json",
      "Authorization" = paste0("Basic ", self$auth)
    ))
  )
}
