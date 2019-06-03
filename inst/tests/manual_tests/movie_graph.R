system("docker run --name neo4j --publish=7474:7474 --publish=7687:7687 --volume=$HOME/neo4j/data:/data  --env=NEO4J_AUTH=none -d neo4j")
library(neo4r)
con <- neo4j_api$new(
  url = "http://localhost:7474",
  user = "neo4j",
  password = "neo4j"
)
con$ping()
play_movies() %>%
  call_neo4j(con)

queries <- c(
  'MATCH (tom {name: "Tom Hanks"}) RETURN tom',
  'MATCH (cloudAtlas {title: "Cloud Atlas"}) RETURN cloudAtlas',
  'MATCH (people:Person) RETURN people.name LIMIT 10',
  'MATCH (nineties:Movie) WHERE nineties.released >= 1990 AND nineties.released < 2000 RETURN nineties.title',
  'MATCH (nineties:Movie) WHERE nineties.released >= 1990 AND nineties.released < 2000 RETURN nineties.title',
  'MATCH (tom:Person {name: "Tom Hanks"})-[:ACTED_IN]->(tomHanksMovies) RETURN tom,tomHanksMovies',
  'MATCH (cloudAtlas {title: "Cloud Atlas"})<-[:DIRECTED]-(directors) RETURN directors.name',
  'MATCH (tom:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors) RETURN coActors.name',
  'MATCH (people:Person)-[relatedTo]-(:Movie {title: "Cloud Atlas"}) RETURN people.name, Type(relatedTo), relatedTo',
  'MATCH (bacon:Person {name:"Kevin Bacon"})-[*1..4]-(hollywood)
RETURN DISTINCT hollywood',
  'MATCH p=shortestPath(
  (bacon:Person {name:"Kevin Bacon"})-[*]-(meg:Person {name:"Meg Ryan"})
  ) RETURN p',
  'MATCH (tom:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors),
      (coActors)-[:ACTED_IN]->(m2)<-[:ACTED_IN]-(cocoActors)
WHERE NOT (tom)-[:ACTED_IN]->()<-[:ACTED_IN]-(cocoActors) AND tom <> cocoActors
RETURN cocoActors.name AS Recommended, count(*) AS Strength ORDER BY Strength DESC',
  'MATCH (tom:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors),
      (coActors)-[:ACTED_IN]->(m2)<-[:ACTED_IN]-(cruise:Person {name:"Tom Cruise"})
RETURN tom, m, coActors, m2, cruise',
  'MATCH (tom:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors),
      (coActors)-[:ACTED_IN]->(m2)<-[:ACTED_IN]-(cruise:Person {name:"Tom Cruise"})
RETURN tom, m, coActors, m2, cruise',
  'MATCH (n) RETURN n'
)

# Table
lapply(
  queries,
  function(x){
    cli::cat_rule("New query")
    a <- call_neo4j(x, con)
    print(a)
  }
)
# Graphs
lapply(
  queries,
  function(x){
    cli::cat_rule("New query")
    a <- call_neo4j(x, con, type = "graph")
    print(a)
  }
)

# Northwind graph

'LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/northwind/products.csv" AS row
CREATE (n:Product)
SET n = row,
  n.unitPrice = toFloat(row.unitPrice),
  n.unitsInStock = toInteger(row.unitsInStock), n.unitsOnOrder = toInteger(row.unitsOnOrder),
  n.reorderLevel = toInteger(row.reorderLevel), n.discontinued = (row.discontinued <> "0")' %>%
  call_neo4j(con)

'LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/northwind/categories.csv" AS row
CREATE (n:Category)
SET n = row' %>%
  call_neo4j(con)

'LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/northwind/suppliers.csv" AS row
CREATE (n:Supplier)
SET n = row' %>%
  call_neo4j(con)

'CREATE INDEX ON :Product(productID)' %>%
  call_neo4j(con)

'CREATE INDEX ON :Category(categoryID)' %>%
  call_neo4j(con)

'CREATE INDEX ON :Supplier(supplierID)' %>%
  call_neo4j(con)

queries <- c(
  'MATCH (p:Product),(c:Category)
WHERE p.categoryID = c.categoryID
CREATE (p)-[:PART_OF]->(c)',
  'MATCH (p:Product),(s:Supplier)
WHERE p.supplierID = s.supplierID
CREATE (s)-[:SUPPLIES]->(p)',
  'MATCH (c:Category {categoryName:"Produce"})<--(:Product)<--(s:Supplier)
RETURN DISTINCT s.companyName as ProduceSuppliers',
  'LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/northwind/customers.csv" AS row
CREATE (n:Customer)
SET n = row',
  'LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/northwind/orders.csv" AS row
CREATE (n:Order)
SET n = row',
  'CREATE INDEX ON :Customer(customerID)',
  'CREATE INDEX ON :Order(orderID)',
  'MATCH (c:Customer),(o:Order)
WHERE c.customerID = o.customerID
CREATE (c)-[:PURCHASED]->(o)',
  'LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/northwind/order-details.csv" AS row
MATCH (p:Product), (o:Order)
WHERE p.productID = row.productID AND o.orderID = row.orderID
CREATE (o)-[details:ORDERS]->(p)
SET details = row,
  details.quantity = toInteger(row.quantity)',
  'MATCH (cust:Customer)-[:PURCHASED]->(:Order)-[o:ORDERS]->(p:Product),
      (p)-[:PART_OF]->(c:Category {categoryName:"Produce"})
RETURN DISTINCT cust.contactName as CustomerName, SUM(o.quantity) AS TotalProductsPurchased'
)

# Table
lapply(
  queries,
  function(x){
    cli::cat_rule("New query")
    a <- call_neo4j(x, con)
    print(a)
  }
)
# Graphs
lapply(
  queries,
  function(x){
    cli::cat_rule("New query")
    a <- call_neo4j(x, con, type = "graph")
    print(a)
  }
)


system("docker kill neo4j && docker rm neo4j")
