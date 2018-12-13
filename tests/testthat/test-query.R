context("test-query")

test_that("constraints works", {
  cons <- con$get_constraints()
  expect_equal(nrow(cons), 2)
  expect_equal(ncols(cons), 3)
  expect_equal(names(cons), c("label", "type", "property_keys"))
})

test_that("queries rows works", {
  rows <- "MATCH (a:artist) WHERE a.name = 'Thy Art Is Murder' RETURN COUNT(*);" %>%
    call_api(con)
  expect_is(rows, "list")
  expect_equal(nrow(rows[[1]]), 1)
  expect_equal(ncols(rows[[1]]), 1)
  expect_equal(names(rows[[1]]), c("value"))
})

test_that("queries graphs works", {
  graph <- "MATCH (a:artist) -[b:has_recorded] -> (c:album ) RETURN a, b, c" %>%
    call_api(con, type = "graph")
  expect_is(rows, "list")
  expect_length(graph, 2)
  expect_equal(nrow(graph$nodes), 1975)
  expect_equal(ncols(graph$nodes), 3)
  expect_equal(names(graph[[1]]), c("id", "label", "properties"))
})
