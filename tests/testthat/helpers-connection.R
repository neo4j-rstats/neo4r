library(neo4r)
con <- neo4j_api$new(url = "http://localhost:7474",  user = "neo4j", password = "neo4j")

call_api("CREATE CONSTRAINT ON (a:artist) ASSERT a.name IS UNIQUE;", con)
call_api("CREATE CONSTRAINT ON (al:album) ASSERT al.name IS UNIQUE;", con)

on_load_query <-
  'MERGE (a:artist { name: csvLine.artist})
    MERGE (t:album {name: csvLine.album_name})
    MERGE (p:track {name: csvLine.track})
    MERGE (a) -[:has_recorded] -> (t)
    MERGE (t) -[:contains] -> (p)
    SET p.duration = toInteger(csvLine.duration), p.expl = toBoolean(csvLine.explicit), p.pop = csvLine.popularity'

# Send the csv
load_csv(url = "https://raw.githubusercontent.com/ThinkR-open/datasets/master/tracks.csv",
         con = con, header = TRUE, periodic_commit = 500,
         as = "csvLine", on_load = on_load_query)
