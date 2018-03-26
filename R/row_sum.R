# a <- tibble::tribble(
#   ~ what, ~ count,
#   "this", 1,
#   "that", 2
# )
# b <- tibble::tribble(
#   ~ what, ~ count,
#   "this", 3,
#   "that", 4
# )
# c <- tibble::tribble(
#   ~ what, ~ count,
#   "this", 5,
#   "that", 6
# )
#
# merge(a, b, by = "what")
#
# a %>%
#   mutate(count = count + b$count) %>%
#   mutate(count = count + c$count)
#
# sum_col <- function(..., col){
#   col <- enquo(col)
#   map(list(...), ~ select(.x, !!col)) %>%
#     map_dbl(sum)
# }
# sum_col(count, a, b, c)
#
#
