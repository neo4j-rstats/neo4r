CREATE CONSTRAINT ON (p:Band) ASSERT p.name IS UNIQUE;
CREATE CONSTRAINT ON (p:City) ASSERT p.name IS UNIQUE;
CREATE CONSTRAINT ON (p:record) ASSERT p.name IS UNIQUE;
CREATE CONSTRAINT ON (p:artist) ASSERT p.name IS UNIQUE;
CREATE
  (ancient:Band {name: 'Ancient' ,formed: 1992}),
  (acturus:Band {name: 'Arcturus' ,formed: 1991}),
  (burzum:Band {name: 'Burzum' ,formed: 1991}),
  (carpathianforest:Band {name: 'Carpathian Forest' ,formed: 1990}),
  (darkthrone:Band {name: 'Darkthrone' ,formed: 1986}),
  (emperor:Band {name: 'Emperor' ,formed: 1986}),
  (enslaved:Band {name: 'Enslaved' ,formed: 1991}),
  (gorgoroth:Band {name: 'Gorgoroth' ,formed: 1992}),
  (hades:Band {name: 'Hades' ,formed: 1992}),
  (immortal:Band {name: 'Immortal' ,formed: 1991}),
  (mayhem:Band {name: 'Mayhem' ,formed: 1984}),
  (satyricon:Band {name: 'Satyricon' ,formed: 1984}),
  (taake:Band {name: 'Taake' ,formed: 1993}),
  (bergen:City {name: 'Bergen'}),
  (oslo:City {name: 'Oslo'}),
  (sandnes:City {name: 'Sandnes'}),
  (rogaland:City {name: 'Rogaland'}),
  (deathcrush:record {name: 'Deathcrush' ,release: 1987}),
  (freezingmoon:record {name: 'Freezing Moon' ,release: 1987}),
  (carnage:record {name: 'Carnage' ,release: 1990}),
  (liveinleipzig:record {name: 'Live in Leipzig' ,release: 1990}),
  (demoi:record {name: 'Demo I' ,release: 1991}),
  (ablaze:record {name: 'A Blaze in the Northern Sky' ,release: 1991}),
  (immortal_rec:record {name: 'Immortal' ,release: 1991}),
  (demoii:record {name: 'Demo I' ,release: 1991}),
  (nema:record {name: 'Nema' ,release: 1991}),
  (burzum_rec:record {name: 'Burzum' ,release: 1992}),
  (detsom:record {name: 'Det som engang var' ,release: 1992}),
  (diabolical:record {name: 'Diabolical Fullmoon Mysticism' ,release: 1992}),
  (wrath:record {name: 'Wrath of the Tyrant' ,release: 1992}),
  (all_evil:record {name: 'All Evil' ,release: 1992}),
  (yggdrasill:record {name: 'Yggdrasill' ,release: 1992}),
  (funeral_moon:record {name: 'Under a Funeral Moon' ,release: 1992}),
  (aske:record {name: 'Aske' ,release: 1992}),
  (bloodlust:record {name: 'Bloodlust & Perversion' ,release: 1992}),
  (hvis:record {name: 'Hvis lyset tar oss' ,release: 1992}),
  (demys:record {name: 'De Mysteriis Dom Sathanas' ,release: 1992}),
  (hordanes:record {name: 'Hordanes Land' ,release: 1992}),
  (emperor_rec:record {name: 'Emperor' ,release: 1992}),
  (as_the_shadow:record {name: 'As the Shadows Rise' ,release: 1992}),
  (filosofem:record {name: 'Filosofem' ,release: 1993}),
  (theforest:record {name: 'The Forest Is My Throne' ,release: 1993}),
  (viking:record {name: 'Vikingligr Veldi' ,release: 1993}),
  (journey:record {name: 'Journey Through the Cold' ,release: 1993}),
  (moors:record {name: 'Moors of Svarttjern' ,release: 1993}),
  (asorcery:record {name: 'A Sorcery Written in Blood' ,release: 1993}),
  (inthenightside:record {name: 'In the Nightside Eclipse' ,release: 1993}),
  (darkmed:record {name: 'Dark Medieval Times' ,release: 1993}),
  (pureho:record {name: 'Pure Holocaust' ,release: 1993}),
  (trans:record {name: 'Transilvanian Hunger' ,release: 1993}),
  (euronymous:artist {name: 'Euronymous' ,born: 1968}),
  (vikernes:artist {name: 'Vikernes' ,born: 1973}),
  (fenriz:artist {name: 'Fenriz' ,born: 1971}),
  (gaahl:artist {name: 'Gaahl' ,born: 1975}),
  (euronymous)-[:PLAYED_IN]->(mayhem),
  (vikernes)-[:PLAYED_IN]->(burzum),
  (fenriz)-[:PLAYED_IN]->(Darkthrone),
  (gaahl)-[:PLAYED_IN]->(gorgoroth),
  (ancient)-[:IS_FROM]->(bergen),
  (acturus)-[:IS_FROM]->(oslo),
  (burzum)-[:IS_FROM]->(bergen),
  (carpathianforest)-[:IS_FROM]->(rogaland),
  (emperor)-[:IS_FROM]->(sandnes),
  (enslaved)-[:IS_FROM]->(rogaland),
  (gorgoroth)-[:IS_FROM]->(bergen),
  (hades)-[:IS_FROM]->(bergen),
  (immortal)-[:IS_FROM]->(bergen),
  (mayhem)-[:IS_FROM]->(oslo),
  (satyricon)-[:IS_FROM]->(oslo),
  (taake)-[:IS_FROM]->(bergen),
  (deathcrush)-[:WAS_RECORDED]->(mayhem),
  (freezingmoon)-[:WAS_RECORDED]->(mayhem),
  (carnage)-[:WAS_RECORDED]->(mayhem),
  (liveinleipzig)-[:WAS_RECORDED]->(mayhem),
  (demys)-[:WAS_RECORDED]->(mayhem),
  (demoi)-[:WAS_RECORDED]->(burzum),
  (demoii)-[:WAS_RECORDED]->(burzum),
  (burzum_rec)-[:WAS_RECORDED]->(burzum),
  (detsom)-[:WAS_RECORDED]->(burzum),
  (aske)-[:WAS_RECORDED]->(burzum),
  (hvis)-[:WAS_RECORDED]->(burzum),
  (filosofem)-[:WAS_RECORDED]->(burzum),
  (ablaze)-[:WAS_RECORDED]->(darkthrone),
  (funeral_moon)-[:WAS_RECORDED]->(darkthrone),
  (trans)-[:WAS_RECORDED]->(darkthrone),
  (immortal_rec)-[:WAS_RECORDED]->(immortal),
  (diabolical)-[:WAS_RECORDED]->(immortal),
  (pureho)-[:WAS_RECORDED]->(immortal),
  (nema)-[:WAS_RECORDED]->(enslaved),
  (yggdrasill)-[:WAS_RECORDED]->(enslaved),
  (hordanes)-[:WAS_RECORDED]->(enslaved),
  (viking)-[:WAS_RECORDED]->(enslaved),
  (wrath)-[:WAS_RECORDED]->(emperor),
  (all_evil)-[:WAS_RECORDED]->(satyricon),
  (theforest)-[:WAS_RECORDED]->(satyricon),
  (darkmed)-[:WAS_RECORDED]->(satyricon),
  (bloodlust)-[:WAS_RECORDED]->(carpathianforest),
  (journey)-[:WAS_RECORDED]->(carpathianforest),
  (moors)-[:WAS_RECORDED]->(carpathianforest),
  (emperor_rec)-[:WAS_RECORDED]->(emperor),
  (as_the_shadow)-[:WAS_RECORDED]->(emperor),
  (inthenightside)-[:WAS_RECORDED]->(emperor),
  (asorcery)-[:WAS_RECORDED]->(gorgoroth);
