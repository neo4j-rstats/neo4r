context("test-query")

test_that("constraints works", {
  cons <- con$get_constraints()
  expect_equal(nrow(cons), 5)
  expect_equal(ncol(cons), 3)
  expect_equal(names(cons), c("label", "type", "property_keys"))
})

test_that("queries rows works", {
  rows <- "MATCH (b:Band) WHERE b.formed = 1990 RETURN *;" %>%
    call_api(con)
  expect_is(rows, "list")
  rows <- rows[[1]]
  expect_is(rows, "tbl_df")
  expect_equal(nrow(rows), 1)
  expect_equal(ncol(rows), 2)
  expect_equal(rows$formed, 1990)
  expect_is(rows$formed, "integer")
  expect_equal(names(rows), c("name", "formed"))
  rows <- "MATCH (r:Band) -[:IS_FROM] -> (c:City {name:'Oslo'}) RETURN *;" %>%
    call_api(con)
  expect_is(rows, "list")
  expect_equal(names(rows), c("c", "r"))

  expect_is(rows, "tbl_df")
  expect_equal(nrow(rows), 13)
  expect_equal(ncol(rows), 2)
  expect_is(rows$formed, "integer")
  expect_equal(names(rows), c("name", "formed"))
})

test_that("queries graphs works", {
  graph <- "MATCH (r:Band) -[f:IS_FROM] -> (c:City {name:'Oslo'}) RETURN *;" %>%
    call_api(con, type = "graph")
  expect_is(graph, "list")
  expect_length(graph, 2)
  expect_equal(nrow(graph$nodes), 4)
  expect_equal(ncol(graph$nodes), 3)
  expect_equal(names(graph[[1]]), c("id", "label", "properties"))
  expect_equal(names(graph[[2]]), c("id", "type", "startNode", "endNode", "properties"))
})
