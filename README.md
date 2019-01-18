
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](https://travis-ci.org/statnmap/neo4r.svg?branch=master)](https://travis-ci.org/statnmap/neo4r)

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

> Disclaimer: this package is still under active development. Read the
> [NEWS.md](NEWS.md) to be informed of the last changes.

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

## Server Connection

Please note that **for now, the connection is only possible through http
/ https**.

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
con$reset_password("neo4j") 
con$ping()
#> [1] 200
```

That means you can connect to another url at any time without having to
create a new connexion object. (`con$reset_url()`).

``` r
# Get Neo4J Version
con$get_version()
#> [1] "3.4.5"
# List constaints (if any)
con$get_constraints()
#>     label       type property_keys
#> 1: record UNIQUENESS          name
#> 2:   City UNIQUENESS          name
#> 3:   Band UNIQUENESS          name
#> 4: artist UNIQUENESS          name
# Get a vector of labels (if any)
con$get_labels()
#> # A tibble: 14 x 1
#>    labels     
#>    <chr>      
#>  1 Person     
#>  2 artist     
#>  3 GrandPrix  
#>  4 Band       
#>  5 Team       
#>  6 Engine     
#>  7 Driver     
#>  8 record     
#>  9 Playoff    
#> 10 Country    
#> 11 W          
#> 12 E          
#> 13 Constructor
#> 14 City
# Get a vector of relationships (if any)
con$get_relationships()
#> # A tibble: 10 x 1
#>    labels        
#>    <chr>         
#>  1 KNOWS         
#>  2 PLAYED_IN     
#>  3 IS_FROM       
#>  4 WAS_RECORDED  
#>  5 WIN           
#>  6 HAS           
#>  7 COUNTRY_ORIGIN
#>  8 BELONGS_TO    
#>  9 BELONGED_TO   
#> 10 FINISHED
# Get schema 
con$get_schema()
#>     label property_keys
#> 1:   City          name
#> 2:   Band          name
#> 3: artist          name
#> 4: record          name
```

### Using the Connection Pane

`{neo4r}` comes with a Connection Pane interface for RStudio.

Once installed, you can go to the “Connections”, and use the widget to
connect to the Neo4J server:

![](readmefigs/connectionpane.png)

## Call the API

You can either create a separate query or insert it inside the
`call_neo4j` function.

The `call_neo4j()` function takes several arguments :

  - `query` : the cypher query
  - `con` : the connexion object
  - `type` : “rows” or “graph”: wether to return the results as a list
    of results in tibble, or as a graph object (with `$nodes` and
    `$relationships`)
  - `output` : the output format (R or json)
  - `include_stats` : whether or not to include the stats about the call
  - `meta` : wether or not to include the meta arguments of the nodes
    when calling with “rows”

### “rows” format

The user chooses wether or not to return a list of tibbles when calling
the API. You get as many objects as specified in the RETURN cypher
statement.

``` r
library(magrittr)

'MATCH (r:record) -[:WAS_RECORDED] -> (b:Band) where b.formed = 1991 RETURN *;' %>%
  call_neo4j(con)
#> $b
#> # A tibble: 1 x 2
#>   name     formed
#>   <chr>     <int>
#> 1 Immortal   1991
#> 
#> $r
#> # A tibble: 1 x 2
#>   release name    
#>     <int> <chr>   
#> 1    1991 Immortal
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
  call_neo4j(con, output = "json")
#> [
#>   [
#>     {
#>       "row": [
#>         {
#>           "name": ["Burzum"],
#>           "formed": [1991]
#>         },
#>         {
#>           "release": [1991],
#>           "name": ["Demo I"]
#>         }
#>       ],
#>       "meta": [
#>         {
#>           "id": [4],
#>           "type": ["node"],
#>           "deleted": [false]
#>         },
#>         {
#>           "id": [63],
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
  call_neo4j(con, type = "graph")
#> $nodes
#> # A tibble: 16 x 3
#>    id    label     properties
#>    <chr> <list>    <list>    
#>  1 4     <chr [1]> <list [2]>
#>  2 63    <chr [1]> <list [2]>
#>  3 67    <chr [1]> <list [2]>
#>  4 81    <chr [1]> <list [2]>
#>  5 76    <chr [1]> <list [2]>
#>  6 74    <chr [1]> <list [2]>
#>  7 68    <chr [1]> <list [2]>
#>  8 8     <chr [1]> <list [2]>
#>  9 72    <chr [1]> <list [2]>
#> 10 66    <chr [1]> <list [2]>
#> 11 83    <chr [1]> <list [2]>
#> 12 78    <chr [1]> <list [2]>
#> 13 89    <chr [1]> <list [2]>
#> 14 11    <chr [1]> <list [2]>
#> 15 69    <chr [1]> <list [2]>
#> 16 65    <chr [1]> <list [2]>
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
  call_neo4j(con, type = "graph")
unnest_nodes(res$nodes)
#> # A tibble: 16 x 5
#>    id    label  name                          formed release
#>    <chr> <chr>  <chr>                          <int>   <int>
#>  1 4     Band   Burzum                          1991      NA
#>  2 63    record Demo I                            NA    1991
#>  3 67    record Burzum                            NA    1992
#>  4 81    record Filosofem                         NA    1993
#>  5 76    record Hvis lyset tar oss                NA    1992
#>  6 74    record Aske                              NA    1992
#>  7 68    record Det som engang var                NA    1992
#>  8 8     Band   Enslaved                        1991      NA
#>  9 72    record Yggdrasill                        NA    1992
#> 10 66    record Nema                              NA    1991
#> 11 83    record Vikingligr Veldi                  NA    1993
#> 12 78    record Hordanes Land                     NA    1992
#> 13 89    record Pure Holocaust                    NA    1993
#> 14 11    Band   Immortal                        1991      NA
#> 15 69    record Diabolical Fullmoon Mysticism     NA    1992
#> 16 65    record Immortal                          NA    1991
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
#> # A tibble: 16 x 5
#>    id    label     name                          formed release
#>    <chr> <list>    <chr>                          <int>   <int>
#>  1 4     <chr [1]> Burzum                          1991      NA
#>  2 63    <chr [1]> Demo I                            NA    1991
#>  3 67    <chr [1]> Burzum                            NA    1992
#>  4 81    <chr [1]> Filosofem                         NA    1993
#>  5 76    <chr [1]> Hvis lyset tar oss                NA    1992
#>  6 74    <chr [1]> Aske                              NA    1992
#>  7 68    <chr [1]> Det som engang var                NA    1992
#>  8 8     <chr [1]> Enslaved                        1991      NA
#>  9 72    <chr [1]> Yggdrasill                        NA    1992
#> 10 66    <chr [1]> Nema                              NA    1991
#> 11 83    <chr [1]> Vikingligr Veldi                  NA    1993
#> 12 78    <chr [1]> Hordanes Land                     NA    1992
#> 13 89    <chr [1]> Pure Holocaust                    NA    1993
#> 14 11    <chr [1]> Immortal                        1991      NA
#> 15 69    <chr [1]> Diabolical Fullmoon Mysticism     NA    1992
#> 16 65    <chr [1]> Immortal                          NA    1991
```

``` r
res$nodes %>%
  unnest_nodes(what = "label")
#> # A tibble: 16 x 3
#>    id    properties label 
#>    <chr> <list>     <chr> 
#>  1 4     <list [2]> Band  
#>  2 63    <list [2]> record
#>  3 67    <list [2]> record
#>  4 81    <list [2]> record
#>  5 76    <list [2]> record
#>  6 74    <list [2]> record
#>  7 68    <list [2]> record
#>  8 8     <list [2]> Band  
#>  9 72    <list [2]> record
#> 10 66    <list [2]> record
#> 11 83    <list [2]> record
#> 12 78    <list [2]> record
#> 13 89    <list [2]> record
#> 14 11    <list [2]> Band  
#> 15 69    <list [2]> record
#> 16 65    <list [2]> record
```

  - `unnest_relationships()`

There is only one nested column in the relationship table, thus the
function is quite straightforward :

``` r
unnest_relationships(res$relationships)
#> # A tibble: 13 x 5
#>    id    type         startNode endNode properties
#>    <chr> <chr>        <chr>     <chr>   <chr>     
#>  1 62    WAS_RECORDED 63        4       <NA>      
#>  2 63    WAS_RECORDED 67        4       <NA>      
#>  3 67    WAS_RECORDED 81        4       <NA>      
#>  4 66    WAS_RECORDED 76        4       <NA>      
#>  5 65    WAS_RECORDED 74        4       <NA>      
#>  6 64    WAS_RECORDED 68        4       <NA>      
#>  7 75    WAS_RECORDED 72        8       <NA>      
#>  8 74    WAS_RECORDED 66        8       <NA>      
#>  9 77    WAS_RECORDED 83        8       <NA>      
#> 10 76    WAS_RECORDED 78        8       <NA>      
#> 11 73    WAS_RECORDED 89        11      <NA>      
#> 12 72    WAS_RECORDED 69        11      <NA>      
#> 13 71    WAS_RECORDED 65        11      <NA>
```

  - `unnest_graph`

This function takes a graph results, and does `unnest_nodes` and
`unnest_relationships`.

``` r
unnest_graph(res)
#> $nodes
#> # A tibble: 16 x 5
#>    id    label  name                          formed release
#>    <chr> <chr>  <chr>                          <int>   <int>
#>  1 4     Band   Burzum                          1991      NA
#>  2 63    record Demo I                            NA    1991
#>  3 67    record Burzum                            NA    1992
#>  4 81    record Filosofem                         NA    1993
#>  5 76    record Hvis lyset tar oss                NA    1992
#>  6 74    record Aske                              NA    1992
#>  7 68    record Det som engang var                NA    1992
#>  8 8     Band   Enslaved                        1991      NA
#>  9 72    record Yggdrasill                        NA    1992
#> 10 66    record Nema                              NA    1991
#> 11 83    record Vikingligr Veldi                  NA    1993
#> 12 78    record Hordanes Land                     NA    1992
#> 13 89    record Pure Holocaust                    NA    1993
#> 14 11    Band   Immortal                        1991      NA
#> 15 69    record Diabolical Fullmoon Mysticism     NA    1992
#> 16 65    record Immortal                          NA    1991
#> 
#> $relationships
#> # A tibble: 13 x 5
#>    id    type         startNode endNode properties
#>    <chr> <chr>        <chr>     <chr>   <chr>     
#>  1 62    WAS_RECORDED 63        4       <NA>      
#>  2 63    WAS_RECORDED 67        4       <NA>      
#>  3 67    WAS_RECORDED 81        4       <NA>      
#>  4 66    WAS_RECORDED 76        4       <NA>      
#>  5 65    WAS_RECORDED 74        4       <NA>      
#>  6 64    WAS_RECORDED 68        4       <NA>      
#>  7 75    WAS_RECORDED 72        8       <NA>      
#>  8 74    WAS_RECORDED 66        8       <NA>      
#>  9 77    WAS_RECORDED 83        8       <NA>      
#> 10 76    WAS_RECORDED 78        8       <NA>      
#> 11 73    WAS_RECORDED 89        11      <NA>      
#> 12 72    WAS_RECORDED 69        11      <NA>      
#> 13 71    WAS_RECORDED 65        11      <NA>      
#> 
#> attr(,"class")
#> [1] "neo"  "list"
```

### Extraction

There are two convenient functions to extract nodes and relationships:

``` r
'MATCH p=()-[r:WAS_RECORDED]->() RETURN p LIMIT 5;' %>%
  call_neo4j(con, type = "graph") %>% 
  extract_nodes()
#> # A tibble: 6 x 3
#>   id    label     properties
#>   <chr> <list>    <list>    
#> 1 4     <chr [1]> <list [2]>
#> 2 63    <chr [1]> <list [2]>
#> 3 67    <chr [1]> <list [2]>
#> 4 81    <chr [1]> <list [2]>
#> 5 76    <chr [1]> <list [2]>
#> 6 74    <chr [1]> <list [2]>
```

``` r
'MATCH p=()-[w:WAS_RECORDED]->() RETURN p LIMIT 5;' %>%
  call_neo4j(con, type = "graph") %>% 
  extract_relationships()
#> # A tibble: 5 x 5
#>   id    type         startNode endNode properties
#>   <chr> <chr>        <chr>     <chr>   <list>    
#> 1 62    WAS_RECORDED 63        4       <list [0]>
#> 2 63    WAS_RECORDED 67        4       <list [0]>
#> 3 67    WAS_RECORDED 81        4       <list [0]>
#> 4 66    WAS_RECORDED 76        4       <list [0]>
#> 5 65    WAS_RECORDED 74        4       <list [0]>
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
  call_neo4j(con, type = "graph") %>%
  convert_to("igraph")
#> Called from: convert_to(., "igraph")
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#36: if (!is.null(res$nodes)) {
#>     unnested_res$nodes <- unnest_nodes(res$nodes)
#>     unnested_res$nodes <- select(unnested_res$nodes, id, name = !(!lab), 
#>         group = label, everything())
#> } else {
#>     unnested_res$nodes <- NULL
#> }
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#37: unnested_res$nodes <- unnest_nodes(res$nodes)
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#38: unnested_res$nodes <- select(unnested_res$nodes, id, name = !(!lab), 
#>     group = label, everything())
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#43: if (!is.null(res$relationships)) {
#>     unnested_res$relationships <- select(res$relationships, startNode, 
#>         endNode, type, id, properties)
#> } else {
#>     unnested_res$relationships <- NULL
#> }
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#44: unnested_res$relationships <- select(res$relationships, startNode, 
#>     endNode, type, id, properties)
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#50: graph_from_data_frame(d = unnested_res$relationships, directed = TRUE, 
#>     vertices = unnested_res$nodes)
#> IGRAPH 4ac1d63 DN-- 6 5 -- 
#> + attr: name (v/c), group (v/c), formed (v/n), release (v/n), type
#> | (e/c), id (e/c), properties (e/x)
#> + edges from 4ac1d63 (vertex names):
#> [1] Demo I            ->Burzum Burzum            ->Burzum
#> [3] Filosofem         ->Burzum Hvis lyset tar oss->Burzum
#> [5] Aske              ->Burzum
```

Which means that you can :

``` r
'MATCH p=()-[r:WAS_RECORDED]->() RETURN p LIMIT 5;' %>%
  call_neo4j(con, type = "graph") %>% 
  convert_to("igraph") %>%
  plot()
#> Called from: convert_to(., "igraph")
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#36: if (!is.null(res$nodes)) {
#>     unnested_res$nodes <- unnest_nodes(res$nodes)
#>     unnested_res$nodes <- select(unnested_res$nodes, id, name = !(!lab), 
#>         group = label, everything())
#> } else {
#>     unnested_res$nodes <- NULL
#> }
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#37: unnested_res$nodes <- unnest_nodes(res$nodes)
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#38: unnested_res$nodes <- select(unnested_res$nodes, id, name = !(!lab), 
#>     group = label, everything())
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#43: if (!is.null(res$relationships)) {
#>     unnested_res$relationships <- select(res$relationships, startNode, 
#>         endNode, type, id, properties)
#> } else {
#>     unnested_res$relationships <- NULL
#> }
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#44: unnested_res$relationships <- select(res$relationships, startNode, 
#>     endNode, type, id, properties)
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#50: graph_from_data_frame(d = unnested_res$relationships, directed = TRUE, 
#>     vertices = unnested_res$nodes)
```

<img src="man/figures/README-unnamed-chunk-16-1.png" width="100%" />

This can also be used with `{ggraph}` :

``` r
library(ggraph)
#> Loading required package: ggplot2
'MATCH p=()-[r:WAS_RECORDED]->() RETURN p LIMIT 5;' %>%
  call_neo4j(con, type = "graph") %>% 
  convert_to("igraph") %>%
  ggraph() + 
  geom_node_label(aes(label = name, color = group)) +
  geom_edge_link() + 
  theme_graph()
#> Called from: convert_to(., "igraph")
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#36: if (!is.null(res$nodes)) {
#>     unnested_res$nodes <- unnest_nodes(res$nodes)
#>     unnested_res$nodes <- select(unnested_res$nodes, id, name = !(!lab), 
#>         group = label, everything())
#> } else {
#>     unnested_res$nodes <- NULL
#> }
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#37: unnested_res$nodes <- unnest_nodes(res$nodes)
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#38: unnested_res$nodes <- select(unnested_res$nodes, id, name = !(!lab), 
#>     group = label, everything())
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#43: if (!is.null(res$relationships)) {
#>     unnested_res$relationships <- select(res$relationships, startNode, 
#>         endNode, type, id, properties)
#> } else {
#>     unnested_res$relationships <- NULL
#> }
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#44: unnested_res$relationships <- select(res$relationships, startNode, 
#>     endNode, type, id, properties)
#> debug at /Users/colin/Seafile/documents_colin/R/neo4r/R/convert_to.R#50: graph_from_data_frame(d = unnested_res$relationships, directed = TRUE, 
#>     vertices = unnested_res$nodes)
#> Using `nicely` as default layout
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%" />

### {visNetwork}

``` r
network <- 'MATCH p=()-[r:WAS_RECORDED]->() RETURN p LIMIT 5;' %>%
  call_neo4j(con, type = "graph") %>% 
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
call_neo4j("CREATE CONSTRAINT ON (a:artist) ASSERT a.name IS UNIQUE;", con)
call_neo4j("CREATE CONSTRAINT ON (al:album) ASSERT al.name IS UNIQUE;", con)
```

``` r
# List constaints (if any)
con$get_constraints()
#>     label       type property_keys
#> 1: record UNIQUENESS          name
#> 2:   City UNIQUENESS          name
#> 3:   Band UNIQUENESS          name
#> 4: artist UNIQUENESS          name
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
#> # A tibble: 1 x 1
#>   name           
#>   <chr>          
#> 1 Municipal Waste
#> 
#> $albums
#> # A tibble: 1 x 1
#>   name              
#>   <chr>             
#> 1 Hazardous Mutation
#> 
#> $stats
#> # A tibble: 12 x 2
#>    type                  value
#>    <chr>                 <dbl>
#>  1 contains_updates          1
#>  2 nodes_created          1975
#>  3 nodes_deleted             0
#>  4 properties_set         1975
#>  5 relationships_created  1183
#>  6 relationship_deleted      0
#>  7 labels_added           1975
#>  8 labels_removed            0
#>  9 indexes_added             0
#> 10 indexes_removed           0
#> 11 constraints_added         0
#> 12 constraints_removed       0
```

## Sandboxing in Docker

You can get an RStudio / Neo4J sandbox with Docker :

    docker pull colinfay/neo4r-docker
    docker run -e PASSWORD=plop -e ROOT=TRUE -d -p 8787:8787 neo4r

## CoC

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
