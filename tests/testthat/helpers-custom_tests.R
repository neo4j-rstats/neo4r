req_and_expect <- function(
                           req, con, is, length, names) {
  req <- call_neo4j(req, con)
  expect_is(req, is)
  expect_length(req, length)
  expect_named(req, names)
}

req_and_expect_graph <- function(
                                 req, con) {
  req <- call_neo4j(req, con, type = "graph")
  expect_is(req, "neo")
  expect_is(req, "list")
  expect_length(req, 2)
  expect_named(req, c("nodes", "relationships"))
  expect_is(req$nodes, "data.frame")
  expect_is(req$relationships, "data.frame")
}

