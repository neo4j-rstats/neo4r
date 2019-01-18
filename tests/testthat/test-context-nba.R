context("test-context-nba")

# From https://portal.graphgist.org/graph_gists/nba-playoff-prediction/source

call_neo4j('CREATE (BOS:Team:E{Name: "Boston", Code: "BOS"})
CREATE (BKN:Team:E{Name: "Brooklyn", Code: "BKN"})
CREATE (NYK:Team:E{Name: "New York", Code: "NYK"})
CREATE (PHI:Team:E{Name: "Philadelphia", Code: "PHI"})
CREATE (TOR:Team:E{Name: "Toronto", Code: "TOR"})
CREATE (CHI:Team:E{Name: "Chicago", Code: "CHI"})
CREATE (CLE:Team:E{Name: "Cleveland", Code: "CLE"})
CREATE (DET:Team:E{Name: "Detroit", Code: "DET"})
CREATE (IND:Team:E{Name: "Indiana", Code: "IND"})
CREATE (MIL:Team:E{Name: "Milwaukee", Code: "MIL"})
CREATE (ATL:Team:E{Name: "Atlanta", Code: "ATL"})
CREATE (CHA:Team:E{Name: "Charlotte", Code: "CHA"})
CREATE (MIA:Team:E{Name: "Miami", Code: "MIA"})
CREATE (ORL:Team:E{Name: "Orlando", Code: "ORL"})
CREATE (WAS:Team:E{Name: "Washington", Code: "WAS"})
CREATE (DEN:Team:W{Name: "Denver", Code: "DEN"})
CREATE (MIN:Team:W{Name: "Minnesota", Code: "MIN"})
CREATE (OKC:Team:W{Name: "Oklahoma City", Code: "OKC"})
CREATE (POR:Team:W{Name: "Portland", Code: "POR"})
CREATE (UTA:Team:W{Name: "Utah", Code: "UTA"})
CREATE (GS:Team:W{Name: "Golden State", Code: "GS"})
CREATE (LAC:Team:W{Name: "L.A. Clippers", Code: "LAC"})
CREATE (LAL:Team:W{Name: "L.A. Lakers", Code: "LAL"})
CREATE (PHX:Team:W{Name: "Phoenix", Code: "PHX"})
CREATE (SAC:Team:W{Name: "Sacramento", Code: "SAC"})
CREATE (DAL:Team:W{Name: "Dallas", Code: "DAL"})
CREATE (HOU:Team:W{Name: "Houston", Code: "HOU"})
CREATE (MEM:Team:W{Name: "Memphis", Code: "MEM"})
CREATE (NOP:Team:W{Name: "New Orleans", Code: "NOP"})
CREATE (SA:Team:W{Name: "San Antonio", Code: "SA"})
CREATE (P201501:Playoff{Year: "2015", Round: "First Round"})
CREATE (P201502:Playoff{Year: "2015", Round: "First Round"})
CREATE (P201503:Playoff{Year: "2015", Round: "First Round"})
CREATE (P201504:Playoff{Year: "2015", Round: "First Round"})
CREATE (P201505:Playoff{Year: "2015", Round: "First Round"})
CREATE (P201506:Playoff{Year: "2015", Round: "First Round"})
CREATE (P201507:Playoff{Year: "2015", Round: "First Round"})
CREATE (P201508:Playoff{Year: "2015", Round: "First Round"})
CREATE (P201509:Playoff{Year: "2015", Round: "Conference Semifinals"})
CREATE (P201510:Playoff{Year: "2015", Round: "Conference Semifinals"})
CREATE (P201511:Playoff{Year: "2015", Round: "Conference Semifinals"})
CREATE (P201512:Playoff{Year: "2015", Round: "Conference Semifinals"})
CREATE (P201513:Playoff{Year: "2015", Round: "Conference Finals"})
CREATE (P201514:Playoff{Year: "2015", Round: "Conference Finals"})
CREATE (P201515:Playoff{Year: "2015", Round: "NBA Finals"})
CREATE (P201401:Playoff{Year: "2014", Round: "First Round"})
CREATE (P201402:Playoff{Year: "2014", Round: "First Round"})
CREATE (P201403:Playoff{Year: "2014", Round: "First Round"})
CREATE (P201404:Playoff{Year: "2014", Round: "First Round"})
CREATE (P201405:Playoff{Year: "2014", Round: "First Round"})
CREATE (P201406:Playoff{Year: "2014", Round: "First Round"})
CREATE (P201407:Playoff{Year: "2014", Round: "First Round"})
CREATE (P201408:Playoff{Year: "2014", Round: "First Round"})
CREATE (P201409:Playoff{Year: "2014", Round: "Conference Semifinals"})
CREATE (P201410:Playoff{Year: "2014", Round: "Conference Semifinals"})
CREATE (P201411:Playoff{Year: "2014", Round: "Conference Semifinals"})
CREATE (P201412:Playoff{Year: "2014", Round: "Conference Semifinals"})
CREATE (P201413:Playoff{Year: "2014", Round: "Conference Finals"})
CREATE (P201414:Playoff{Year: "2014", Round: "Conference Finals"})
CREATE (P201415:Playoff{Year: "2014", Round: "NBA Finals"})
CREATE (P201301:Playoff{Year: "2013", Round: "First Round"})
CREATE (P201302:Playoff{Year: "2013", Round: "First Round"})
CREATE (P201303:Playoff{Year: "2013", Round: "First Round"})
CREATE (P201304:Playoff{Year: "2013", Round: "First Round"})
CREATE (P201305:Playoff{Year: "2013", Round: "First Round"})
CREATE (P201306:Playoff{Year: "2013", Round: "First Round"})
CREATE (P201307:Playoff{Year: "2013", Round: "First Round"})
CREATE (P201308:Playoff{Year: "2013", Round: "First Round"})
CREATE (P201309:Playoff{Year: "2013", Round: "Conference Semifinals"})
CREATE (P201310:Playoff{Year: "2013", Round: "Conference Semifinals"})
CREATE (P201311:Playoff{Year: "2013", Round: "Conference Semifinals"})
CREATE (P201312:Playoff{Year: "2013", Round: "Conference Semifinals"})
CREATE (P201313:Playoff{Year: "2013", Round: "Conference Finals"})
CREATE (P201314:Playoff{Year: "2013", Round: "Conference Finals"})
CREATE (P201315:Playoff{Year: "2013", Round: "NBA Finals"})
CREATE (ATL)-[:WIN{Win:4}]->(P201501)
CREATE (BKN)-[:WIN{Win:2}]->(P201501)
CREATE (TOR)-[:WIN{Win:0}]->(P201502)
CREATE (WAS)-[:WIN{Win:4}]->(P201502)
CREATE (CHI)-[:WIN{Win:4}]->(P201503)
CREATE (MIL)-[:WIN{Win:2}]->(P201503)
CREATE (CLE)-[:WIN{Win:4}]->(P201504)
CREATE (BOS)-[:WIN{Win:0}]->(P201504)
CREATE (GS)-[:WIN{Win:4}]->(P201505)
CREATE (NOP)-[:WIN{Win:0}]->(P201505)
CREATE (POR)-[:WIN{Win:1}]->(P201506)
CREATE (MEM)-[:WIN{Win:4}]->(P201506)
CREATE (LAC)-[:WIN{Win:4}]->(P201507)
CREATE (SA)-[:WIN{Win:3}]->(P201507)
CREATE (HOU)-[:WIN{Win:4}]->(P201508)
CREATE (DAL)-[:WIN{Win:1}]->(P201508)
CREATE (ATL)-[:WIN{Win:4}]->(P201509)
CREATE (WAS)-[:WIN{Win:2}]->(P201509)
CREATE (CHI)-[:WIN{Win:2}]->(P201510)
CREATE (CLE)-[:WIN{Win:4}]->(P201510)
CREATE (GS)-[:WIN{Win:4}]->(P201511)
CREATE (MEM)-[:WIN{Win:2}]->(P201511)
CREATE (LAC)-[:WIN{Win:3}]->(P201512)
CREATE (HOU)-[:WIN{Win:4}]->(P201512)
CREATE (ATL)-[:WIN{Win:0}]->(P201513)
CREATE (CLE)-[:WIN{Win:4}]->(P201513)
CREATE (GS)-[:WIN{Win:4}]->(P201514)
CREATE (HOU)-[:WIN{Win:1}]->(P201514)
CREATE (CLE)-[:WIN{Win:2}]->(P201515)
CREATE (GS)-[:WIN{Win:4}]->(P201515)
CREATE (IND)-[:WIN{Win:4}]->(P201401)
CREATE (ATL)-[:WIN{Win:3}]->(P201401)
CREATE (CHI)-[:WIN{Win:1}]->(P201402)
CREATE (WAS)-[:WIN{Win:4}]->(P201402)
CREATE (TOR)-[:WIN{Win:3}]->(P201403)
CREATE (BKN)-[:WIN{Win:4}]->(P201403)
CREATE (MIA)-[:WIN{Win:4}]->(P201404)
CREATE (CHA)-[:WIN{Win:0}]->(P201404)
CREATE (SA)-[:WIN{Win:4}]->(P201405)
CREATE (DAL)-[:WIN{Win:3}]->(P201405)
CREATE (HOU)-[:WIN{Win:2}]->(P201406)
CREATE (POR)-[:WIN{Win:4}]->(P201406)
CREATE (LAC)-[:WIN{Win:4}]->(P201407)
CREATE (GS)-[:WIN{Win:3}]->(P201407)
CREATE (OKC)-[:WIN{Win:4}]->(P201408)
CREATE (MEM)-[:WIN{Win:3}]->(P201408)
CREATE (IND)-[:WIN{Win:4}]->(P201409)
CREATE (WAS)-[:WIN{Win:2}]->(P201409)
CREATE (BKN)-[:WIN{Win:1}]->(P201410)
CREATE (MIA)-[:WIN{Win:4}]->(P201410)
CREATE (SA)-[:WIN{Win:4}]->(P201411)
CREATE (POR)-[:WIN{Win:1}]->(P201411)
CREATE (LAC)-[:WIN{Win:2}]->(P201412)
CREATE (OKC)-[:WIN{Win:4}]->(P201412)
CREATE (IND)-[:WIN{Win:2}]->(P201413)
CREATE (MIA)-[:WIN{Win:4}]->(P201413)
CREATE (SA)-[:WIN{Win:4}]->(P201414)
CREATE (OKC)-[:WIN{Win:2}]->(P201414)
CREATE (MIA)-[:WIN{Win:1}]->(P201415)
CREATE (SA)-[:WIN{Win:4}]->(P201415)
CREATE (MIA)-[:WIN{Win:4}]->(P201301)
CREATE (MIL)-[:WIN{Win:0}]->(P201301)
CREATE (BKN)-[:WIN{Win:3}]->(P201302)
CREATE (CHI)-[:WIN{Win:4}]->(P201302)
CREATE (IND)-[:WIN{Win:4}]->(P201303)
CREATE (ATL)-[:WIN{Win:2}]->(P201303)
CREATE (NYK)-[:WIN{Win:4}]->(P201304)
CREATE (BOS)-[:WIN{Win:2}]->(P201304)
CREATE (OKC)-[:WIN{Win:4}]->(P201305)
CREATE (HOU)-[:WIN{Win:2}]->(P201305)
CREATE (LAC)-[:WIN{Win:2}]->(P201306)
CREATE (MEM)-[:WIN{Win:4}]->(P201306)
CREATE (DEN)-[:WIN{Win:2}]->(P201307)
CREATE (GS)-[:WIN{Win:4}]->(P201307)
CREATE (SA)-[:WIN{Win:4}]->(P201308)
CREATE (LAL)-[:WIN{Win:0}]->(P201308)
CREATE (MIA)-[:WIN{Win:4}]->(P201309)
CREATE (CHI)-[:WIN{Win:1}]->(P201309)
CREATE (IND)-[:WIN{Win:4}]->(P201310)
CREATE (NYK)-[:WIN{Win:2}]->(P201310)
CREATE (OKC)-[:WIN{Win:1}]->(P201311)
CREATE (MEM)-[:WIN{Win:4}]->(P201311)
CREATE (GS)-[:WIN{Win:2}]->(P201312)
CREATE (SA)-[:WIN{Win:4}]->(P201312)
CREATE (MIA)-[:WIN{Win:4}]->(P201313)
CREATE (IND)-[:WIN{Win:3}]->(P201313)
CREATE (MEM)-[:WIN{Win:0}]->(P201314)
CREATE (SA)-[:WIN{Win:4}]->(P201314)
CREATE (MIA)-[:WIN{Win:4}]->(P201315)
CREATE (SA)-[:WIN{Win:3}]->(P201315)', con)

test_that("query nba tests", {
  req_and_expect(
    req = 'MATCH (t)-[]->(p:Playoff)
    WHERE p.Year = "2015"
    RETURN t,p',
    con = con,
    is = "list",
    length = 2,
    names = c("t", "p")
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


  #   req <- call_neo4j('MATCH p= AllShortestPaths((t1:Team {Name: "Golden State"})-[:WIN*0..14]-(t2:Team {Name:"Toronto"}))
  # WITH extract(r IN relationships(p)| r.Win) AS RArray, LENGTH(p)-1  as s
  # RETURN AVG(REDUCE(x = 0, a IN [i IN range(0,s) WHERE i % 2 = 0 | RArray[i] ] | x + a)) - AVG(REDUCE(x = 0, a IN [i IN range(0,s) WHERE i % 2 <> 0 | RArray[i] ] | x + a)) AS NET_WIN', con)
  #   req
})
