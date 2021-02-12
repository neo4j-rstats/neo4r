#' A Neo4J Connexion
#'
#' @section Methods:
#' \describe{
#' \item{\code{access}}{list url, user, password, db,and is_V4}
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
#' \item{\code{url}}{list url, user, password, db and is_V4}
#' \item{\code{user}}{test your connexion}
#' }
#'
#' @return A Neo4J Connexion
#'
#' @importFrom attempt attempt
#' @importFrom R6 R6Class
#' @importFrom httr GET status_code add_headers content http_error
#' @importFrom purrr map as_vector
#' @importFrom tibble as_tibble tibble
#' @importFrom data.table rbindlist
#' @importFrom tidyr unnest
#' @importFrom jsonlite base64_enc
#' @export
#'
#' @examples
#' \dontrun{
#' connect <- neo4j_api$new(url = "http://localhost:7474"", user = "neo4j", password = "password" , db = "neo4j, is_V4 = TRUE)
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
    status_4x = 0,
    status_3x = 0,
    last_error = list(),
    version = character(0),
    edition = character(0),
    transaction = character(0),
    bolt_routing = character(0),
    bolt_direct = character(0),
    ping_query = 'call db.ping()',
    exceptions_4x = list("4.0.0", "4.0.1", "4.0.2", "4.0.3"),
    databases = tibble(0),
    endpointUp = list(),
    alt_ping_query = 'with true as success return success',
    is_V4 = TRUE,
    #Print Function
    print = function() {
      cat("<neo4j connection object>\n")
      #res<-self$ping()
      if (self$ping() == TRUE ) {
        cat("Connected at", self$url, "\n")
        cat("User:", self$user, "\n")
        cat("Neo4j version:", self$version, "\n")
        cat("Neo4j eddition:", self$edition, "\n")
      } else {
        cat("No registered Connection\n")
        cat("(Wrong credentials or hostname)\n")
      }
    },
    initialize = function(url,  user, password,db="neo4j", is_V4 = TRUE) {
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
      self$endpointUp <-self$endpoint_up()
      if (self$endpointUp$status == TRUE) {
        #if url is not reachable - nothing else is going to work
        self$get_info()
        }
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
      #browser()
      self$endpointUp<-self$endpoint_up()
      if (self$endpointUp$status == TRUE) {
      res<-self$ping_query %>% call_neo4j(self, type='row')
      if (length(res$error_code)>0) return(FALSE)
      return(res$success$value)
      }
      return(self$endpointUp$status)
    },
    endpoint_up = function(){
      #browser()
      result = tryCatch({
        aResult <- http_error(self$url)
        if (aResult == FALSE){
          alist <- list(status=TRUE, msg=paste("Server Up:",self$url ) )
        } else {alist <- list(status=FALSE, msg=paste("Server Down:",self$url))}
        return(alist)
        },
        error = function(e) {
          alist <- list( status=FALSE, msg=paste("Server Down:",self$url), error=e)
          return (alist)
        })
    },
    # Get Neo4J version
    get_version = function() {
      #hitting the base url should reply back with some version info
      #browser()
      if (self$endpoint_up()$status == TRUE ) {

        res4x <- get_wrapper(self, "")
        self$status_4x <- status_code(res4x)

        res3x <- get_wrapper(self,"db/data")
        self$status_3x <- status_code(res3x)

        if ((self$status_4x == 200) && (self$status_3x != 200)) {
          self$version <- content(res4x)$neo4j_version
          if (grepl('4[.][0-999][.][0-999].*',self$version)   ){
            self$is_V4 <- TRUE
            print('Found Neo4j 4.x')}
          if (self$version %in% self$exceptions_4x)
          {self$ping_query <- self$alt_ping_query}
          self$edition <- content(res4x)$neo4j_edition
          return(TRUE)
        }
        else { #probably neo4j 3.x
          if (self$status_3x == 200){
            self$version = content(res3x)$neo4j_version
            if  (grepl('3[.][0-999][.][0-999].*',self$version)  )  {
              self$is_V4 = FALSE
              self$ping_query <- self$alt_ping_query
              self$edition <- content(res4x)$neo4j_edition
              print('Found Neo4j 3.x')
              return(TRUE)
            }
            else {
              self$is_V4 = FALSE
              self$ping_query <- self$alt_ping_query
              print(glue('Found Neo4j ',self$version))
              return(TRUE)
            }
          }
          else {
            self$is_V4 = FALSE
            self$ping_query <- self$alt_ping_query
            print(glue('Found:',self$version))
            return(FALSE)
          }
        }
      }
      return(FALSE)
    },
    get_info = function() {
      #hitting the base url should reply back with some version info
      #browser()
      if (self$get_version()){
        if (self$is_V4){
          savedb <- self$db
          self$db <- "system" # switch to system to get list of database and status
          self$databases <- 'show databases' %>% call_neo4j(self,type="row")
          self$db <- savedb
          #TODO - make some sense of the database tibble
        }
      }
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
      if (self$is_V4) {
        query <- glue('call db.indexes() ',
              'yield id,name,state,populationPercent, uniqueness,type,entityType,labelsOrTypes,properties,provider ',
              ' unwind labelsOrTypes as label ',
              'with id,name,state,populationPercent, uniqueness, type, entityType, provider,label,properties ',
              'unwind properties as property ',
              'return id,name,state,populationPercent, uniqueness, type, entityType, label, property, provider'
              )
      } else {
        query <- glue(
          'call db.indexes() ',
          'yield description,indexName,tokenNames,properties,state,type,progress,provider,id,failureMessage ',
          'unwind tokenNames as tokenName ',
          'with description,indexName,tokenName,properties,state,type,progress,provider,id,failureMessage ',
          'unwind properties as property ',
          'return description,indexName,tokenName,property,state,type,progress,provider,id,failureMessage ',
          )
      }
      res<-query %>% call_neo4j(self, type='row')
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
  #browser()
  #result = tryCatch({
  GET(
    glue("{self$url}/{url}"),
    add_headers(.headers = c(
      "Content-Type" = "application/json",
      "accept" = "application/json",
      "Authorization" = paste0("Basic ", self$auth)
    ))
  )
  #)},
  #warning = function(w) {
  #  print(paste('Warning: ',w))
  #},
  #error = function(e) {
  #  print(paste('Error - Assume Connection Failed:',e))
  #  alist <- list( url= glue("{self$url}/{url}"), status_code = -1, error =  paste('Error - Assume Connection Failed:',e))
  #  return (alist)
  #})
  #return(result)
}
