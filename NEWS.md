# neo4r

# Version 0.1.3+

## Breaking changes

+ The `unnest_relationships()` function now only unnest one level of the data.frame.

## dev modification

+ Added required `{purrr}` version

+ Added one manual test script in `inst/`


# Version 0.1.2

+ Fixed bug with empty lists

+ Added `play_movies()` that generates the movie db

# Version 0.1.1

+ `convert_to` is deprecated for now, needs more work to be done. 
+ Neo4J null are now turned to `NA` to fit R framework (#41)
+ get_schema is now get_index to reflect neo4j behavior (#22)

# Version 0.1.0

First version for CRAN.

## Breaking change from the dev version 

+ `call_api()` is now called `call_neo4j()`
+ `meta` is now called `include_meta` for consistency with `include_stats`
