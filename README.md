
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
#>         label       type property_keys
#> 1:       Band UNIQUENESS          name
#> 2:     record UNIQUENESS          name
#> 3:     Author UNIQUENESS          name
#> 4:       City UNIQUENESS          name
#> 5:     artist UNIQUENESS          name
#> 6:    Package UNIQUENESS          name
#> 7: Maintainer UNIQUENESS          name
# Get a vector of labels (if any)
con$get_labels()
#> # A tibble: 11 x 1
#>    labels    
#>    <chr>     
#>  1 artist    
#>  2 Package   
#>  3 Person    
#>  4 record    
#>  5 Band      
#>  6 City      
#>  7 album     
#>  8 Maintainer
#>  9 Author    
#> 10 Movie     
#> 11 Character
# Get a vector of relationships (if any)
con$get_relationships()
#> # A tibble: 10 x 1
#>    labels      
#>    <chr>       
#>  1 PLAYED_IN   
#>  2 IS_FROM     
#>  3 WAS_RECORDED
#>  4 has_recorded
#>  5 ACTED_IN    
#>  6 DIRECTED    
#>  7 PRODUCED    
#>  8 WROTE       
#>  9 FOLLOWS     
#> 10 REVIEWED
# Get index 
con$get_index()
#>         label property_keys
#> 1:       Band          name
#> 2:     Author          name
#> 3:     artist          name
#> 4:       City          name
#> 5: Maintainer          name
#> 6:    Package          name
#> 7:     record          name
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
  - `type` : “rows” or “graph”: whether to return the results as a list
    of results in tibble, or as a graph object (with `$nodes` and
    `$relationships`)
  - `output` : the output format (R or json)
  - `include_stats` : whether or not to include the stats about the call
  - `meta` : whether or not to include the meta arguments of the nodes
    when calling with “rows”

### “rows” format

The user chooses whether or not to return a list of tibbles when calling
the API. You get as many objects as specified in the RETURN cypher
statement.

``` r
library(magrittr)

'MATCH (r:record) -[:WAS_RECORDED] -> (b:Band) where b.formed = 1991 RETURN *;' %>%
  call_neo4j(con)
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
#>  1    1993 Filosofem                    
#>  2    1992 Hvis lyset tar oss           
#>  3    1992 Aske                         
#>  4    1992 Det som engang var           
#>  5    1992 Burzum                       
#>  6    1991 Demo II                      
#>  7    1991 Demo I                       
#>  8    1992 Hordanes Land                
#>  9    1993 Vikingligr Veldi             
#> 10    1991 Nema                         
#> 11    1992 Yggdrasill                   
#> 12    1992 Diabolical Fullmoon Mysticism
#> 13    1993 Pure Holocaust               
#> 14    1991 Immortal                     
#> 
#> attr(,"class")
#> [1] "neo"  "neo"  "list"
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
#>           "release": [1993],
#>           "name": ["Filosofem"]
#>         }
#>       ],
#>       "meta": [
#>         {
#>           "id": [16020],
#>           "type": ["node"],
#>           "deleted": [false]
#>         },
#>         {
#>           "id": [16058],
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
#> # A tibble: 17 x 3
#>    id    label     properties
#>    <chr> <list>    <list>    
#>  1 16020 <chr [1]> <list [2]>
#>  2 16058 <chr [1]> <list [2]>
#>  3 16053 <chr [1]> <list [2]>
#>  4 16051 <chr [1]> <list [2]>
#>  5 16045 <chr [1]> <list [2]>
#>  6 16044 <chr [1]> <list [2]>
#>  7 16042 <chr [1]> <list [2]>
#>  8 16039 <chr [1]> <list [2]>
#>  9 16055 <chr [1]> <list [2]>
#> 10 16024 <chr [1]> <list [2]>
#> 11 16060 <chr [1]> <list [2]>
#> 12 16043 <chr [1]> <list [2]>
#> 13 16049 <chr [1]> <list [2]>
#> 14 16027 <chr [1]> <list [2]>
#> 15 16046 <chr [1]> <list [2]>
#> 16 16066 <chr [1]> <list [2]>
#> 17 16041 <chr [1]> <list [2]>
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
#> # A tibble: 17 x 5
#>    id    value  name                          formed release
#>    <chr> <chr>  <chr>                          <int>   <int>
#>  1 16020 Band   Burzum                          1991      NA
#>  2 16058 record Filosofem                         NA    1993
#>  3 16053 record Hvis lyset tar oss                NA    1992
#>  4 16051 record Aske                              NA    1992
#>  5 16045 record Det som engang var                NA    1992
#>  6 16044 record Burzum                            NA    1992
#>  7 16042 record Demo II                           NA    1991
#>  8 16039 record Demo I                            NA    1991
#>  9 16055 record Hordanes Land                     NA    1992
#> 10 16024 Band   Enslaved                        1991      NA
#> 11 16060 record Vikingligr Veldi                  NA    1993
#> 12 16043 record Nema                              NA    1991
#> 13 16049 record Yggdrasill                        NA    1992
#> 14 16027 Band   Immortal                        1991      NA
#> 15 16046 record Diabolical Fullmoon Mysticism     NA    1992
#> 16 16066 record Pure Holocaust                    NA    1993
#> 17 16041 record Immortal                          NA    1991
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
#>  1 16020 <chr [1]> Burzum                          1991      NA
#>  2 16058 <chr [1]> Filosofem                         NA    1993
#>  3 16053 <chr [1]> Hvis lyset tar oss                NA    1992
#>  4 16051 <chr [1]> Aske                              NA    1992
#>  5 16045 <chr [1]> Det som engang var                NA    1992
#>  6 16044 <chr [1]> Burzum                            NA    1992
#>  7 16042 <chr [1]> Demo II                           NA    1991
#>  8 16039 <chr [1]> Demo I                            NA    1991
#>  9 16055 <chr [1]> Hordanes Land                     NA    1992
#> 10 16024 <chr [1]> Enslaved                        1991      NA
#> 11 16060 <chr [1]> Vikingligr Veldi                  NA    1993
#> 12 16043 <chr [1]> Nema                              NA    1991
#> 13 16049 <chr [1]> Yggdrasill                        NA    1992
#> 14 16027 <chr [1]> Immortal                        1991      NA
#> 15 16046 <chr [1]> Diabolical Fullmoon Mysticism     NA    1992
#> 16 16066 <chr [1]> Pure Holocaust                    NA    1993
#> 17 16041 <chr [1]> Immortal                          NA    1991
```

