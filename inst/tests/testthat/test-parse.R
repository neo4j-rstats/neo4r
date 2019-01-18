context("test-query")


test_that("queries graphs works", {
  graph <- "MATCH (r:Band) -[f:IS_FROM] -> (c:City {name:'Oslo'}) RETURN *;" %>%
    call_neo4j(con, type = "graph")
  expect_is(extract_nodes(graph), "tbl_df")
  expect_is(extract_nodes(graph), "tbl")
  expect_is(extract_nodes(graph), "data.frame")
  expect_is(extract_relationships(graph), "tbl_df")
  expect_is(extract_relationships(graph), "tbl")
  expect_is(extract_relationships(graph), "data.frame")

})

