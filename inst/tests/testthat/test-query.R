context("test-query")

test_that("constraints works", {
  cons <- con$get_constraints()
  expect_equal(nrow(cons), 4)
  expect_equal(ncol(cons), 3)
  expect_equal(names(cons), c("label", "type", "property_keys"))
})

test_that("queries rows works", {
  rows <- "MATCH (b:Band) WHERE b.formed = 1990 RETURN *;" %>%
    call_neo4j(con)
  expect_is(rows, "list")
  rows <- rows[[1]]
  expect_equal(nrow(rows), 1)
  expect_equal(ncol(rows), 2)
  expect_equal(rows$formed, 1990)
  expect_is(rows$formed, "integer")
  expect_equal(names(rows), c("name", "formed"))
  rows <- "MATCH (b:Band) WHERE b.formed < 1995 RETURN *;" %>%
    call_neo4j(con)
  expect_is(rows, "list")
  rows <- rows[[1]]
  expect_equal(nrow(rows), 1)
  expect_equal(ncol(rows), 2)
  expect_is(rows$formed, "integer")
  expect_equal(names(rows), c("name", "formed"))
})

test_that("queries graphs works", {
  graph <- "MATCH (r:Band) -[f:IS_FROM] -> (c:City {name:'Oslo'}) RETURN *;" %>%
    call_neo4j(con, type = "graph")
  expect_is(graph, "list")
  expect_length(graph, 2)
  expect_equal(nrow(graph$nodes), 4)
  expect_equal(ncol(graph$nodes), 3)
  expect_equal(names(graph[[1]]), c("id", "label", "properties"))
  expect_equal(names(graph[[2]]), c("id", "type", "startNode", "endNode", "properties"))
})

test_that("meta and stats works", {
  graph <- "MATCH (r:Band) -[f:IS_FROM] -> (c:City {name:'Oslo'}) RETURN *;" %>%
    call_neo4j(con, type = "graph", include_stats = TRUE)
  expect_is(graph, "neo")
  expect_is(graph, "list")
  expect_length(graph, 3)
  expect_equal(nrow(graph$stats), 12)
  expect_equal(ncol(graph$stats), 2)
  expect_equal(names(graph$stats), c("type", "value"))

  graph <- "MATCH (r:Band) -[f:IS_FROM] -> (c:City {name:'Oslo'}) RETURN *;" %>%
    call_neo4j(con, include_meta = TRUE)
  expect_is(graph, "neo")
  expect_is(graph, "list")
  expect_length(graph, 6)
  expect_equal(names(graph), c("c", "f", "r", "c_meta", "f_meta", "r_meta"))


})