``` r
res$nodes %>%
  unnest_nodes(what = "label")
#> # A tibble: 17 x 3
#>    id    properties value 
#>    <chr> <list>     <chr> 
#>  1 16020 <list [2]> Band  
#>  2 16058 <list [2]> record
#>  3 16053 <list [2]> record
#>  4 16051 <list [2]> record
#>  5 16045 <list [2]> record
#>  6 16044 <list [2]> record
#>  7 16042 <list [2]> record
#>  8 16039 <list [2]> record
#>  9 16055 <list [2]> record
#> 10 16024 <list [2]> Band  
#> 11 16060 <list [2]> record
#> 12 16043 <list [2]> record
#> 13 16049 <list [2]> record
#> 14 16027 <list [2]> Band  
#> 15 16046 <list [2]> record
#> 16 16066 <list [2]> record
#> 17 16041 <list [2]> record
```

  - `unnest_relationships()`

There is only one nested column in the relationship table, thus the
function is quite straightforward :

``` r
unnest_relationships(res$relationships)
#> # A tibble: 14 x 5
#>    id    type         startNode endNode value
#>    <chr> <chr>        <chr>     <chr>   <lgl>
#>  1 23757 WAS_RECORDED 16058     16020   NA   
#>  2 23756 WAS_RECORDED 16053     16020   NA   
#>  3 23755 WAS_RECORDED 16051     16020   NA   
#>  4 23754 WAS_RECORDED 16045     16020   NA   
#>  5 23753 WAS_RECORDED 16044     16020   NA   
#>  6 23752 WAS_RECORDED 16042     16020   NA   
#>  7 23751 WAS_RECORDED 16039     16020   NA   
#>  8 23766 WAS_RECORDED 16055     16024   NA   
#>  9 23767 WAS_RECORDED 16060     16024   NA   
#> 10 23764 WAS_RECORDED 16043     16024   NA   
#> 11 23765 WAS_RECORDED 16049     16024   NA   
#> 12 23762 WAS_RECORDED 16046     16027   NA   
#> 13 23763 WAS_RECORDED 16066     16027   NA   
#> 14 23761 WAS_RECORDED 16041     16027   NA
```

  - `unnest_graph`

