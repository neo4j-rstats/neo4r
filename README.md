
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](https://travis-ci.org/statnmap/neo4r.svg?branch=master)](https://travis-ci.org/statnmap/neo4r)

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

> Disclaimer: this package is still at an experimental level and under
> active development. You should only use it for testing, reporting bugs
> (which are to be expected), proposing changes to the code, requesting
> features, sending ideas… As long as this package is in “Experimental”
> mode, there might be bugs, and changes to the API are to be expected.
> Read the [NEWS.md](NEWS.md) to be informed of the last changes.

Read complementary documentation at
<https://neo4j-rstats.github.io/user-guide/>

# neo4r

The goal of {neo4r} is to provide a modern and flexible Neo4J driver for
R.

It’s modern in the sense that the results are returned as tibbles
whenever possible, it relies on modern tools, and it is designed to work
with pipes. Our goal is to provide a driver that can be easily
integrated in a data analysis workflow, especially by providing an API
working smoothly with other data analysis (`{dplyr}` or `{purrr}`) and
graph packages (`{igraph}`, `{ggraph}`, `{visNetwork}`…).

It’s flexible in the sense that it is rather unopinionated regarding the
way it returns the results, by trying to stay as close as possible to
the way Neo4J returns data. That way, you have the control over the way
you will compute the results. At the same time, the result is not too
complex, so that the “heavy lifting” of data wrangling is not left to
the user.

The connexion object is also an easy to control R6 method, allowing you
to update and query information from the API.

## Installation

You can install {neo4r} from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("neo4j-rstats/neo4r")
```

## Create a connexion object

Start by creating a new connexion object with `neo4j_api$new`

``` r
library(neo4r)
con <- neo4j_api$new(url = "http://localhost:7474", 
                     user = "plop", password = "pouetpouet")
```

This connexion object is designed to interact with the Neo4J API.

It comes with some methods to retrieve information from it :

``` r
# Test the endpoint, that will not work :
con$ping()
#> [1] 401
```

Being an R6 object, `con` is flexible in the sense that you can change
`url`, `user` and `password` at any time:

``` r
con$reset_user("neo4j")
con$ping()
#> [1] 200
# Or with 
con$password <- "pouetpouet"
```

That means you can connect to another url at any time without having to
create a new connexion object. (`con$reset_url()`).

``` r
# Get Neo4J Version
con$get_version()
#> [1] "3.4.0-rc02"
# List constaints (if any)
con$get_constraints()
#> # A tibble: 3 x 3
#>   label  type       property_keys
#>   <chr>  <chr>      <chr>        
#> 1 Band   UNIQUENESS name         
#> 2 City   UNIQUENESS name         
#> 3 record UNIQUENESS name
# Get a vector of labels (if any)
con$get_labels()
#> # A tibble: 5 x 1
#>   labels
#>   <chr> 
#> 1 Band  
#> 2 album 
#> 3 City  
#> 4 record
#> 5 artist
# Get a vector of relationships (if any)
con$get_relationships()
#> # A tibble: 4 x 1
#>   labels      
#>   <chr>       
#> 1 PLAYED_IN   
#> 2 IS_FROM     
#> 3 WAS_RECORDED
#> 4 has_recorded
# Get schema 
con$get_schema()
#> # A tibble: 3 x 2
#>   label  property_keys
#>   <chr>  <chr>        
#> 1 City   name         
#> 2 Band   name         
#> 3 record name
```

## Call the API

You can either create a separate query or insert it inside the
`call_api` function.

The `call_api()` function takes several arguments :

  - `query` : the cypher query
  - `con` : the connexion object
  - `type` : “rows” or “graph”: wether to return the results as a list
    of results in tibble, or as a graph object (with `$nodes` and
    `$relationships`)
  - `output` : the output format (R or json)
  - `include_stats` : whether or not to include the stats about the call
  - `meta` : wether or not to include the meta arguments of the nodes
    when calling with “rows”

> It will be possible to write queries and pipe them with
> `{cyphersugar}` at the end of the developping process of all the
> planned packages. `{cyphersugar}` will offer a *syntactic sugar* on
> top of Cypher.

### “rows” format

The user chooses wether or not to return a list of tibbles when calling
the API. You get as many objects as specified in the RETURN cypher
statement.

``` r
library(magrittr)

'MATCH (r:record) -[:WAS_RECORDED] -> (b:Band) where b.formed = 1991 RETURN *;' %>%
  call_api(con)
#> $b
#> # A tibble: 14 x 2
#>    name     formed
#>    <chr>     <int>
#>  1 Burzum     1991
#>  2 Burzum     1991
#>  3 Burzum     1991
#>  4 Burzum     1991
#>  5 Burzum     1991
#>  6 Burzum     1991
#>  7 Burzum     1991
#>  8 Enslaved   1991
#>  9 Enslaved   1991
#> 10 Enslaved   1991
#> 11 Enslaved   1991
#> 12 Immortal   1991
#> 13 Immortal   1991
#> 14 Immortal   1991
#> 
#> $r
#> # A tibble: 14 x 2
#>    release name                         
#>      <int> <chr>                        
#>  1    1992 Det som engang var           
#>  2    1992 Aske                         
#>  3    1992 Hvis lyset tar oss           
#>  4    1993 Filosofem                    
#>  5    1991 Demo I                       
#>  6    1991 Demo II                      
#>  7    1992 Burzum                       
#>  8    1993 Vikingligr Veldi             
#>  9    1992 Hordanes Land                
#> 10    1992 Yggdrasill                   
#> 11    1991 Nema                         
#> 12    1991 Immortal                     
#> 13    1993 Pure Holocaust               
#> 14    1992 Diabolical Fullmoon Mysticism
```

By default, results are returned as an R list of tibbles. We think this
is the more “truthful” way to implement the outputs regarding Neo4J
calls.

For example, when you want to return two nodes types, you’ll get two
results, in the form of two tibbles (what we’ve seen just before) - the
result is a two elements list with each element being labelled the way
it has been specified in the Cypher query.

Results can also be returned in
JSON:

``` r
'MATCH (r:record) -[:WAS_RECORDED] -> (b:Band) where b.formed = 1991 RETURN * LIMIT 1;' %>%
  call_api(con, output = "json")
#> [
#>   [
#>     {
#>       "row": [
#>         {
#>           "name": ["Burzum"],
#>           "formed": [1991]
#>         },
#>         {
#>           "release": [1992],
#>           "name": ["Det som engang var"]
#>         }
#>       ],
#>       "meta": [
#>         {
#>           "id": [1136],
#>           "type": ["node"],
#>           "deleted": [false]
#>         },
#>         {
#>           "id": [2160],
#>           "type": ["node"],
#>           "deleted": [false]
#>         }
#>       ]
#>     }
#>   ]
#> ]
```

If you turn the `type` argument to `"graph"`, you’ll get a graph
result:

``` r
'MATCH (r:record) -[:WAS_RECORDED] -> (b:Band) where b.formed = 1991 RETURN *;' %>%
  call_api(con, type = "graph")
#> $nodes
#> # A tibble: 17 x 3
#>    id    label     properties
#>    <chr> <list>    <list>    
#>  1 1136  <chr [1]> <list [2]>
#>  2 2160  <chr [1]> <list [2]>
#>  3 2166  <chr [1]> <list [2]>
#>  4 2168  <chr [1]> <list [2]>
#>  5 2173  <chr [1]> <list [2]>
#>  6 2154  <chr [1]> <list [2]>
#>  7 2157  <chr [1]> <list [2]>
#>  8 2159  <chr [1]> <list [2]>
#>  9 2139  <chr [1]> <list [2]>
#> 10 2175  <chr [1]> <list [2]>
#> 11 2170  <chr [1]> <list [2]>
#> 12 2164  <chr [1]> <list [2]>
#> 13 2158  <chr [1]> <list [2]>
#> 14 2156  <chr [1]> <list [2]>
#> 15 2142  <chr [1]> <list [2]>
#> 16 2181  <chr [1]> <list [2]>
#> 17 2161  <chr [1]> <list [2]>
#> 
#> attr(,"class")
#> [1] "neo"  "list"
```

The result is returned as one node or relationship by row.

Due to the specific data format of Neo4J, there can be more than one
label and property by node and relationship. That’s why the results is
returned, by design, as a list-dataframe.

We have designed several functions to unnest the output :

\+`unnest_nodes()`, that can unnest a node dataframe
:

``` r
res <- 'MATCH (r:record) -[w:WAS_RECORDED] -> (b:Band) where b.formed = 1991 RETURN *;' %>%
  call_api(con, type = "graph")
unnest_nodes(res$nodes)
#> # A tibble: 17 x 5
#>    id    label  name                          formed release
#>    <chr> <chr>  <chr>                          <int>   <int>
#>  1 1136  Band   Burzum                          1991      NA
#>  2 2160  record Det som engang var                NA    1992
#>  3 2166  record Aske                              NA    1992
#>  4 2168  record Hvis lyset tar oss                NA    1992
#>  5 2173  record Filosofem                         NA    1993
#>  6 2154  record Demo I                            NA    1991
#>  7 2157  record Demo II                           NA    1991
#>  8 2159  record Burzum                            NA    1992
#>  9 2139  Band   Enslaved                        1991      NA
#> 10 2175  record Vikingligr Veldi                  NA    1993
#> 11 2170  record Hordanes Land                     NA    1992
#> 12 2164  record Yggdrasill                        NA    1992
#> 13 2158  record Nema                              NA    1991
#> 14 2156  record Immortal                          NA    1991
#> 15 2142  Band   Immortal                        1991      NA
#> 16 2181  record Pure Holocaust                    NA    1993
#> 17 2161  record Diabolical Fullmoon Mysticism     NA    1992
```

Please, note that this function will return `NA` for the properties that
aren’t in a node. For example here, we have no ‘licence’ information for
the Maintainer node (that makes sense).

On the long run, and this is not {neo4r} specific but Neo4J related, a
good practice is to have a “name” propertie on each node, so this column
will be full here.

Also, it is possible to unnest either the properties or the labels :

``` r
res$nodes %>%
  unnest_nodes(what = "properties")
#> # A tibble: 17 x 5
#>    id    label     name                          formed release
#>    <chr> <list>    <chr>                          <int>   <int>
#>  1 1136  <chr [1]> Burzum                          1991      NA
#>  2 2160  <chr [1]> Det som engang var                NA    1992
#>  3 2166  <chr [1]> Aske                              NA    1992
#>  4 2168  <chr [1]> Hvis lyset tar oss                NA    1992
#>  5 2173  <chr [1]> Filosofem                         NA    1993
#>  6 2154  <chr [1]> Demo I                            NA    1991
#>  7 2157  <chr [1]> Demo II                           NA    1991
#>  8 2159  <chr [1]> Burzum                            NA    1992
#>  9 2139  <chr [1]> Enslaved                        1991      NA
#> 10 2175  <chr [1]> Vikingligr Veldi                  NA    1993
#> 11 2170  <chr [1]> Hordanes Land                     NA    1992
#> 12 2164  <chr [1]> Yggdrasill                        NA    1992
#> 13 2158  <chr [1]> Nema                              NA    1991
#> 14 2156  <chr [1]> Immortal                          NA    1991
#> 15 2142  <chr [1]> Immortal                        1991      NA
#> 16 2181  <chr [1]> Pure Holocaust                    NA    1993
#> 17 2161  <chr [1]> Diabolical Fullmoon Mysticism     NA    1992
```

``` r
res$nodes %>%
  unnest_nodes(what = "label")
#> # A tibble: 17 x 3
#>    id    properties label 
#>    <chr> <list>     <chr> 
#>  1 1136  <list [2]> Band  
#>  2 2160  <list [2]> record
#>  3 2166  <list [2]> record
#>  4 2168  <list [2]> record
#>  5 2173  <list [2]> record
#>  6 2154  <list [2]> record
#>  7 2157  <list [2]> record
#>  8 2159  <list [2]> record
#>  9 2139  <list [2]> Band  
#> 10 2175  <list [2]> record
#> 11 2170  <list [2]> record
#> 12 2164  <list [2]> record
#> 13 2158  <list [2]> record
#> 14 2156  <list [2]> record
#> 15 2142  <list [2]> Band  
#> 16 2181  <list [2]> record
#> 17 2161  <list [2]> record
```

  - `unnest_relationships()`

There is only one nested column in the relationship table, thus the
function is quite straightforward :

``` r
unnest_relationships(res$relationships)
#> # A tibble: 14 x 5
#>    id    type         startNode endNode properties
#>    <chr> <chr>        <chr>     <chr>   <chr>     
#>  1 2108  WAS_RECORDED 2160      1136    <NA>      
#>  2 2109  WAS_RECORDED 2166      1136    <NA>      
#>  3 2110  WAS_RECORDED 2168      1136    <NA>      
#>  4 2111  WAS_RECORDED 2173      1136    <NA>      
#>  5 2105  WAS_RECORDED 2154      1136    <NA>      
#>  6 2106  WAS_RECORDED 2157      1136    <NA>      
#>  7 2107  WAS_RECORDED 2159      1136    <NA>      
#>  8 2121  WAS_RECORDED 2175      2139    <NA>      
#>  9 2120  WAS_RECORDED 2170      2139    <NA>      
#> 10 2119  WAS_RECORDED 2164      2139    <NA>      
#> 11 2118  WAS_RECORDED 2158      2139    <NA>      
#> 12 2115  WAS_RECORDED 2156      2142    <NA>      
#> 13 2117  WAS_RECORDED 2181      2142    <NA>      
#> 14 2116  WAS_RECORDED 2161      2142    <NA>
```

  - `unnest_graph`

This function takes a graph results, and does `unnest_nodes` and
`unnest_relationships`.

``` r
unnest_graph(res)
#> $nodes
#> # A tibble: 17 x 5
#>    id    label  name                          formed release
#>    <chr> <chr>  <chr>                          <int>   <int>
#>  1 1136  Band   Burzum                          1991      NA
#>  2 2160  record Det som engang var                NA    1992
#>  3 2166  record Aske                              NA    1992
#>  4 2168  record Hvis lyset tar oss                NA    1992
#>  5 2173  record Filosofem                         NA    1993
#>  6 2154  record Demo I                            NA    1991
#>  7 2157  record Demo II                           NA    1991
#>  8 2159  record Burzum                            NA    1992
#>  9 2139  Band   Enslaved                        1991      NA
#> 10 2175  record Vikingligr Veldi                  NA    1993
#> 11 2170  record Hordanes Land                     NA    1992
#> 12 2164  record Yggdrasill                        NA    1992
#> 13 2158  record Nema                              NA    1991
#> 14 2156  record Immortal                          NA    1991
#> 15 2142  Band   Immortal                        1991      NA
#> 16 2181  record Pure Holocaust                    NA    1993
#> 17 2161  record Diabolical Fullmoon Mysticism     NA    1992
#> 
#> $relationships
#> # A tibble: 14 x 5
#>    id    type         startNode endNode properties
#>    <chr> <chr>        <chr>     <chr>   <chr>     
#>  1 2108  WAS_RECORDED 2160      1136    <NA>      
#>  2 2109  WAS_RECORDED 2166      1136    <NA>      
#>  3 2110  WAS_RECORDED 2168      1136    <NA>      
#>  4 2111  WAS_RECORDED 2173      1136    <NA>      
#>  5 2105  WAS_RECORDED 2154      1136    <NA>      
#>  6 2106  WAS_RECORDED 2157      1136    <NA>      
#>  7 2107  WAS_RECORDED 2159      1136    <NA>      
#>  8 2121  WAS_RECORDED 2175      2139    <NA>      
#>  9 2120  WAS_RECORDED 2170      2139    <NA>      
#> 10 2119  WAS_RECORDED 2164      2139    <NA>      
#> 11 2118  WAS_RECORDED 2158      2139    <NA>      
#> 12 2115  WAS_RECORDED 2156      2142    <NA>      
#> 13 2117  WAS_RECORDED 2181      2142    <NA>      
#> 14 2116  WAS_RECORDED 2161      2142    <NA>      
#> 
#> attr(,"class")
#> [1] "neo"  "list"
```

### Extraction

There are two convenient functions to extract nodes and relationships:

``` r
'MATCH p=()-[r:WAS_RECORDED]->() RETURN p LIMIT 5;' %>%
  call_api(con, type = "graph") %>% 
  extract_nodes()
#> # A tibble: 6 x 3
#>   id    label     properties
#>   <chr> <list>    <list>    
#> 1 2160  <chr [1]> <list [2]>
#> 2 1136  <chr [1]> <list [2]>
#> 3 2166  <chr [1]> <list [2]>
#> 4 2168  <chr [1]> <list [2]>
#> 5 2173  <chr [1]> <list [2]>
#> 6 2154  <chr [1]> <list [2]>
```

``` r
'MATCH p=()-[w:WAS_RECORDED]->() RETURN p LIMIT 5;' %>%
  call_api(con, type = "graph") %>% 
  extract_relationships()
#> # A tibble: 5 x 5
#>   id    type         startNode endNode properties
#>   <chr> <chr>        <chr>     <chr>   <list>    
#> 1 2108  WAS_RECORDED 2160      1136    <list [0]>
#> 2 2109  WAS_RECORDED 2166      1136    <list [0]>
#> 3 2110  WAS_RECORDED 2168      1136    <list [0]>
#> 4 2111  WAS_RECORDED 2173      1136    <list [0]>
#> 5 2105  WAS_RECORDED 2154      1136    <list [0]>
```

## Convert for common graph packages

### {igraph}

In order to be converted into a graph object:

  - nodes need an id, and a name. By default, node name is assumed to be
    found in the “name” property returned by the graph, specifying any
    other column is allowed. The “label” column from Neo4J is renamed
    “group”.

  - relationships need a start and an end, *i.e.* startNode and endNode
    in the Neo4J results.

<!-- end list -->

``` r
'MATCH p=()-[r:WAS_RECORDED]->() RETURN p LIMIT 5;' %>%
  call_api(con, type = "graph") %>%
  convert_to("igraph")
#> IGRAPH a550ced DN-- 6 5 -- 
#> + attr: name (v/c), group (v/c), release (v/n), formed (v/n), type
#> | (e/c), id (e/c), properties (e/x)
#> + edges from a550ced (vertex names):
#> [1] Det som engang var->Burzum Aske              ->Burzum
#> [3] Hvis lyset tar oss->Burzum Filosofem         ->Burzum
#> [5] Demo I            ->Burzum
```

Which means that you can :

``` r
'MATCH p=()-[r:WAS_RECORDED]->() RETURN p LIMIT 5;' %>%
  call_api(con, type = "graph") %>% 
  convert_to("igraph") %>%
  plot()
```

<img src="man/figures/README-unnamed-chunk-16-1.png" width="100%" />

This can also be used with `{ggraph}` :

``` r
library(ggraph)
#> Loading required package: ggplot2
'MATCH p=()-[r:WAS_RECORDED]->() RETURN p LIMIT 5;' %>%
  call_api(con, type = "graph") %>% 
  convert_to("igraph") %>%
  ggraph() + 
  geom_node_label(aes(label = name, color = group)) +
  geom_edge_link() + 
  theme_graph()
#> Using `nicely` as default layout
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%" />

### {visNetwork}

``` r
network <- 'MATCH p=()-[r:WAS_RECORDED]->() RETURN p LIMIT 5;' %>%
  call_api(con, type = "graph") %>% 
  convert_to("visNetwork")
visNetwork::visNetwork(network$nodes, network$relationships)
```

## Sending data to the API

You can simply send queries has we have just seen, by writing the cypher
query and call the api.

### Transform elements to cypher queries

  - `vec_to_cypher()` creates a list :

<!-- end list -->

``` r
vec_to_cypher(iris[1, 1:3], "Species")
#> [1] "(:`Species` {`Sepal.Length`: '5.1', `Sepal.Width`: '3.5', `Petal.Length`: '1.4'})"
```

  - and `vec_to_cypher_with_var()` creates a cypher call starting with a
    variable :

<!-- end list -->

``` r
vec_to_cypher_with_var(iris[1, 1:3], "Species", a)
#> [1] "(a:`Species` {`Sepal.Length`: '5.1', `Sepal.Width`: '3.5', `Petal.Length`: '1.4'})"
```

This can be combined inside a cypher call:

``` r
paste("MERGE", vec_to_cypher(iris[1, 1:3], "Species"))
#> [1] "MERGE (:`Species` {`Sepal.Length`: '5.1', `Sepal.Width`: '3.5', `Petal.Length`: '1.4'})"
```

### Reading and sending a cypher file :

  - `read_cypher` reads a cypher file and returns a tibble of all the
    calls:

<!-- end list -->

``` r
read_cypher("data-raw/create.cypher")
#> # A tibble: 4 x 1
#>   cypher                                                                   
#>   <chr>                                                                    
#> 1 CREATE CONSTRAINT ON (b:Band) ASSERT b.name IS UNIQUE;                   
#> 2 CREATE CONSTRAINT ON (c:City) ASSERT c.name IS UNIQUE;                   
#> 3 CREATE CONSTRAINT ON (r:record) ASSERT r.name IS UNIQUE;                 
#> 4 CREATE (ancient:Band {name: 'Ancient', formed: 1992}), (acturus:Band {na…
```

  - `send_cypher` reads a cypher file, and send it the the API. By
    default, the stats are returned.

<!-- end list -->

``` r
send_cypher("data-raw/constraints.cypher", con)
```

### Sending csv dataframe to Neo4J

The `load_csv` sends an csv from an url to the Neo4J browser.

The args are :

  - `on_load` : the code to execute on load
  - `con` : the connexion object
  - `url` : the url of the csv to send
  - `header` : wether or not the csv has a header
  - `periodic_commit` : the volume for PERIODIC COMMIT
  - `as` : the AS argument for LOAD CSV
  - `format` : the format of the result
  - `include_stats` : whether or not to include the stats
  - `meta` : whether or not to return the meta information

<!-- end list -->

``` r
# Create the constraints
call_api("CREATE CONSTRAINT ON (a:artist) ASSERT a.name IS UNIQUE;", con)
call_api("CREATE CONSTRAINT ON (al:album) ASSERT al.name IS UNIQUE;", con)
```

``` r
# List constaints (if any)
con$get_constraints()
#> # A tibble: 3 x 3
#>   label  type       property_keys
#>   <chr>  <chr>      <chr>        
#> 1 Band   UNIQUENESS name         
#> 2 City   UNIQUENESS name         
#> 3 record UNIQUENESS name
# Create the query that will create the nodes and relationships
on_load_query <- 'MERGE (a:artist { name: csvLine.artist})
MERGE (al:album {name: csvLine.album_name})
MERGE (a) -[:has_recorded] -> (al)  
RETURN a AS artists, al AS albums;'
# Send the csv 
load_csv(url = "https://raw.githubusercontent.com/ThinkR-open/datasets/master/tracks.csv", 
         con = con, header = TRUE, periodic_commit = 50, 
         as = "csvLine", on_load = on_load_query)
#> $artists
#> # A tibble: 2,367 x 1
#>    name           
#>    <chr>          
#>  1 Eminem         
#>  2 Eurythmics     
#>  3 Queen          
#>  4 The Police     
#>  5 A$AP Rocky     
#>  6 Tears For Fears
#>  7 Foals          
#>  8 Bag Raiders    
#>  9 Bright Eyes    
#> 10 Bob Dylan      
#> # ... with 2,357 more rows
#> 
#> $albums
#> # A tibble: 2,367 x 1
#>    name                           
#>    <chr>                          
#>  1 Curtain Call (Deluxe)          
#>  2 Sweet Dreams (Are Made Of This)
#>  3 The Game (2011 Remaster)       
#>  4 Synchronicity (Remastered)     
#>  5 LONG.LIVE.A$AP (Deluxe Version)
#>  6 Songs From The Big Chair       
#>  7 Holy Fire                      
#>  8 Bag Raiders (Deluxe)           
#>  9 I'm Wide Awake, It's Morning   
#> 10 Highway 61 Revisited           
#> # ... with 2,357 more rows
#> 
#> $stats
#> # A tibble: 12 x 2
#>    type                  value
#>    <chr>                 <dbl>
#>  1 contains_updates          0
#>  2 nodes_created             0
#>  3 nodes_deleted             0
#>  4 properties_set            0
#>  5 relationships_created     0
#>  6 relationship_deleted      0
#>  7 labels_added              0
#>  8 labels_removed            0
#>  9 indexes_added             0
#> 10 indexes_removed           0
#> 11 constraints_added         0
#> 12 constraints_removed       0
```

## CoC

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
