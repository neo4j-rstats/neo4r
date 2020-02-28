context("test-context-nba")

# From https://portal.graphgist.org/graph_gists/nba-playoff-prediction/source

play_movies() %>% call_neo4j(con)

test_that("query movies tests", {
  req_and_expect(
    req = 'MATCH (tom {name: "Tom Hanks"}) RETURN tom',
    con = con,
    is = "list",
    length = 1,
    names = c("tom")
  )

  req_and_expect(
    req = 'MATCH (t:Team {Name: "Golden State"})-[w:WIN]->(:Playoff)<-[l:WIN]-()
RETURN t,w,l',
    con = con,
    is = "list",
    length = 3,
    names = c("t", "w", "l")
  )

  req_and_expect(
    req = "MATCH (t:Team)-[w:WIN]->(:Playoff)<-[l:WIN]-()\nRETURN t.Name as TEAM, SUM(w.Win) AS TOTAL_WIN, SUM(l.Win) as TOTAL_LOSS,\n(toFloat(SUM(w.Win)) / (toFloat(SUM(w.Win))+ toFloat(SUM(l.Win)))) as WIN_PERCENTAGE\nORDER BY SUM(w.Win) DESC",
    con = con,
    is = "list",
    length = 4,
    names = c("TEAM", "TOTAL_WIN", "TOTAL_LOSS", "WIN_PERCENTAGE")
  )

  req_and_expect(
    req = 'MATCH (t1:Team {Name: "Miami"})-[r1:WIN]->(p:Playoff)<-[r2:WIN]-(t2:Team {Name:"San Antonio"})
RETURN t1,r1,p,r2,t2',
    con = con,
    is = "list",
    length = 5,
    names = c("t1", "r1", "p", "r2", "t2")
  )
  req_and_expect(
    req = 'MATCH (t1:Team {Name: "Miami"})-[r1:WIN]->(p:Playoff)<-[r2:WIN]-(t2:Team {Name:"San Antonio"})
RETURN p.Year as Year,r1.Win as Miami,r2.Win as San_Antonio
ORDER BY p.Year DESC',
    con = con,
    is = "list",
    length = 3,
    names = c("Year", "Miami", "San_Antonio")
  )
  req_and_expect(
    req = 'MATCH (t1:Team {Name: "Miami"}),(t2:Team {Name:"Portland"}),
	p = AllshortestPaths((t1)-[*..14]-(t2))
RETURN p',
    con = con,
    is = "list",
    length = 1,
    names = c("p")
  )

  req_and_expect_graph(
    req = 'MATCH (t1:Team {Name: "Miami"}),(t2:Team {Name:"Portland"}), p = AllshortestPaths((t1)-[*..14]-(t2)) RETURN p', con = con
  )
  # Array type
  req_and_expect(
    req = 'MATCH p= AllShortestPaths((t1:Team {Name: "Miami"})-[:WIN*0..14]-(t2:Team {Name:"Portland"}))
WITH extract(r IN relationships(p)| r.Win) AS RArray
RETURN RArray',
    con = con,
    is = "list",
    length = 1,
    names = c("RArray")
  )

  req_and_expect(
    req = 'MATCH (t1:Team {Name: "Golden State"}),(t2:Team {Name:"Toronto"}),
	p = AllshortestPaths((t1)-[*..14]-(t2))
RETURN p',
    con = con,
    is = "list",
    length = 1,
    names = c("p")
  )
  req_and_expect(
    req = 'MATCH (t1:Team {Name: "Golden State"}),(t2:Team {Name:"Toronto"}),
	p = AllshortestPaths((t1)-[r:WIN*..14]-(t2))
WITH r,p,extract(r IN relationships(p)| r.Win ) AS paths
RETURN paths',
    con = con,
    is = "list",
    length = 1,
    names = c("paths")
  )
  req_and_expect(
    req = 'MATCH p= AllShortestPaths((t1:Team {Name: "Golden State"})-[:WIN*0..14]-(t2:Team {Name:"Toronto"}))
WITH extract(r IN relationships(p)| r.Win) AS RArray, LENGTH(p)-1  as s
RETURN AVG(REDUCE(x = 0, a IN [i IN range(0,s) WHERE i % 2 = 0 | RArray[i] ] | x + a)) - AVG(REDUCE(x = 0, a IN [i IN range(0,s) WHERE i % 2 <> 0 | RArray[i] ] | x + a)) AS NET_WIN',
    con = con,
    is = "list",
    length = 1,
    names = c("NET_WIN")
  )

})