This function takes a graph results, and does `unnest_nodes` and
`unnest_relationships`.

``` r
unnest_graph(res)
#> $nodes
#> # A tibble: 17 x 5
#>    id    value  name                          formed release
#>    <chr> <chr>  <chr>                          <int>   <int>
#>  1 16020 Band   Burzum                          1991      NA
#>  2 16058 record Filosofem                         NA    1993
#>  3 16053 record Hvis lyset tar oss                NA    1992
#>  4 16051 record Aske                              NA    1992
#>  5 16045 record Det som engang var                NA    1992
#>  6 16044 record Burzum                            NA    1992
#>  7 16042 record Demo II                           NA    1991
#>  8 16039 record Demo I                            NA    1991
#>  9 16055 record Hordanes Land                     NA    1992
#> 10 16024 Band   Enslaved                        1991      NA
#> 11 16060 record Vikingligr Veldi                  NA    1993
#> 12 16043 record Nema                              NA    1991
#> 13 16049 record Yggdrasill                        NA    1992
#> 14 16027 Band   Immortal                        1991      NA
#> 15 16046 record Diabolical Fullmoon Mysticism     NA    1992
#> 16 16066 record Pure Holocaust                    NA    1993
#> 17 16041 record Immortal                          NA    1991
#> 
#> $relationships
#> # A tibble: 14 x 5
#>    id    type         startNode endNode value
#>    <chr> <chr>        <chr>     <chr>   <lgl>
#>  1 23757 WAS_RECORDED 16058     16020   NA   
#>  2 23756 WAS_RECORDED 16053     16020   NA   
#>  3 23755 WAS_RECORDED 16051     16020   NA   
#>  4 23754 WAS_RECORDED 16045     16020   NA   
#>  5 23753 WAS_RECORDED 16044     16020   NA   
#>  6 23752 WAS_RECORDED 16042     16020   NA   
#>  7 23751 WAS_RECORDED 16039     16020   NA   
#>  8 23766 WAS_RECORDED 16055     16024   NA   
#>  9 23767 WAS_RECORDED 16060     16024   NA   
#> 10 23764 WAS_RECORDED 16043     16024   NA   
#> 11 23765 WAS_RECORDED 16049     16024   NA   
#> 12 23762 WAS_RECORDED 16046     16027   NA   
#> 13 23763 WAS_RECORDED 16066     16027   NA   
#> 14 23761 WAS_RECORDED 16041     16027   NA   
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
#> 1 16020 <chr [1]> <list [2]>
#> 2 16058 <chr [1]> <list [2]>
#> 3 16053 <chr [1]> <list [2]>
#> 4 16051 <chr [1]> <list [2]>
#> 5 16045 <chr [1]> <list [2]>
#> 6 16044 <chr [1]> <list [2]>
```

``` r
'MATCH p=()-[w:WAS_RECORDED]->() RETURN p LIMIT 5;' %>%
  call_neo4j(con, type = "graph") %>% 
  extract_relationships()
#> # A tibble: 5 x 5
#>   id    type         startNode endNode properties
#>   <chr> <chr>        <chr>     <chr>   <list>    
#> 1 23757 WAS_RECORDED 16058     16020   <list [0]>
#> 2 23756 WAS_RECORDED 16053     16020   <list [0]>
#> 3 23755 WAS_RECORDED 16051     16020   <list [0]>
#> 4 23754 WAS_RECORDED 16045     16020   <list [0]>
#> 5 23753 WAS_RECORDED 16044     16020   <list [0]>
```

## Convert for common graph packages

### {igraph}

In order to be converted into a graph object:

  - The nodes should be a dataframe with the first column being a series
    of unique ID, understood as “names” by igraph - these are the ID
    columns from Neo4J. Other columns are considered attributes.

  - relationships need a start and an end, *i.e.* startNode and endNode
    in the Neo4J results.

Here how to create a graph object from a `{neo4r}`
result:

