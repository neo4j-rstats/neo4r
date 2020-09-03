#' A Neo4J Connexion
#'
#' @section Methods:
#' \describe{
#' \item{\code{access}}{list url,db, user, password, and isV4}
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
#' \item{\code{url}}{list url, user, password, and isV4}
#' \item{\code{user}}{test your connexion}
#' }
#'
#' @return A Neo4J Connexion
#'
#' @importFrom attempt attempt
#' @importFrom R6 R6Class
#' @importFrom httr GET status_code add_headers content
#' @importFrom purrr map as_vector
#' @importFrom tibble as_tibble tibble
#' @importFrom data.table rbindlist
#' @importFrom tidyr unnest
#' @importFrom jsonlite base64_enc
#' @export
#'
#' @examples
#' \dontrun{
#' connect <- neo4j_api$new(url = "http://localhost:7474", db = "neo4j", user = "neo4j", password = "password", isV4 = TRUE)
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
    db = character(0),
    relationships = data.frame(0),
    auth = character(0),
    labels = data.frame(0),
    isV4 = TRUE,
    #Print Function
    print = function() {
      cat("<neo4j connection object>\n")
      res<-self$ping()
      if (res$success == TRUE ) {
        cat("Connected at", self$url, "\n")
        cat("User:", self$user, "\n")
        cat("Neo4j version:", self$get_version(), "\n")
      } else {
        cat("No registered Connection\n")
        cat("(Wrong credentials or hostname)\n")
      }
    },
    initialize = function(url, db, user, password, isV4) {
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
      self$db <- db
      private$password <- password
      self$auth <- base64_enc(paste0(user, ":", password))
      self$isV4 <- isV4
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
    # In 4.0 the endpoints have changed.  Instead we will call
    # the appropriate cypher or function
    #
    # Test if the endpoint is accessible
    # This only return the status code for now so I wonder
    # if we should make if verbose instead of just returning SC
    ping = function() {
      # browser()
      res<-'call db.ping()' %>% call_neo4j(self, type='row')
      #attempt(status_code(get_wrapper(self, "db/data/relationship/types")))
    },
    # Get Neo4J version
    get_version = function() {
      #hitting the base url should reply back with some version info
      if (self$isV4 == TRUE ) {
        turl <- ""
      } else {
        turl <- "db/data"
      }
      res <- get_wrapper(self, turl)
      content(res)$neo4j_version
    },
    # Get Neo4J cluster status
    #cluster_status = function() {
      #cluster doesn't work hmmm
     # res <- get_wrapper(self, glue('db/{self$db}/cluster/status'))
    #},
    # Get a list of relationship registered in the db
    # return it as a data.frame because data.frame are cool
    get_relationships = function() {
      res<-'call db.relationshipTypes()' %>% call_neo4j(self, type='row')
    },
    # Get a list of labels registered in the db
    # Tibbles are awesome
    get_labels = function() {
      # call db.labels()
      res<-'call db.labels()' %>% call_neo4j(self, type='row')
    },
    get_property_keys = function() {
      #Make CYPHER CALL
      res<-'call db.propertyKeys()' %>% call_neo4j(self, type='row')
    },
    # Get the schema of the db
    # There must be a better way to parse this
    get_index = function() {
      res<-'call db.indexes() yield id,name,state,populationPercent, uniqueness,type,entityType,labelsOrTypes,properties,provider with id,name,state,populationPercent, uniqueness,type,entityType,labelsOrTypes,properties,provider unwind labelsOrTypes as label with id,name,state,populationPercent, uniqueness, type, entityType, provider,label,properties unwind properties as property return id,name,state,populationPercent, uniqueness, type, entityType, label, property, provider' %>% call_neo4j(self, type='row')
    },
    # Get a list of constraints registered in the db
    # Same here
    get_constraints = function() {
      res<-'call db.constraints()' %>% call_neo4j(self, type='row')
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
