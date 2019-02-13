check_unique_class <- function(vec){
  res <- lapply(vec, class)
  length(unique(res)) == 1
}
