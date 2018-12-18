rm(list = ls())
devtools::load_all()
con <- neo4j_api$new(url = "http://localhost:7474",
                     user = "neo4j", password = "pouetpouet")
con

library(neo4r)
con <- neo4j_api$new(url = "http://138.197.15.1:7474",
                     user = "all", password = "readonly")
con$ping()

"match (t:Tag) return t.name as name, size((t)--()) as deg limit 5;" %>%
  call_neo4j(con)

