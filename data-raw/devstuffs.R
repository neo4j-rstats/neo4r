library(usethis)
library(desc)
library(httr)
library(jsonlite)
library(attempt)
library(glue)
library(purrr)
library(dplyr)
library(tidyr)
library(shiny)

# Remove default DESC
unlink("DESCRIPTION")
# Create and clean desc
my_desc <- description$new("!new")

# Set your package name
my_desc$set("Package", "neo4r")

#Set your name
my_desc$set("Authors@R", "person('Colin', 'Fay', email = 'colin@thinkr.fr', role = c('cre', 'aut'))")

# Remove some author fields
my_desc$del("Maintainer")

# Set the version
my_desc$set_version("0.0.0.9000")

# The title of your package
my_desc$set(Title = "A Modern and Flexible Neo4J Driver")
# The description of your package
my_desc$set(Description = "A Modern and Flexible Neo4J Driver.")

# The urls
my_desc$set("URL", "https://github.com/neo4j-rstats/neo4r")
my_desc$set("BugReports", "https://github.com/neo4j-rstats/neo4r/issues")
# Save everyting
my_desc$write(file = "DESCRIPTION")

# If you want to use the MIT licence, code of conduct, and lifecycle badge
use_mit_license(name = "ThinkR")
use_readme_rmd()
use_code_of_conduct()
use_lifecycle_badge("Experimental")
use_news_md()


# Test that
use_testthat()
use_test("")

# Get the dependencies
use_package("attempt")
use_package("glue")
use_package("httr")
use_package("jsonlite")
use_package("dplyr")
use_package("purrr")
use_package("tidyr")
use_package("igraph")
use_package("R6")
use_package("shiny")
use_package("rstudioapi")
use_package("utils")
use_tidy_description()
