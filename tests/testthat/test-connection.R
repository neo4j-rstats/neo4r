context("test-connection.R")

library(httr)


test_that("connection work (on new install only)", {
con <- neo4j_api$new(url = "http://localhost:7474",
                     user = "neo4j", password = "neo4j")
expect_is(con$get_version(), "character")
})


