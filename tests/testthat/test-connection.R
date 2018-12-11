context("test-connection.R")

test_that("connection work", {
  expect_is(con, "Neo4JAPI")
  expect_is(con, "R6")
  expect_equal(con$ping(), "200")
})


