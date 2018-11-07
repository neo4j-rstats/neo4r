#' A Neo4J Connexion
#'
#' @section Methods:
#' \describe{ \item{\code{access}}{list url, user and
#'   password} \item{\code{ping}}{test your connexion}
#'   \item{\code{version}}{Neo4J version} \item{\code{get}}{Get a list of either
#'   relationship, labels, } }
#'
#' @return A Neo4J Connexion
#'
#' @importFrom R6 R6Class
#' @importFrom httr GET status_code add_headers content
#' @importFrom purrr map as_vector
#' @importFrom dplyr as_tibble bind_rows tibble
#' @importFrom tidyr unnest
#' @importFrom jsonlite base64_enc
#' @export
#'
#' @examples
#'\dontrun{
#'con <- neo4j_api$new(url = "http://localhost:7474", user = "neo4j", password = "password")
#'}
#'
#'
neo4j_api <- R6::R6Class("Neo4JAPI",
                         public = list(
                           url = character(0),
                           user = character(0),
                           password = character(0),
                           auth = character(0),
                           relationships = data.frame(0),
                           labels = data.frame(0),
                           initialize = function(url, user, password){
                             #browser()
                             # Clean url in case it ends with a /
                             url <- gsub("(.*)/$", "\\1", url)
                             self$url <- url
                             self$user <- user
                             self$password <- password
                             self$auth <- base64_enc(paste0(user,':',password))
                           },
                           reset_url = function(url){
                             self$url <- url
                           },
                           reset_user = function(user){
                             self$user <- user
                             self$auth <- base64_enc(paste0(user,':',self$password))
                           },
                           reset_password = function(password){
                             self$password <- password
                             self$auth <- base64_enc(paste0(self$user,':',password))
                           },
                           # List elements
                           access = function(){
                             list(url = self$url,
                                  user = self$user,
                                  password = self$password)
                           },
                           # Test if the endpoint is accessible
                           # This only return the status code for now so I wonder
                           # if we should make if verbose instead of just returning SC
                           ping = function(){
                             #browser()
                             attempt(status_code(get_wrapper(self, "db/data/relationship/types")))
                           },
                           # Get Neo4J version
                           get_version = function(){
                             res <- get_wrapper(self, "db/data")
                             content(res)$neo4j_version
                           },
                           # Get a list of relationship registered in the db
                           # return it as a data.frame because data.frame are cool
                           get_relationships = function(){
                             res <- get_wrapper(self, "db/data/relationship/types")
                             tibble(labels = as.character(content(res)))
                           },
                           # Get a list of labels registered in the db
                           # Tibbles are awesome
                           get_labels = function(){
                             res <- get_wrapper(self, "db/data/labels")
                             tibble(labels = as.character(content(res)))
                           },
                           get_property_keys = function(){
                             res <- get_wrapper(self, "db/data/propertykeys")
                             tibble(labels = as.character(content(res)))
                           },
                           # Get the schema of the db
                           # There must be a better way to parse this
                           get_schema = function(){
                             res <- get_wrapper(self, "db/data/schema/index")
                             map(content(res), as_tibble) %>% map(unnest) %>% bind_rows()
                           },
                           # Get a list of constraints registered in the db
                           # Same here
                           get_constraints = function(){
                             res <- get_wrapper(self, "db/data/schema/constraint")
                             map(content(res), as_tibble) %>% map(unnest) %>% bind_rows()
                           }

                         )
)

# "If you need to copy and paste something more than twice, write a function"

get_wrapper <- function(self, url){
  #browser()
  GET(glue("{self$url}/{url}"),
      add_headers(.headers = c("Content-Type"="application/json",
                               "accept"="application/json",
                               "Authorization"= paste0("Basic ", self$auth))
                  ))
}

#con <- neo4r::neo4j_api$new(url = "http://localhost:7473/", user = "neo4j", password = "pouetpouet")
#con$ping()
# con$url
# con$get_constraints()
# con$get_labels()
# con$get_relationships()
# con$get_schema()