CREATE CONSTRAINT ON (p:Person) ASSERT p.name IS UNIQUE;
MATCH (band:Band) WHERE band.formed < 1995 RETURN *;
MATCH (b:Band) WHERE b.formed = 1990 RETURN *;
MATCH (b:Band {formed: 1990}) RETURN *;
MATCH (b:Band) WHERE b.formed < 1995 RETURN *;
MATCH (r:record) WHERE r.name CONTAINS 'Demo' RETURN *;
MATCH (r:record) -[w:WAS_RECORDED] -> (b:Band) RETURN b , r, w LIMIT 2;
MATCH (r:record) -[:WAS_RECORDED] -> (b:Band) where b.formed = 1991 RETURN *;
MATCH (band:Band) -[f:IS_FROM] -> (city:City) RETURN band, city, f LIMIT 2;
MATCH (r:record) -[:WAS_RECORDED] -> (b:Band) RETURN r.name AS albums, b.name AS name;
MATCH (r:record) WHERE r.release = 1993 RETURN COUNT(*) AS how_much;
MATCH (r:Band) -[f:IS_FROM] -> (c:City {name:'Bergen'}) RETURN COUNT(*) AS Bergen_band;
MATCH (r:record) -[:WAS_RECORDED] -> (b:Band) where b.name = 'Burzum' RETURN COUNT(*) ;
MATCH (:record) -[:WAS_RECORDED] -> (:Band) -[:IS_FROM]-> (:City {name:'Bergen'}) RETURN COUNT(*) AS bergenrecords;
CREATE CONSTRAINT ON (p:Movie) ASSERT p.title IS UNIQUE;
CREATE CONSTRAINT ON (p:Person) ASSERT p.name IS UNIQUE;
CREATE CONSTRAINT ON (p:Year) ASSERT p.year IS UNIQUE;
CREATE CONSTRAINT ON (p:artist) ASSERT p.name IS UNIQUE;
CREATE (:Movie { title:'The Matrix;released:1997 });
CREATE (p:Person { name:"Keanu Reeves', born:1964 })
RETURN p;
CREATE (a:Person { name:"Tom Hanks", born:1956 })-[r:ACTED_IN { roles: ["Forrest"]}]->(:Movie { title:"Forrest Gump",released:1994 })
CREATE (d:Person { name:"Robert Zemeckis", born:1951 })-[:DIRECTED]->(m)
RETURN a,d,r,m;
MATCH (m:Movie)
RETURN m;
MATCH (p:Person { name:"Keanu Reeves" })
RETURN p;
MATCH (p:Person { name:"Tom Hanks" })
CREATE (m:Movie { title:"Cloud Atlas", released:2012 })
CREATE (p)-[r:ACTED_IN { roles: ["Zachry"]}]->(m)
RETURN p,r,m;
MERGE (m:Movie { title:"Cloud Atlas" })
ON CREATE SET m.released = 2012
RETURN m;
MATCH (m:Movie { title:"Cloud Atlas" })
MATCH (p:Person { name:"Tom Hanks" })
MERGE (p)-[r:ACTED_IN]->(m)
ON CREATE SET r.roles =["Zachry"]
RETURN p,r,m;
CREATE (y:Year { year:2014 })
MERGE (y)<-[:IN_YEAR]-(m10:Month { month:10 })
MERGE (y)<-[:IN_YEAR]-(m11:Month { month:11 })
RETURN y,m10,m11;
CREATE (matrix:Movie { title:"The Matrix", released:1997 })
CREATE (cloudAtlas:Movie { title:"Cloud Atlas", released:2012 })
CREATE (forrestGump:Movie { title:"Forrest Gump", released:1994 })
CREATE (keanu:Person { name:"Keanu Reeves", born:1964 })
CREATE (robert:Person { name:"Robert Zemeckis", born:1951 })
CREATE (tom:Person { name:"Tom Hanks; born:1956 })
CREATE (tom)-[:ACTED_IN { roles: ["Forrest"]}]->(forrestGump)
CREATE (tom)-[:ACTED_IN { roles: ["Zachry"]}]->(cloudAtlas)
CREATE (robert)-[:DIRECTED]->(forrestGump);
MATCH (m:Movie)
WHERE m.title = "The Matrix"
RETURN m;
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE p.name =~ "K.+" OR m.released > 2000 OR "Neo" IN r.roles
RETURN p,r,m;
MATCH (p:Person)
RETURN p, p.name AS name, toUpper(p.name), coalesce(p.nickname,"n/a") AS nickname, { name: p.name, label:head(labels(p))} AS person;
MATCH (:Person)
RETURN count(*) AS people;
MATCH (actor:Person)-[:ACTED_IN]->(movie:Movie)<-[:DIRECTED]-(director:Person)
RETURN actor,director,count(*) AS collaborations;
MATCH (a:Person)-[act:ACTED_IN]->(m:Movie)
RETURN a,act,m;
MATCH (actor:Person)-[r:ACTED_IN]->(movie:Movie)
RETURN actor.name AS name, type(r) AS acted_in, movie.title AS title
UNION
MATCH (director:Person)-[r:DIRECTED]->(movie:Movie)
RETURN director.name AS name, type(r) AS acted_in, movie.title AS title;'MATCH (p:Person { name:"Tom Hanks" })-[r:ACTED_IN]->(m:Movie)
RETURN m.title, r.roles;
MATCH (person:Person)-[:ACTED_IN]->(m:Movie)
WITH person, count(*) AS appearances, collect(m.title) AS movies
WHERE appearances > 1
RETURN person.name, appearances, movies;
MATCH (m:Movie)<-[:ACTED_IN]-(a:Person)
RETURN m.title AS movie, collect(a.name) AS cast, count(*) AS actors;
CREATE (p:Person {name: "Colin"}),(l:Language {name: "r"}),(p) -[:PROGRAMS_IN]->(l) RETURN p.name AS who, l.name AS what;
MATCH (p:Person)-[:PROGRAMS_IN]->(l:Language), RETURN p.name AS who, l.name AS what;
MATCH (l:Language {name : "r"})
CREATE (v:Person {name: "Vincent"}), (d:Person {name: "Diane"}), (s:Person {name: "Seb"}),
CREATE (v)-[:PROGRAMS_IN]->(l)
CREATE (d)-[:PROGRAMS_IN]->(l)
CREATE (s)-[:PROGRAMS_IN]->(l)
MATCH (p:Person) RETURN COUNT(p);
CREATE CONSTRAINT ON (p:User) ASSERT p.name IS UNIQUE;
CREATE (adam:User { name: "Adam" }),(pernilla:User { name: "Pernilla" }),(david:User { name: "David"}),(adam)-[:FRIEND]->(pernilla),(pernilla)-[:FRIEND]->(david);
MATCH (user:User { name: 'Adam' })-[r1:FRIEND]-()-[r2:FRIEND]-(friend_of_a_friend)
RETURN friend_of_a_friend.name AS fofName;
MATCH (user:User { name: 'Adam' })-[r1:FRIEND]-(friend)
MATCH (friend)-[r2:FRIEND]-(friend_of_a_friend)
RETURN friend_of_a_friend.name AS fofName;
MATCH (user:User { name: 'Adam' })-[r1:FRIEND]-(friend),(friend)-[r2:FRIEND]-(friend_of_a_friend)
RETURN friend_of_a_friend.name AS fofName;
