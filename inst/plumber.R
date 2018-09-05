library(readr)

#' An endpoint to test the API
#'
#' @param q A character string to print back
#' @get /test

function(q=""){
  list(msg = paste0("You entered: '", q, "'"))
}

#' Read a csv
#'
#' @param path The path.
#' @get /csv
#' @csv

function(res, path){
  csv_content <- read_csv(path)
  filename <- tempfile(fileext = ".csv")
  write.csv(csv_content, filename, row.names = FALSE)
  include_file(filename, res, "text/csv")
}
