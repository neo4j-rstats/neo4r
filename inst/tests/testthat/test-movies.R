context("test-movies")

graph <- readRDS("movies_graph.RDS")

test_that("unnesting works", {
  res <- unnest_graph(graph)
  expect_is(res, "list")
  expect_is(res$nodes, "tbl_df")
  expect_is(res$nodes, "tbl")
  expect_is(res$nodes, "data.frame")
  expect_is(res$relationships, "tbl_df")
  expect_is(res$relationships, "tbl")
  expect_is(res$relationships, "data.frame")
  n <- unnest_nodes(graph$nodes)
  expect_is(n, "tbl_df")
  expect_is(n, "tbl")
  expect_is(n, "data.frame")
  r <- unnest_relationships(graph$relationships)
  expect_is(r, "tbl_df")
  expect_is(r, "tbl")
  expect_is(r, "data.frame")

})