``` r
G <- "MATCH a=(p:Person {name: 'Tom Hanks'})-[r:ACTED_IN]->(m:Movie) RETURN a;" %>% 
  call_neo4j(con, type = "graph") 

library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(purrr)
#> 
#> Attaching package: 'purrr'
#> The following object is masked from 'package:magrittr':
#> 
#>     set_names
# Create a dataframe with col 1 being the ID, 
# And columns 2 being the names
G$nodes <- G$nodes %>%
  unnest_nodes(what = "properties") %>% 
  # We're extracting the first label of each node, but 
  # this column can also be removed if not needed
  mutate(label = map_chr(label, 1))
head(G$nodes)
#> # A tibble: 6 x 7
#>   id    label   born name    tagline                    title      released
#>   <chr> <chr>  <int> <chr>   <chr>                      <chr>         <int>
#> 1 16149 Person  1956 Tom Ha… <NA>                       <NA>             NA
#> 2 16189 Movie     NA <NA>    Break The Codes            The Da Vi…     2006
#> 3 16208 Movie     NA <NA>    Walk a mile you'll never … The Green…     1999
#> 4 16228 Movie     NA <NA>    At the edge of the world,… Cast Away      2000
#> 5 16222 Movie     NA <NA>    Houston, we have a proble… Apollo 13      1995
#> 6 16240 Movie     NA <NA>    Once in a lifetime you ge… A League …     1992
```

We then reorder the relationnship table:

``` r
G$relationships <- G$relationships %>%
  unnest_relationships() %>%
  select(startNode, endNode, type, everything())
head(G$relationships)
#> # A tibble: 6 x 5
#>   startNode endNode type     id    roles             
#>   <chr>     <chr>   <chr>    <chr> <chr>             
#> 1 16149     16189   ACTED_IN 23940 Dr. Robert Langdon
#> 2 16149     16208   ACTED_IN 23996 Paul Edgecomb     
#> 3 16149     16228   ACTED_IN 24027 Chuck Noland      
#> 4 16149     16222   ACTED_IN 24016 Jim Lovell        
#> 5 16149     16240   ACTED_IN 24048 Jimmy Dugan       
#> 6 16149     16239   ACTED_IN 24046 Hero Boy
```

``` r
graph_object <- igraph::graph_from_data_frame(
  d = G$relationships, 
  directed = TRUE, 
  vertices = G$nodes
)
plot(graph_object)
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%" />

This can also be used with `{ggraph}` :

``` r
library(ggraph)
#> Loading required package: ggplot2
graph_object %>%
  ggraph() + 
  geom_node_label(aes(label = label)) +
  geom_edge_link() + 
  theme_graph()
#> Using `nicely` as default layout
```

<img src="man/figures/README-unnamed-chunk-18-1.png" width="100%" />

### {visNetwork}

`{visNetwork}` expects the following format :

#### nodes

  - “id” : id of the node, needed in edges information
  - “label” : label of the node
  - “group” : group of the node. Groups can be configure with visGroups
  - “value” : size of the node
  - “title” : tooltip of the node

#### edges

  - “from” : node id of begin of the edge
  - “to” : node id of end of the edge
  - “label” : label of the edge
  - “value” : size of the node
  - “title” : tooltip of the node

(from `?visNetwork::visNetwork`).

`visNetwork` is smart enough to transform a list column into several
label, so we don’t have to worry too much about this one.

Here’s how to convert our `{neo4r}`
result:

``` r
G <-"MATCH a=(p:Person {name: 'Tom Hanks'})-[r:ACTED_IN]->(m:Movie) RETURN a;" %>% 
  call_neo4j(con, type = "graph") 

# We'll just unnest the properties
G$nodes <- G$nodes %>%
  unnest_nodes(what = "properties")
head(G$nodes)  

# Turn the relationships :
G$relationships <- G$relationships %>%
  unnest_relationships() %>%
  select(from = startNode, to = endNode, label = type)
head(G$relationships)

visNetwork::visNetwork(G$nodes, G$relationships)
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
  - `header` : whether or not the csv has a header
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
#>         label       type property_keys
#> 1:       Band UNIQUENESS          name
#> 2:     record UNIQUENESS          name
#> 3:     Author UNIQUENESS          name
#> 4:       City UNIQUENESS          name
#> 5:     artist UNIQUENESS          name
#> 6:    Package UNIQUENESS          name
#> 7: Maintainer UNIQUENESS          name
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
#> # … with 2,357 more rows
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
#> # … with 2,357 more rows
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
#> 
#> attr(,"class")
#> [1] "neo"  "list"
```

## Sandboxing in Docker

You can get an RStudio / Neo4J sandbox with Docker :

    docker pull colinfay/neo4r-docker
    docker run -e PASSWORD=plop -e ROOT=TRUE -d -p 8787:8787 neo4r

## CoC

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
