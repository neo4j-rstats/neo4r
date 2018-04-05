context("test-connection.R")

library(neo4r)

test_that("connection work", {
library(httr)
con <- neo4j_api$new(url = "http://localhost:7474", user = "neo4j", password = "neo4j")
expect_null(con$get_version())
})


