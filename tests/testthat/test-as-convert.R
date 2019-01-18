context("test-as")

test_that("as works", {
  expect_equal(
    vec_to_cypher(iris[1, 1:3], "Species"),
    "(:`Species` {`Sepal.Length`: '5.1', `Sepal.Width`: '3.5', `Petal.Length`: '1.4'})"
    )
  expect_equal(
    vec_to_cypher_with_var(iris[1, 1:3], "Species", a),
    "(a:`Species` {`Sepal.Length`: '5.1', `Sepal.Width`: '3.5', `Petal.Length`: '1.4'})"
    )
})

test_that("convert_to works", {
  graph <- "MATCH (r:Band) -[f:IS_FROM] -> (c:City {name:'Oslo'}) RETURN *;" %>%
    call_neo4j(con, type = "graph")
  ig <- convert_to(graph, "igraph")
  expect_is(ig, "igraph")
  expect_length(ig, 10)
  vn <- convert_to(graph, "visNetwork")
  expect_is(vn, "list")
  expect_length(vn, 2)
  expect_named(vn, c("nodes", "relationships"))
  expect_equal(names(vn[[1]][1]), "id")
  expect_equal(names(vn[[2]][1]), "id")
  expect_equal(names(vn[[2]][2]), "type")
})


