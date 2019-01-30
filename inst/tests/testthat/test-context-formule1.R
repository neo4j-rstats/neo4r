# context("test-context-nba")
#
# # From https://portal.graphgist.org/graph_gists/formula-1-2013-season/source
#
# call_neo4j('CREATE (FAlonso:Driver { name : "Fernando Alonso", born :1981  })
# CREATE (SVettel:Driver { name : "Sebastian Vettel", born :1987 })
# CREATE (JButton:Driver { name : "Jenson Button", born : 1980})
# CREATE (LHamilton:Driver { name : "Lewis Hamilton", born :1985 })
# CREATE (KRaikkonen:Driver { name : "Kimi Raikkonen", born :1979 })
# CREATE (MWebber:Driver { name : "Mark Webber", born :1976 })
# CREATE (FelipeMassa:Driver { name : "Felipe Massa", born :1981 })
# CREATE (SergioP:Driver { name : "Sergio Pérez", born :1990 })
# CREATE (HeikkiKovalainen:Driver { name : "Heikki Kovalainen", born :1981 })
# CREATE (RomainGrosjean:Driver { name : "Romain Grosjean", born :1986 })
# CREATE (NicoRosberg:Driver { name : "Nico Rosberg", born :1985 })
# CREATE (NicoH:Driver { name : "Nico Hülkenberg", born :1987 })
# CREATE (EstebanG:Driver { name : "Esteban Gutiérrez", born :1991 })
# CREATE (PaulDiResta:Driver { name : "Paul di Resta", born :1986 })
# CREATE (AdrianSutil:Driver { name : "Adrian Sutil", born :1983 })
# CREATE (PastorMaldonado:Driver { name : "Pastor Maldonado", born :1985 })
# CREATE (ValtteriBottas:Driver { name : "Valtteri Bottas", born :1989 })
# CREATE (Vergne:Driver { name : "Jean-Éric Vergne", born :1990 })
# CREATE (DanielRicciardo:Driver { name : "Daniel Ricciardo", born :1989 })
# CREATE (CharlesPic:Driver { name : "Charles Pic", born :1990 })
# CREATE (GiedoGarde:Driver { name : "Giedo van der Garde", born :1985 })
# CREATE (JulesBianchi:Driver { name : "Jules Bianchi", born :1989 })
# CREATE (MaxChilton:Driver { name : "Max Chilton", born :1991 })
# CREATE (Spain:Country {name:"Spain"})
# CREATE (Germany:Country {name:"Germany"})
# CREATE (UnitedKingdom:Country {name:"United Kingdom"})
# CREATE (Finland:Country {name:"Finland"})
# CREATE (France:Country {name:"France"})
# CREATE (Brazil:Country {name:"Brazil"})
# CREATE (Mexico:Country {name:"Mexico"})
# CREATE (Italy:Country {name:"Italy"})
# CREATE (Venezuela:Country {name:"Venezuela"})
# CREATE (Netherlands:Country {name:"Netherlands"})
# CREATE (Australia:Country {name:"Australia"})
# CREATE (Austria:Country{name:"Austria"})
# CREATE (Switzerland:Country {name:"Switzerland"})
# CREATE (Russia:Country {name:"Russia"})
# CREATE (India:Country {name:"India"})
# CREATE (Malaysia:Country {name:"Malaysia"})
# CREATE (Canada:Country {name:"Canada"})
# CREATE (China:Country {name:"China"})
# CREATE (Bahrain:Country {name:"Bahrain"})
# CREATE (Monaco:Country {name:"Monaco"})
# CREATE (Belgium:Country {name:"Belgium"})
# CREATE (Hungary:Country {name:"Hungary"})
# CREATE (Singapore:Country {name:"Singapore"})
# CREATE (SouthKorea:Country {name:"South Korea"})
# CREATE (Japan:Country {name:"Japan"})
# CREATE (UnitedArabEmirates:Country {name:"United Arab Emirates"})
# CREATE (USA:Country {name:"USA"})
# CREATE(RedBull:Constructor {name:"Red Bull-Renault"})
# CREATE(Ferrari:Constructor {name:"Ferrari"})
# CREATE(McLarenMercedes:Constructor {name:"McLaren-Mercedes"})
# CREATE(Lotus:Constructor {name:"Lotus-Renault"})
# CREATE(Mercedes:Constructor {name:"Mercedes"})
# CREATE(Sauber:Constructor {name:"Sauber-Ferrari"})
# CREATE(ForceIndia:Constructor {name:"Force India-Mercedes"})
# CREATE(Williams:Constructor {name:"Williams-Renault"})
# CREATE(ToroRosso:Constructor {name:"Toro Rosso-Ferrari"})
# CREATE(Caterham:Constructor {name:"Caterham-Renault"})
# CREATE(Marussia:Constructor {name:"Marussia-Cosworth"})
# CREATE(RS272013:Engine {name:"Reanult RS27-2013"})
# CREATE(FerrariType056:Engine {name:"Ferrari Type 056"})
# CREATE(MercedesFO108Z:Engine {name:"Mercedes FO 108Z"})
# CREATE(CosworthCA2013:Engine {name:"CosworthCA2013"})
# CREATE(Melbourne:GrandPrix {city:"Melbourne",meters:5303})
# CREATE(Sepang:GrandPrix{city:"Sepang",meters:5543})
# CREATE(Shanghai:GrandPrix{city:"Shanghai",meters:5451})
# CREATE(Sakhir:GrandPrix{city:"Sakhir",meters:5412})
# CREATE(Montmelo:GrandPrix{city:"Montmeló",meters:4655})
# CREATE(MonacoCirc:GrandPrix{city:"Monaco",meters:3340})
# CREATE(Montreal:GrandPrix{city:"Montreal",meters:4361})
# CREATE(Silverstone:GrandPrix{city:"Silverstone",meters:5891})
# CREATE(Nurburg:GrandPrix{city:"Nürburg",meters:4574})
# CREATE(Budapest:GrandPrix{city:"Budapest",meters:4328})
# CREATE(SpaFrancorchamps:GrandPrix{city:"Spa-Francorchamps",meters:7004})
# CREATE(Monza:GrandPrix{city:"Monza",meters:5793})
# CREATE(SingaporeCirc:GrandPrix{city:"Singapore",meters:5073})
# CREATE(Yeongam:GrandPrix{city:"Yeongam",meters:5615})
# CREATE(Suzuka:GrandPrix{city:"Suzuka",meters:5807})
# CREATE(GreaterNoida:GrandPrix{city:"Greater Noida",meters:5141})
# CREATE(AbuDhabi:GrandPrix{city:"Abu Dhabi",meters:5554})
# CREATE(Austin:GrandPrix{city:"Austin",meters:5500})
# CREATE(SaoPaulo:GrandPrix{city:"São Paulo",meters:4309})
# CREATE
# (RedBull)-[:HAS]->(RS272013),
# (Ferrari)-[:HAS]->(FerrariType056),
# (McLarenMercedes)-[:HAS]->(MercedesFO108Z),
# (Lotus)-[:HAS]->(RS272013),
# (Mercedes)-[:HAS]->(MercedesFO108Z),
# (Sauber)-[:HAS]->(FerrariType056),
# (ForceIndia)-[:HAS]->(MercedesFO108Z),
# (Williams)-[:HAS]->(RS272013),
# (ToroRosso)-[:HAS]->(FerrariType056),
# (Caterham)-[:HAS]->(RS272013),
# (Marussia)-[:HAS]->(CosworthCA2013)
# CREATE (FAlonso)-[:COUNTRY_ORIGIN]->(Spain),
# (SVettel)-[:COUNTRY_ORIGIN]->(Germany),
# (JButton)-[:COUNTRY_ORIGIN]->(UnitedKingdom),
# (LHamilton)-[:COUNTRY_ORIGIN]->(UnitedKingdom),
# (KRaikkonen)-[:COUNTRY_ORIGIN]->(Finland),
# (MWebber)-[:COUNTRY_ORIGIN]->(Australia),
# (FelipeMassa)-[:COUNTRY_ORIGIN]->(Brazil),
# (RomainGrosjean)-[:COUNTRY_ORIGIN]->(France),
# (SergioP)-[:COUNTRY_ORIGIN]->(Mexico),
# (HeikkiKovalainen)-[:COUNTRY_ORIGIN]->(Finland),
# (NicoRosberg)-[:COUNTRY_ORIGIN]->(Germany),
# (NicoH)-[:COUNTRY_ORIGIN]->(Germany),
# (EstebanG)-[:COUNTRY_ORIGIN]->(Mexico),
# (PaulDiResta)-[:COUNTRY_ORIGIN]->(UnitedKingdom),
# (AdrianSutil)-[:COUNTRY_ORIGIN]->(Germany),
# (PastorMaldonado)-[:COUNTRY_ORIGIN]->(Venezuela),
# (ValtteriBottas)-[:COUNTRY_ORIGIN]->(Finland),
# (Vergne)-[:COUNTRY_ORIGIN]->(France),
# (DanielRicciardo)-[:COUNTRY_ORIGIN]->(Australia),
# (CharlesPic)-[:COUNTRY_ORIGIN]->(France),
# (GiedoGarde)-[:COUNTRY_ORIGIN]->(Netherlands),
# (JulesBianchi)-[:COUNTRY_ORIGIN]->(France),
# (MaxChilton)-[:COUNTRY_ORIGIN]->(UnitedKingdom)
# CREATE
# (RedBull)-[:COUNTRY_ORIGIN]->(Austria),
# (Ferrari)-[:COUNTRY_ORIGIN]->(Italy),
# (McLarenMercedes)-[:COUNTRY_ORIGIN]->(UnitedKingdom),
# (Lotus)-[:COUNTRY_ORIGIN]->(UnitedKingdom),
# (Mercedes)-[:COUNTRY_ORIGIN]->(Germany),
# (Sauber)-[:COUNTRY_ORIGIN]->(Switzerland),
# (ForceIndia)-[:COUNTRY_ORIGIN]->(India),
# (Williams)-[:COUNTRY_ORIGIN]->(UnitedKingdom),
# (ToroRosso)-[:COUNTRY_ORIGIN]->(Italy),
# (Caterham)-[:COUNTRY_ORIGIN]->(Malaysia),
# (Marussia)-[:COUNTRY_ORIGIN]->(Russia)
# CREATE
# (Melbourne)-[:COUNTRY_ORIGIN]->(Australia),
# (Sepang)-[:COUNTRY_ORIGIN]->(Malaysia),
# (Shanghai)-[:COUNTRY_ORIGIN]->(China),
# (Sakhir)-[:COUNTRY_ORIGIN]->(Bahrain),
# (Montmelo)-[:COUNTRY_ORIGIN]->(Spain),
# (MonacoCirc)-[:COUNTRY_ORIGIN]->(Monaco),
# (Montreal)-[:COUNTRY_ORIGIN]->(Canada),
# (Silverstone)-[:COUNTRY_ORIGIN]->(UnitedKingdom),
# (Nurburg)-[:COUNTRY_ORIGIN]->(Germany),
# (Budapest)-[:COUNTRY_ORIGIN]->(Hungary),
# (SpaFrancorchamps)-[:COUNTRY_ORIGIN]->(Belgium),
# (Monza)-[:COUNTRY_ORIGIN]->(Italy),
# (SingaporeCirc)-[:COUNTRY_ORIGIN]->(Singapore),
# (Yeongam)-[:COUNTRY_ORIGIN]->(SouthKorea),
# (Suzuka)-[:COUNTRY_ORIGIN]->(Japan),
# (GreaterNoida)-[:COUNTRY_ORIGIN]->(India),
# (AbuDhabi)-[:COUNTRY_ORIGIN]->(UnitedArabEmirates),
# (Austin)-[:COUNTRY_ORIGIN]->(USA),
# (SaoPaulo)-[:COUNTRY_ORIGIN]->(Brazil)
# CREATE
# (FAlonso)-[:BELONGS_TO{since:2010}]->(Ferrari),
# (SVettel)-[:BELONGS_TO{since:2009}]->(RedBull),
# (JButton)-[:BELONGS_TO{since:2010}]->(McLarenMercedes),
# (LHamilton)-[:BELONGS_TO{since:2013}]->(Mercedes),
# (KRaikkonen)-[:BELONGS_TO{since:2012}]->(Lotus),
# (MWebber)-[:BELONGS_TO{since:2007}]->(RedBull),
# (FelipeMassa)-[:BELONGS_TO{since:2006}]->(Ferrari),
# (RomainGrosjean)-[:BELONGS_TO{since:2012}]->(Lotus),
# (SergioP)-[:BELONGS_TO{since:2013}]->(McLarenMercedes),
# (HeikkiKovalainen)-[:BELONGS_TO{since:2013}]->(Lotus),
# (NicoRosberg)-[:BELONGS_TO{since:2010}]->(Mercedes),
# (NicoH)-[:BELONGS_TO{since:2013}]->(Sauber),
# (EstebanG)-[:BELONGS_TO{since:2012}]->(Sauber),
# (PaulDiResta)-[:BELONGS_TO{since:2010}]->(ForceIndia),
# (AdrianSutil)-[:BELONGS_TO{since:2008}]->(ForceIndia),
# (PastorMaldonado)-[:BELONGS_TO{since:2011}]->(Williams),
# (ValtteriBottas)-[:BELONGS_TO{since:2012}]->(Williams),
# (Vergne)-[:BELONGS_TO{since:2012}]->(ToroRosso),
# (DanielRicciardo)-[:BELONGS_TO{since:2012}]->(ToroRosso),
# (CharlesPic)-[:BELONGS_TO{since:2013}]->(Caterham),
# (GiedoGarde)-[:BELONGS_TO{since:2012}]->(Caterham),
# (JulesBianchi)-[:BELONGS_TO{since:2013}]->(Marussia),
# (MaxChilton)-[:BELONGS_TO{since:2012}]->(Marussia)
# CREATE
# (Spyker:Constructor {name:"Spyker"}),
# (Honda:Constructor {name:"Honda"}),
# (BAR:Constructor {name:"BAR-Honda"}),
# (Minardi:Constructor {name:"Minardi"}),
# (Jaguar:Constructor {name:"Jaguar"}),
# (Renault:Constructor {name:"Renault"}),
# (BrawnGP:Constructor {name:"BrawnGP"}),
# (Benetton:Constructor {name:"Benetton"})
# CREATE
# (Spyker)-[:COUNTRY_ORIGIN]->(Netherlands),
# (Honda)-[:COUNTRY_ORIGIN]->(Japan),
# (BAR)-[:COUNTRY_ORIGIN]->(UnitedKingdom),
# (Minardi)-[:COUNTRY_ORIGIN]->(Italy),
# (Jaguar)-[:COUNTRY_ORIGIN]->(UnitedKingdom),
# (Renault)-[:COUNTRY_ORIGIN]->(France),
# (BrawnGP)-[:COUNTRY_ORIGIN]->(UnitedKingdom),
# (Benetton)-[:COUNTRY_ORIGIN]->(UnitedKingdom)
# CREATE
# (FAlonso)-[:BELONGED_TO{since:2008, until:2009}]->(Renault),
# (FAlonso)-[:BELONGED_TO{since:2007, until:2007}]->(McLarenMercedes),
# (FAlonso)-[:BELONGED_TO{since:2003, until:2006}]->(Renault),
# (SVettel)-[:BELONGED_TO{since:2001, until:2001}]->(Minardi),
# (SVettel)-[:BELONGED_TO{since:2007, until:2008}]->(ToroRosso),
# (SVettel)-[:BELONGED_TO{since:2006, until:2006}]->(Sauber),
# (JButton)-[:BELONGED_TO{since:2009, until:2009}]->(BrawnGP),
# (JButton)-[:BELONGED_TO{since:2006, until:2008}]->(Honda),
# (JButton)-[:BELONGED_TO{since:2003, until:2005}]->(BAR),
# (JButton)-[:BELONGED_TO{since:2002, until:2002}]->(Renault),
# (JButton)-[:BELONGED_TO{since:2001, until:2001}]->(Benetton),
# (JButton)-[:BELONGED_TO{since:2000, until:2000}]->(Williams),
# (LHamilton)-[:BELONGED_TO{since:2007, until:2012}]->(McLarenMercedes),
# (KRaikkonen)-[:BELONGED_TO{since:2007, until:2009}]->(Ferrari),
# (KRaikkonen)-[:BELONGED_TO{since:2002, until:2007}]->(McLarenMercedes),
# (KRaikkonen)-[:BELONGED_TO{since:2001, until:2001}]->(Sauber),
# (MWebber)-[:BELONGED_TO{since:2005, until:2006}]->(Williams),
# (MWebber)-[:BELONGED_TO{since:2003, until:2004}]->(Jaguar),
# (MWebber)-[:BELONGED_TO{since:2002, until:2002}]->(Minardi),
# (FelipeMassa)-[:BELONGED_TO{since:2004, until:2005}]->(Sauber),
# (FelipeMassa)-[:BELONGED_TO{since:2002, until:2002}]->(Sauber),
# (SergioP)-[:BELONGED_TO{since:2011, until:2012}]->(Sauber),
# (HeikkiKovalainen)-[:BELONGED_TO{since:2012, until:2012}]->(Caterham),
# (HeikkiKovalainen)-[:BELONGED_TO{since:2010, until:2011}]->(Lotus),
# (HeikkiKovalainen)-[:BELONGED_TO{since:2008, until:2009}]->(McLarenMercedes),
# (HeikkiKovalainen)-[:BELONGED_TO{since:2007, until:2007}]->(Renault),
# (NicoRosberg)-[:BELONGED_TO{since:2006, until:2009}]->(Williams),
# (NicoH)-[:BELONGED_TO{since:2012, until:2012}]->(ForceIndia),
# (NicoH)-[:BELONGED_TO{since:2010, until:2010}]->(Williams),
# (AdrianSutil)-[:BELONGED_TO{since:2007, until:2007}]->(Spyker)
# CREATE
# (FAlonso)-[:FINISHED {position: "2", points: 18}]->(Melbourne),
# (FAlonso)-[:FINISHED {position: "RET", points: 0}]->(Sepang),
# (FAlonso)-[:FINISHED {position: "1", points: 25}]->(Shanghai),
# (FAlonso)-[:FINISHED {position: "8", points:  4}]->(Sakhir),
# (FAlonso)-[:FINISHED {position: "1", points: 25}]->(Montmelo),
# (FAlonso)-[:FINISHED {position: "7", points: 6}]->(MonacoCirc),
# (FAlonso)-[:FINISHED {position: "2", points: 18}]->(Montreal),
# (FAlonso)-[:FINISHED {position: "3", points: 15}]->(Silverstone),
# (FAlonso)-[:FINISHED {position: "4", points: 12}]->(Nurburg),
# (FAlonso)-[:FINISHED {position: "5", points: 10}]->(Budapest),
# (FAlonso)-[:FINISHED {position: "2", points: 18}]->(SpaFrancorchamps),
# (FAlonso)-[:FINISHED {position: "2", points: 18}]->(Monza),
# (FAlonso)-[:FINISHED {position: "2", points: 18}]->(SingaporeCirc),
# (FAlonso)-[:FINISHED {position: "6", points: 8}]->(Yeongam),
# (FAlonso)-[:FINISHED {position: "4", points: 12}]->(Suzuka),
# (FAlonso)-[:FINISHED {position: "11", points: 0}]->(GreaterNoida),
# (FAlonso)-[:FINISHED {position: "5", points: 10}]->(AbuDhabi),
# (FAlonso)-[:FINISHED {position: "5", points: 10}]->(Austin),
# (FAlonso)-[:FINISHED {position: "3", points: 15}]->(SaoPaulo),
# (SVettel)-[:FINISHED {position: "3", points: 15}]->(Melbourne),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(Sepang),
# (SVettel)-[:FINISHED {position: "4", points: 12}]->(Shanghai),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(Sakhir),
# (SVettel)-[:FINISHED {position: "4", points: 12}]->(Montmelo),
# (SVettel)-[:FINISHED {position: "2", points: 18}]->(MonacoCirc),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(Montreal),
# (SVettel)-[:FINISHED {position: "RET", points: 0}]->(Silverstone),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(Nurburg),
# (SVettel)-[:FINISHED {position: "3", points: 15}]->(Budapest),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(SpaFrancorchamps),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(Monza),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(SingaporeCirc),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(Yeongam),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(Suzuka),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(GreaterNoida),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(AbuDhabi),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(Austin),
# (SVettel)-[:FINISHED {position: "1", points: 25}]->(SaoPaulo),
# (JButton)-[:FINISHED {position: "9", points: 2 }]->(Melbourne),
# (JButton)-[:FINISHED {position: "17", points: 0}]->(Sepang),
# (JButton)-[:FINISHED {position: "5", points: 10 }]->(Shanghai),
# (JButton)-[:FINISHED {position: "10", points: 1 }]->(Sakhir),
# (JButton)-[:FINISHED {position: "8", points: 4 }]->(Montmelo),
# (JButton)-[:FINISHED {position: "6", points: 8 }]->(MonacoCirc),
# (JButton)-[:FINISHED {position: "12", points: 0}]->(Montreal),
# (JButton)-[:FINISHED {position: "13", points: 0}]->(Silverstone),
# (JButton)-[:FINISHED {position: "6", points: 8 }]->(Nurburg),
# (JButton)-[:FINISHED {position: "7", points: 6 }]->(Budapest),
# (JButton)-[:FINISHED {position: "6", points: 8 }]->(SpaFrancorchamps),
# (JButton)-[:FINISHED {position: "10", points: 1 }]->(Monza),
# (JButton)-[:FINISHED {position: "7", points: 6 }]->(SingaporeCirc),
# (JButton)-[:FINISHED {position: "8", points: 4 }]->(Yeongam),
# (JButton)-[:FINISHED {position: "9", points: 2 }]->(Suzuka),
# (JButton)-[:FINISHED {position: "14", points: 0}]->(GreaterNoida),
# (JButton)-[:FINISHED {position: "12", points: 0}]->(AbuDhabi),
# (JButton)-[:FINISHED {position: "10", points: 1 }]->(Austin),
# (JButton)-[:FINISHED {position: "4", points: 12 }]->(SaoPaulo),
# (LHamilton)-[:FINISHED {position: "5", points: 10 }]->(Melbourne),
# (LHamilton)-[:FINISHED {position: "3", points: 15 }]->(Sepang),
# (LHamilton)-[:FINISHED {position: "3", points: 15 }]->(Shanghai),
# (LHamilton)-[:FINISHED {position: "5", points: 10 }]->(Sakhir),
# (LHamilton)-[:FINISHED {position: "12", points: 0}]->(Montmelo),
# (LHamilton)-[:FINISHED {position: "4", points: 12 }]->(MonacoCirc),
# (LHamilton)-[:FINISHED {position: "3", points: 15 }]->(Montreal),
# (LHamilton)-[:FINISHED {position: "4", points: 12 }]->(Silverstone),
# (LHamilton)-[:FINISHED {position: "5", points: 10 }]->(Nurburg),
# (LHamilton)-[:FINISHED {position: "1", points: 25 }]->(Budapest),
# (LHamilton)-[:FINISHED {position: "3", points: 15 }]->(SpaFrancorchamps),
# (LHamilton)-[:FINISHED {position: "9", points: 2 }]->(Monza),
# (LHamilton)-[:FINISHED {position: "5", points: 10 }]->(SingaporeCirc),
# (LHamilton)-[:FINISHED {position: "5", points: 10 }]->(Yeongam),
# (LHamilton)-[:FINISHED {position: "RET", points: 0}]->(Suzuka),
# (LHamilton)-[:FINISHED {position: "6", points: 8 }]->(GreaterNoida),
# (LHamilton)-[:FINISHED {position: "7", points: 6 }]->(AbuDhabi),
# (LHamilton)-[:FINISHED {position: "4", points: 12 }]->(Austin),
# (LHamilton)-[:FINISHED {position: "9", points: 2 }]->(SaoPaulo),
# (KRaikkonen)-[:FINISHED {position: "1", points: 25 }]->(Melbourne),
# (KRaikkonen)-[:FINISHED {position: "7", points: 6 }]->(Sepang),
# (KRaikkonen)-[:FINISHED {position: "2", points: 18 }]->(Shanghai),
# (KRaikkonen)-[:FINISHED {position: "2", points: 18 }]->(Sakhir),
# (KRaikkonen)-[:FINISHED {position: "2", points: 18 }]->(Montmelo),
# (KRaikkonen)-[:FINISHED {position: "10", points: 1 }]->(MonacoCirc),
# (KRaikkonen)-[:FINISHED {position: "9", points: 2 }]->(Montreal),
# (KRaikkonen)-[:FINISHED {position: "5", points: 10 }]->(Silverstone),
# (KRaikkonen)-[:FINISHED {position: "2", points: 18 }]->(Nurburg),
# (KRaikkonen)-[:FINISHED {position: "2", points: 18 }]->(Budapest),
# (KRaikkonen)-[:FINISHED {position: "RET", points: 0}]->(SpaFrancorchamps),
# (KRaikkonen)-[:FINISHED {position: "11", points: 0 }]->(Monza),
# (KRaikkonen)-[:FINISHED {position: "3", points: 15 }]->(SingaporeCirc),
# (KRaikkonen)-[:FINISHED {position: "2", points: 18 }]->(Yeongam),
# (KRaikkonen)-[:FINISHED {position: "5", points: 10 }]->(Suzuka),
# (KRaikkonen)-[:FINISHED {position: "7", points: 6 }]->(GreaterNoida),
# (KRaikkonen)-[:FINISHED {position: "RET", points: 0}]->(AbuDhabi),
# (KRaikkonen)-[:FINISHED {position: "DNS", points: 0}]->(Austin),
# (KRaikkonen)-[:FINISHED {position: "DNS", points: 0}]->(SaoPaulo),
# (MWebber)-[:FINISHED {position: "6", points: 8 }]->(Melbourne),
# (MWebber)-[:FINISHED {position: "2", points: 18 }]->(Sepang),
# (MWebber)-[:FINISHED {position: "RET", points: 0 }]->(Shanghai),
# (MWebber)-[:FINISHED {position: "7", points: 6 }]->(Sakhir),
# (MWebber)-[:FINISHED {position: "5", points: 10 }]->(Montmelo),
# (MWebber)-[:FINISHED {position: "3", points: 15 }]->(MonacoCirc),
# (MWebber)-[:FINISHED {position: "4", points: 12 }]->(Montreal),
# (MWebber)-[:FINISHED {position: "2", points: 18 }]->(Silverstone),
# (MWebber)-[:FINISHED {position: "7", points: 6 }]->(Nurburg),
# (MWebber)-[:FINISHED {position: "4", points: 12 }]->(Budapest),
# (MWebber)-[:FINISHED {position: "5", points: 10 }]->(SpaFrancorchamps),
# (MWebber)-[:FINISHED {position: "3", points: 15 }]->(Monza),
# (MWebber)-[:FINISHED {position: "15", points: 0 }]->(SingaporeCirc),
# (MWebber)-[:FINISHED {position: "RET", points: 0 }]->(Yeongam),
# (MWebber)-[:FINISHED {position: "2", points: 18 }]->(Suzuka),
# (MWebber)-[:FINISHED {position: "RET", points: 0 }]->(GreaterNoida),
# (MWebber)-[:FINISHED {position: "2", points: 18 }]->(AbuDhabi),
# (MWebber)-[:FINISHED {position: "3", points: 15 }]->(Austin),
# (MWebber)-[:FINISHED {position: "2", points: 18 }]->(SaoPaulo),
# (FelipeMassa)-[:FINISHED {position: "4", points: 12 }]->(Melbourne),
# (FelipeMassa)-[:FINISHED {position: "5", points: 10 }]->(Sepang),
# (FelipeMassa)-[:FINISHED {position: "6", points: 8 }]->(Shanghai),
# (FelipeMassa)-[:FINISHED {position: "15", points: 0 }]->(Sakhir),
# (FelipeMassa)-[:FINISHED {position: "3", points: 15 }]->(Montmelo),
# (FelipeMassa)-[:FINISHED {position: "RET", points: 0 }]->(MonacoCirc),
# (FelipeMassa)-[:FINISHED {position: "8", points: 4 }]->(Montreal),
# (FelipeMassa)-[:FINISHED {position: "6", points: 8 }]->(Silverstone),
# (FelipeMassa)-[:FINISHED {position: "RET", points: 0 }]->(Nurburg),
# (FelipeMassa)-[:FINISHED {position: "8", points: 4 }]->(Budapest),
# (FelipeMassa)-[:FINISHED {position: "7", points: 6 }]->(SpaFrancorchamps),
# (FelipeMassa)-[:FINISHED {position: "4", points: 12 }]->(Monza),
# (FelipeMassa)-[:FINISHED {position: "6", points: 8 }]->(SingaporeCirc),
# (FelipeMassa)-[:FINISHED {position: "9", points: 2 }]->(Yeongam),
# (FelipeMassa)-[:FINISHED {position: "10", points: 1 }]->(Suzuka),
# (FelipeMassa)-[:FINISHED {position: "4", points: 12 }]->(GreaterNoida),
# (FelipeMassa)-[:FINISHED {position: "8", points: 4 }]->(AbuDhabi),
# (FelipeMassa)-[:FINISHED {position: "12", points: 0 }]->(Austin),
# (FelipeMassa)-[:FINISHED {position: "7", points: 6 }]->(SaoPaulo),
# (SergioP)-[:FINISHED {position: "11", points: 0 }]->(Melbourne),
# (SergioP)-[:FINISHED {position: "9", points: 2 }]->(Sepang),
# (SergioP)-[:FINISHED {position: "11", points: 0 }]->(Shanghai),
# (SergioP)-[:FINISHED {position: "6", points: 8 }]->(Sakhir),
# (SergioP)-[:FINISHED {position: "9", points: 2 }]->(Montmelo),
# (SergioP)-[:FINISHED {position: "16", points: 0 }]->(MonacoCirc),
# (SergioP)-[:FINISHED {position: "11", points: 0 }]->(Montreal),
# (SergioP)-[:FINISHED {position: "20", points: 0 }]->(Silverstone),
# (SergioP)-[:FINISHED {position: "8", points: 4 }]->(Nurburg),
# (SergioP)-[:FINISHED {position: "9", points: 2 }]->(Budapest),
# (SergioP)-[:FINISHED {position: "11", points: 0 }]->(SpaFrancorchamps),
# (SergioP)-[:FINISHED {position: "12", points: 0 }]->(Monza),
# (SergioP)-[:FINISHED {position: "8", points: 4 }]->(SingaporeCirc),
# (SergioP)-[:FINISHED {position: "10", points: 1 }]->(Yeongam),
# (SergioP)-[:FINISHED {position: "15", points: 0 }]->(Suzuka),
# (SergioP)-[:FINISHED {position: "5", points: 10 }]->(GreaterNoida),
# (SergioP)-[:FINISHED {position: "9", points: 2 }]->(AbuDhabi),
# (SergioP)-[:FINISHED {position: "7", points: 6 }]->(Austin),
# (SergioP)-[:FINISHED {position: "6", points: 8 }]->(SaoPaulo),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(Melbourne),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(Sepang),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(Shanghai),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(Sakhir),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(Montmelo),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(MonacoCirc),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(Montreal),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(Silverstone),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(Nurburg),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(Budapest),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(SpaFrancorchamps),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(Monza),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(SingaporeCirc),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(Yeongam),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(Suzuka),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(GreaterNoida),
# (HeikkiKovalainen)-[:FINISHED {position: "DNS", points: 0 }]->(AbuDhabi),
# (HeikkiKovalainen)-[:FINISHED {position: "14", points: 0 }]->(Austin),
# (HeikkiKovalainen)-[:FINISHED {position: "14", points: 0 }]->(SaoPaulo),
# (RomainGrosjean)-[:FINISHED {position: "10", points: 1 }]->(Melbourne),
# (RomainGrosjean)-[:FINISHED {position: "6", points: 8 }]->(Sepang),
# (RomainGrosjean)-[:FINISHED {position: "9", points: 2 }]->(Shanghai),
# (RomainGrosjean)-[:FINISHED {position: "3", points: 15 }]->(Sakhir),
# (RomainGrosjean)-[:FINISHED {position: "RET", points: 0 }]->(Montmelo),
# (RomainGrosjean)-[:FINISHED {position: "RET", points: 0 }]->(MonacoCirc),
# (RomainGrosjean)-[:FINISHED {position: "13", points: 0 }]->(Montreal),
# (RomainGrosjean)-[:FINISHED {position: "19", points: 0 }]->(Silverstone),
# (RomainGrosjean)-[:FINISHED {position: "3", points: 15 }]->(Nurburg),
# (RomainGrosjean)-[:FINISHED {position: "6", points: 8 }]->(Budapest),
# (RomainGrosjean)-[:FINISHED {position: "8", points: 4 }]->(SpaFrancorchamps),
# (RomainGrosjean)-[:FINISHED {position: "8", points: 4 }]->(Monza),
# (RomainGrosjean)-[:FINISHED {position: "RET", points: 0 }]->(SingaporeCirc),
# (RomainGrosjean)-[:FINISHED {position: "3", points: 15 }]->(Yeongam),
# (RomainGrosjean)-[:FINISHED {position: "3", points: 15 }]->(Suzuka),
# (RomainGrosjean)-[:FINISHED {position: "3", points: 15 }]->(GreaterNoida),
# (RomainGrosjean)-[:FINISHED {position: "4", points: 12 }]->(AbuDhabi),
# (RomainGrosjean)-[:FINISHED {position: "2", points: 18 }]->(Austin),
# (RomainGrosjean)-[:FINISHED {position: "RET", points: 0 }]->(SaoPaulo),
# (NicoRosberg)-[:FINISHED {position: "RET", points: 0 }]->(Melbourne),
# (NicoRosberg)-[:FINISHED {position: "4", points: 12 }]->(Sepang),
# (NicoRosberg)-[:FINISHED {position: "RET", points: 0 }]->(Shanghai),
# (NicoRosberg)-[:FINISHED {position: "9", points: 2 }]->(Sakhir),
# (NicoRosberg)-[:FINISHED {position: "6", points: 8 }]->(Montmelo),
# (NicoRosberg)-[:FINISHED {position: "1", points: 25 }]->(MonacoCirc),
# (NicoRosberg)-[:FINISHED {position: "5", points: 10 }]->(Montreal),
# (NicoRosberg)-[:FINISHED {position: "1", points: 25 }]->(Silverstone),
# (NicoRosberg)-[:FINISHED {position: "9", points: 2 }]->(Nurburg),
# (NicoRosberg)-[:FINISHED {position: "19", points: 0 }]->(Budapest),
# (NicoRosberg)-[:FINISHED {position: "4", points: 12 }]->(SpaFrancorchamps),
# (NicoRosberg)-[:FINISHED {position: "6", points: 8 }]->(Monza),
# (NicoRosberg)-[:FINISHED {position: "4", points: 12 }]->(SingaporeCirc),
# (NicoRosberg)-[:FINISHED {position: "7", points: 6 }]->(Yeongam),
# (NicoRosberg)-[:FINISHED {position: "8", points: 4 }]->(Suzuka),
# (NicoRosberg)-[:FINISHED {position: "2", points: 18 }]->(GreaterNoida),
# (NicoRosberg)-[:FINISHED {position: "3", points: 15 }]->(AbuDhabi),
# (NicoRosberg)-[:FINISHED {position: "9", points: 2 }]->(Austin),
# (NicoRosberg)-[:FINISHED {position: "5", points: 10 }]->(SaoPaulo),
# (NicoH)-[:FINISHED {position: "DNS", points: 0}]->(Melbourne),
# (NicoH)-[:FINISHED {position: "8", points: 4 }]->(Sepang),
# (NicoH)-[:FINISHED {position: "10", points: 1 }]->(Shanghai),
# (NicoH)-[:FINISHED {position: "12", points: 0 }]->(Sakhir),
# (NicoH)-[:FINISHED {position: "15", points: 0 }]->(Montmelo),
# (NicoH)-[:FINISHED {position: "11", points: 0 }]->(MonacoCirc),
# (NicoH)-[:FINISHED {position: "RET", points: 0 }]->(Montreal),
# (NicoH)-[:FINISHED {position: "10", points: 1 }]->(Silverstone),
# (NicoH)-[:FINISHED {position: "10", points: 1 }]->(Nurburg),
# (NicoH)-[:FINISHED {position: "11", points: 0 }]->(Budapest),
# (NicoH)-[:FINISHED {position: "13", points: 0 }]->(SpaFrancorchamps),
# (NicoH)-[:FINISHED {position: "5", points: 10 }]->(Monza),
# (NicoH)-[:FINISHED {position: "9", points: 2 }]->(SingaporeCirc),
# (NicoH)-[:FINISHED {position: "4", points: 12 }]->(Yeongam),
# (NicoH)-[:FINISHED {position: "6", points: 8 }]->(Suzuka),
# (NicoH)-[:FINISHED {position: "19", points: 0 }]->(GreaterNoida),
# (NicoH)-[:FINISHED {position: "14", points: 0 }]->(AbuDhabi),
# (NicoH)-[:FINISHED {position: "6", points: 8 }]->(Austin),
# (NicoH)-[:FINISHED {position: "8", points: 4 }]->(SaoPaulo),
# (EstebanG)-[:FINISHED {position: "13", points: 0 }]->(Melbourne),
# (EstebanG)-[:FINISHED {position: "12", points: 0 }]->(Sepang),
# (EstebanG)-[:FINISHED {position: "RET", points: 0 }]->(Shanghai),
# (EstebanG)-[:FINISHED {position: "18", points: 0 }]->(Sakhir),
# (EstebanG)-[:FINISHED {position: "11", points: 0 }]->(Montmelo),
# (EstebanG)-[:FINISHED {position: "13", points: 0 }]->(MonacoCirc),
# (EstebanG)-[:FINISHED {position: "20", points: 0 }]->(Montreal),
# (EstebanG)-[:FINISHED {position: "14", points: 0 }]->(Silverstone),
# (EstebanG)-[:FINISHED {position: "14", points: 0 }]->(Nurburg),
# (EstebanG)-[:FINISHED {position: "RET", points: 0 }]->(Budapest),
# (EstebanG)-[:FINISHED {position: "14", points: 0 }]->(SpaFrancorchamps),
# (EstebanG)-[:FINISHED {position: "13", points: 0 }]->(Monza),
# (EstebanG)-[:FINISHED {position: "12", points: 0 }]->(SingaporeCirc),
# (EstebanG)-[:FINISHED {position: "11", points: 0 }]->(Yeongam),
# (EstebanG)-[:FINISHED {position: "7", points: 6 }]->(Suzuka),
# (EstebanG)-[:FINISHED {position: "15", points: 0 }]->(GreaterNoida),
# (EstebanG)-[:FINISHED {position: "13", points: 0 }]->(AbuDhabi),
# (EstebanG)-[:FINISHED {position: "13", points: 0 }]->(Austin),
# (EstebanG)-[:FINISHED {position: "12", points: 0 }]->(SaoPaulo),
# (PaulDiResta)-[:FINISHED {position: "8", points: 4 }]->(Melbourne),
# (PaulDiResta)-[:FINISHED {position: "RET", points: 0 }]->(Sepang),
# (PaulDiResta)-[:FINISHED {position: "8", points: 4 }]->(Shanghai),
# (PaulDiResta)-[:FINISHED {position: "4", points: 12 }]->(Sakhir),
# (PaulDiResta)-[:FINISHED {position: "7", points: 6 }]->(Montmelo),
# (PaulDiResta)-[:FINISHED {position: "9", points: 2 }]->(MonacoCirc),
# (PaulDiResta)-[:FINISHED {position: "7", points: 6 }]->(Montreal),
# (PaulDiResta)-[:FINISHED {position: "9", points: 2 }]->(Silverstone),
# (PaulDiResta)-[:FINISHED {position: "11", points: 0 }]->(Nurburg),
# (PaulDiResta)-[:FINISHED {position: "18", points: 0 }]->(Budapest),
# (PaulDiResta)-[:FINISHED {position: "RET", points: 0 }]->(SpaFrancorchamps),
# (PaulDiResta)-[:FINISHED {position: "RET", points: 0 }]->(Monza),
# (PaulDiResta)-[:FINISHED {position: "20", points: 0 }]->(SingaporeCirc),
# (PaulDiResta)-[:FINISHED {position: "RET", points: 0 }]->(Yeongam),
# (PaulDiResta)-[:FINISHED {position: "11", points: 0 }]->(Suzuka),
# (PaulDiResta)-[:FINISHED {position: "8", points: 4 }]->(GreaterNoida),
# (PaulDiResta)-[:FINISHED {position: "6", points: 8 }]->(AbuDhabi),
# (PaulDiResta)-[:FINISHED {position: "15", points: 0 }]->(Austin),
# (PaulDiResta)-[:FINISHED {position: "11", points: 0 }]->(SaoPaulo),
# (AdrianSutil)-[:FINISHED {position: "7", points: 6 }]->(Melbourne),
# (AdrianSutil)-[:FINISHED {position: "RET", points: 0 }]->(Sepang),
# (AdrianSutil)-[:FINISHED {position: "RET", points: 0 }]->(Shanghai),
# (AdrianSutil)-[:FINISHED {position: "13", points: 0 }]->(Sakhir),
# (AdrianSutil)-[:FINISHED {position: "13", points: 0 }]->(Montmelo),
# (AdrianSutil)-[:FINISHED {position: "5", points: 10 }]->(MonacoCirc),
# (AdrianSutil)-[:FINISHED {position: "10", points: 1 }]->(Montreal),
# (AdrianSutil)-[:FINISHED {position: "7", points: 6 }]->(Silverstone),
# (AdrianSutil)-[:FINISHED {position: "13", points: 0 }]->(Nurburg),
# (AdrianSutil)-[:FINISHED {position: "RET", points: 0 }]->(Budapest),
# (AdrianSutil)-[:FINISHED {position: "9", points: 2 }]->(SpaFrancorchamps),
# (AdrianSutil)-[:FINISHED {position: "16", points: 0 }]->(Monza),
# (AdrianSutil)-[:FINISHED {position: "10", points: 1 }]->(SingaporeCirc),
# (AdrianSutil)-[:FINISHED {position: "20", points: 0 }]->(Yeongam),
# (AdrianSutil)-[:FINISHED {position: "14", points: 0 }]->(Suzuka),
# (AdrianSutil)-[:FINISHED {position: "9", points: 2 }]->(GreaterNoida),
# (AdrianSutil)-[:FINISHED {position: "10", points: 1 }]->(AbuDhabi),
# (AdrianSutil)-[:FINISHED {position: "RET", points: 0 }]->(Austin),
# (AdrianSutil)-[:FINISHED {position: "13", points: 0 }]->(SaoPaulo),
# (PastorMaldonado)-[:FINISHED {position: "RET", points: 0 }]->(Melbourne),
# (PastorMaldonado)-[:FINISHED {position: "RET", points: 0 }]->(Sepang),
# (PastorMaldonado)-[:FINISHED {position: "14", points: 0 }]->(Shanghai),
# (PastorMaldonado)-[:FINISHED {position: "11", points: 0 }]->(Sakhir),
# (PastorMaldonado)-[:FINISHED {position: "14", points: 0 }]->(Montmelo),
# (PastorMaldonado)-[:FINISHED {position: "RET", points: 0 }]->(MonacoCirc),
# (PastorMaldonado)-[:FINISHED {position: "16", points: 0 }]->(Montreal),
# (PastorMaldonado)-[:FINISHED {position: "11", points: 0 }]->(Silverstone),
# (PastorMaldonado)-[:FINISHED {position: "15", points: 0 }]->(Nurburg),
# (PastorMaldonado)-[:FINISHED {position: "10", points: 1 }]->(Budapest),
# (PastorMaldonado)-[:FINISHED {position: "17", points: 0 }]->(SpaFrancorchamps),
# (PastorMaldonado)-[:FINISHED {position: "14", points: 0 }]->(Monza),
# (PastorMaldonado)-[:FINISHED {position: "11", points: 0 }]->(SingaporeCirc),
# (PastorMaldonado)-[:FINISHED {position: "13", points: 0 }]->(Yeongam),
# (PastorMaldonado)-[:FINISHED {position: "16", points: 0 }]->(Suzuka),
# (PastorMaldonado)-[:FINISHED {position: "12", points: 0 }]->(GreaterNoida),
# (PastorMaldonado)-[:FINISHED {position: "11", points: 0 }]->(AbuDhabi),
# (PastorMaldonado)-[:FINISHED {position: "17", points: 0 }]->(Austin),
# (PastorMaldonado)-[:FINISHED {position: "16", points: 0 }]->(SaoPaulo),
# (ValtteriBottas)-[:FINISHED {position: "14", points: 0 }]->(Melbourne),
# (ValtteriBottas)-[:FINISHED {position: "11", points: 0 }]->(Sepang),
# (ValtteriBottas)-[:FINISHED {position: "13", points: 0 }]->(Shanghai),
# (ValtteriBottas)-[:FINISHED {position: "14", points: 0 }]->(Sakhir),
# (ValtteriBottas)-[:FINISHED {position: "16", points: 0 }]->(Montmelo),
# (ValtteriBottas)-[:FINISHED {position: "12", points: 0 }]->(MonacoCirc),
# (ValtteriBottas)-[:FINISHED {position: "14", points: 0 }]->(Montreal),
# (ValtteriBottas)-[:FINISHED {position: "12", points: 0 }]->(Silverstone),
# (ValtteriBottas)-[:FINISHED {position: "16", points: 0 }]->(Nurburg),
# (ValtteriBottas)-[:FINISHED {position: "RET", points: 0 }]->(Budapest),
# (ValtteriBottas)-[:FINISHED {position: "15", points: 0 }]->(SpaFrancorchamps),
# (ValtteriBottas)-[:FINISHED {position: "15", points: 0 }]->(Monza),
# (ValtteriBottas)-[:FINISHED {position: "13", points: 0 }]->(SingaporeCirc),
# (ValtteriBottas)-[:FINISHED {position: "12", points: 0 }]->(Yeongam),
# (ValtteriBottas)-[:FINISHED {position: "17", points: 0 }]->(Suzuka),
# (ValtteriBottas)-[:FINISHED {position: "16", points: 0 }]->(GreaterNoida),
# (ValtteriBottas)-[:FINISHED {position: "15", points: 0 }]->(AbuDhabi),
# (ValtteriBottas)-[:FINISHED {position: "8", points: 4 }]->(Austin),
# (ValtteriBottas)-[:FINISHED {position: "RET", points: 0 }]->(SaoPaulo),
# (Vergne)-[:FINISHED {position: "12", points: 0 }]->(Melbourne),
# (Vergne)-[:FINISHED {position: "10", points: 1 }]->(Sepang),
# (Vergne)-[:FINISHED {position: "12", points: 0 }]->(Shanghai),
# (Vergne)-[:FINISHED {position: "RET", points: 0 }]->(Sakhir),
# (Vergne)-[:FINISHED {position: "RET", points: 0 }]->(Montmelo),
# (Vergne)-[:FINISHED {position: "8", points: 4 }]->(MonacoCirc),
# (Vergne)-[:FINISHED {position: "6", points: 8 }]->(Montreal),
# (Vergne)-[:FINISHED {position: "RET", points: 0 }]->(Silverstone),
# (Vergne)-[:FINISHED {position: "RET", points: 0 }]->(Nurburg),
# (Vergne)-[:FINISHED {position: "12", points: 0 }]->(Budapest),
# (Vergne)-[:FINISHED {position: "12", points: 0 }]->(SpaFrancorchamps),
# (Vergne)-[:FINISHED {position: "RET", points: 0 }]->(Monza),
# (Vergne)-[:FINISHED {position: "14", points: 0 }]->(SingaporeCirc),
# (Vergne)-[:FINISHED {position: "18", points: 0 }]->(Yeongam),
# (Vergne)-[:FINISHED {position: "12", points: 0 }]->(Suzuka),
# (Vergne)-[:FINISHED {position: "13", points: 0 }]->(GreaterNoida),
# (Vergne)-[:FINISHED {position: "17", points: 0 }]->(AbuDhabi),
# (Vergne)-[:FINISHED {position: "16", points: 0 }]->(Austin),
# (Vergne)-[:FINISHED {position: "15", points: 0 }]->(SaoPaulo),
# (DanielRicciardo)-[:FINISHED {position: "RET", points: 0 }]->(Melbourne),
# (DanielRicciardo)-[:FINISHED {position: "18", points: 0 }]->(Sepang),
# (DanielRicciardo)-[:FINISHED {position: "7", points: 6 }]->(Shanghai),
# (DanielRicciardo)-[:FINISHED {position: "16", points: 0 }]->(Sakhir),
# (DanielRicciardo)-[:FINISHED {position: "10", points: 1 }]->(Montmelo),
# (DanielRicciardo)-[:FINISHED {position: "RET", points: 0 }]->(MonacoCirc),
# (DanielRicciardo)-[:FINISHED {position: "15", points: 0 }]->(Montreal),
# (DanielRicciardo)-[:FINISHED {position: "8", points: 4 }]->(Silverstone),
# (DanielRicciardo)-[:FINISHED {position: "12", points: 0 }]->(Nurburg),
# (DanielRicciardo)-[:FINISHED {position: "13", points: 0 }]->(Budapest),
# (DanielRicciardo)-[:FINISHED {position: "10", points: 1 }]->(SpaFrancorchamps),
# (DanielRicciardo)-[:FINISHED {position: "7", points: 6 }]->(Monza),
# (DanielRicciardo)-[:FINISHED {position: "RET", points: 0 }]->(SingaporeCirc),
# (DanielRicciardo)-[:FINISHED {position: "19", points: 0 }]->(Yeongam),
# (DanielRicciardo)-[:FINISHED {position: "13", points: 0 }]->(Suzuka),
# (DanielRicciardo)-[:FINISHED {position: "10", points: 1 }]->(GreaterNoida),
# (DanielRicciardo)-[:FINISHED {position: "16", points: 0 }]->(AbuDhabi),
# (DanielRicciardo)-[:FINISHED {position: "11", points: 0 }]->(Austin),
# (DanielRicciardo)-[:FINISHED {position: "10", points: 1 }]->(SaoPaulo),
# (CharlesPic)-[:FINISHED {position: "16", points:0 }]->(Melbourne),
# (CharlesPic)-[:FINISHED {position: "14", points:0 }]->(Sepang),
# (CharlesPic)-[:FINISHED {position: "16", points:0 }]->(Shanghai),
# (CharlesPic)-[:FINISHED {position: "17", points:0 }]->(Sakhir),
# (CharlesPic)-[:FINISHED {position: "17", points:0 }]->(Montmelo),
# (CharlesPic)-[:FINISHED {position: "RET", points:0 }]->(MonacoCirc),
# (CharlesPic)-[:FINISHED {position: "18", points:0 }]->(Montreal),
# (CharlesPic)-[:FINISHED {position: "15", points:0 }]->(Silverstone),
# (CharlesPic)-[:FINISHED {position: "17", points:0 }]->(Nurburg),
# (CharlesPic)-[:FINISHED {position: "15", points:0 }]->(Budapest),
# (CharlesPic)-[:FINISHED {position: "RET", points:0 }]->(SpaFrancorchamps),
# (CharlesPic)-[:FINISHED {position: "17", points:0 }]->(Monza),
# (CharlesPic)-[:FINISHED {position: "19", points:0 }]->(SingaporeCirc),
# (CharlesPic)-[:FINISHED {position: "14", points:0 }]->(Yeongam),
# (CharlesPic)-[:FINISHED {position: "18", points:0 }]->(Suzuka),
# (CharlesPic)-[:FINISHED {position: "RET", points:0 }]->(GreaterNoida),
# (CharlesPic)-[:FINISHED {position: "19", points:0 }]->(AbuDhabi),
# (CharlesPic)-[:FINISHED {position: "20", points:0 }]->(Austin),
# (CharlesPic)-[:FINISHED {position: "RET", points:0 }]->(SaoPaulo),
# (GiedoGarde)-[:FINISHED {position: "18", points:0 }]->(Melbourne),
# (GiedoGarde)-[:FINISHED {position: "15", points:0 }]->(Sepang),
# (GiedoGarde)-[:FINISHED {position: "18", points:0 }]->(Shanghai),
# (GiedoGarde)-[:FINISHED {position: "21", points:0 }]->(Sakhir),
# (GiedoGarde)-[:FINISHED {position: "RET", points:0 }]->(Montmelo),
# (GiedoGarde)-[:FINISHED {position: "15", points:0 }]->(MonacoCirc),
# (GiedoGarde)-[:FINISHED {position: "RET", points:0 }]->(Montreal),
# (GiedoGarde)-[:FINISHED {position: "18", points:0 }]->(Silverstone),
# (GiedoGarde)-[:FINISHED {position: "18", points:0 }]->(Nurburg),
# (GiedoGarde)-[:FINISHED {position: "14", points:0 }]->(Budapest),
# (GiedoGarde)-[:FINISHED {position: "16", points:0 }]->(SpaFrancorchamps),
# (GiedoGarde)-[:FINISHED {position: "18", points:0 }]->(Monza),
# (GiedoGarde)-[:FINISHED {position: "16", points:0 }]->(SingaporeCirc),
# (GiedoGarde)-[:FINISHED {position: "15", points:0 }]->(Yeongam),
# (GiedoGarde)-[:FINISHED {position: "RET", points:0 }]->(Suzuka),
# (GiedoGarde)-[:FINISHED {position: "RET", points:0 }]->(GreaterNoida),
# (GiedoGarde)-[:FINISHED {position: "18", points:0 }]->(AbuDhabi),
# (GiedoGarde)-[:FINISHED {position: "19", points:0 }]->(Austin),
# (GiedoGarde)-[:FINISHED {position: "18", points:0 }]->(SaoPaulo),
# (JulesBianchi)-[:FINISHED {position: "15", points:0 }]->(Melbourne),
# (JulesBianchi)-[:FINISHED {position: "13", points:0 }]->(Sepang),
# (JulesBianchi)-[:FINISHED {position: "15", points:0 }]->(Shanghai),
# (JulesBianchi)-[:FINISHED {position: "19", points:0 }]->(Sakhir),
# (JulesBianchi)-[:FINISHED {position: "18", points:0 }]->(Montmelo),
# (JulesBianchi)-[:FINISHED {position: "RET", points:0 }]->(MonacoCirc),
# (JulesBianchi)-[:FINISHED {position: "17", points:0 }]->(Montreal),
# (JulesBianchi)-[:FINISHED {position: "16", points:0 }]->(Silverstone),
# (JulesBianchi)-[:FINISHED {position: "RET", points:0 }]->(Nurburg),
# (JulesBianchi)-[:FINISHED {position: "16", points:0 }]->(Budapest),
# (JulesBianchi)-[:FINISHED {position: "18", points:0 }]->(SpaFrancorchamps),
# (JulesBianchi)-[:FINISHED {position: "19", points:0 }]->(Monza),
# (JulesBianchi)-[:FINISHED {position: "18", points:0 }]->(SingaporeCirc),
# (JulesBianchi)-[:FINISHED {position: "16", points:0 }]->(Yeongam),
# (JulesBianchi)-[:FINISHED {position: "RET", points:0 }]->(Suzuka),
# (JulesBianchi)-[:FINISHED {position: "18", points:0 }]->(GreaterNoida),
# (JulesBianchi)-[:FINISHED {position: "20", points:0 }]->(AbuDhabi),
# (JulesBianchi)-[:FINISHED {position: "18", points:0 }]->(Austin),
# (JulesBianchi)-[:FINISHED {position: "17", points:0 }]->(SaoPaulo),
# (MaxChilton)-[:FINISHED {position: "17", points:0 }]->(Melbourne),
# (MaxChilton)-[:FINISHED {position: "16", points:0 }]->(Sepang),
# (MaxChilton)-[:FINISHED {position: "17", points:0 }]->(Shanghai),
# (MaxChilton)-[:FINISHED {position: "20", points:0 }]->(Sakhir),
# (MaxChilton)-[:FINISHED {position: "19", points:0 }]->(Montmelo),
# (MaxChilton)-[:FINISHED {position: "14", points:0 }]->(MonacoCirc),
# (MaxChilton)-[:FINISHED {position: "19", points:0 }]->(Montreal),
# (MaxChilton)-[:FINISHED {position: "17", points:0 }]->(Silverstone),
# (MaxChilton)-[:FINISHED {position: "19", points:0 }]->(Nurburg),
# (MaxChilton)-[:FINISHED {position: "17", points:0 }]->(Budapest),
# (MaxChilton)-[:FINISHED {position: "19", points:0 }]->(SpaFrancorchamps),
# (MaxChilton)-[:FINISHED {position: "20", points:0 }]->(Monza),
# (MaxChilton)-[:FINISHED {position: "17", points:0 }]->(SingaporeCirc),
# (MaxChilton)-[:FINISHED {position: "17", points:0 }]->(Yeongam),
# (MaxChilton)-[:FINISHED {position: "19", points:0 }]->(Suzuka),
# (MaxChilton)-[:FINISHED {position: "17", points:0 }]->(GreaterNoida),
# (MaxChilton)-[:FINISHED {position: "21", points:0 }]->(AbuDhabi),
# (MaxChilton)-[:FINISHED {position: "21", points:0 }]->(Austin),
# (MaxChilton)-[:FINISHED {position: "19", points:0 }]->(SaoPaulo)', con)
#
# test_that("query formule1 tests", {
#   req_and_expect(
#     req = 'MATCH (t)-[]->(p:Playoff)
#     WHERE p.Year = "2015"
#     RETURN t,p',
#     con = con,
#     is = "list",
#     length = 2,
#     names = c("t", "p")
#   )
#
#   req_and_expect(
#     req = 'MATCH (t:Team {Name: "Golden State"})-[w:WIN]->(:Playoff)<-[l:WIN]-()
# RETURN t,w,l',
#     con = con,
#     is = "list",
#     length = 3,
#     names = c("t", "w", "l")
#   )
#
#   req_and_expect(
#     req = "MATCH (t:Team)-[w:WIN]->(:Playoff)<-[l:WIN]-()\nRETURN t.Name as TEAM, SUM(w.Win) AS TOTAL_WIN, SUM(l.Win) as TOTAL_LOSS,\n(toFloat(SUM(w.Win)) / (toFloat(SUM(w.Win))+ toFloat(SUM(l.Win)))) as WIN_PERCENTAGE\nORDER BY SUM(w.Win) DESC",
#     con = con,
#     is = "list",
#     length = 4,
#     names = c("TEAM", "TOTAL_WIN", "TOTAL_LOSS", "WIN_PERCENTAGE")
#   )
#
#   req_and_expect(
#     req = 'MATCH (t1:Team {Name: "Miami"})-[r1:WIN]->(p:Playoff)<-[r2:WIN]-(t2:Team {Name:"San Antonio"})
# RETURN t1,r1,p,r2,t2',
#     con = con,
#     is = "list",
#     length = 5,
#     names = c("t1", "r1", "p", "r2", "t2")
#   )
#   req_and_expect(
#     req = 'MATCH (t1:Team {Name: "Miami"})-[r1:WIN]->(p:Playoff)<-[r2:WIN]-(t2:Team {Name:"San Antonio"})
# RETURN p.Year as Year,r1.Win as Miami,r2.Win as San_Antonio
# ORDER BY p.Year DESC',
#     con = con,
#     is = "list",
#     length = 3,
#     names = c("Year", "Miami", "San_Antonio")
#   )
#   req_and_expect(
#     req = 'MATCH (t1:Team {Name: "Miami"}),(t2:Team {Name:"Portland"}),
# 	p = AllshortestPaths((t1)-[*..14]-(t2))
# RETURN p',
#     con = con,
#     is = "list",
#     length = 1,
#     names = c("p")
#   )
#
#   req_and_expect_graph(
#     req = 'MATCH (t1:Team {Name: "Miami"}),(t2:Team {Name:"Portland"}), p = AllshortestPaths((t1)-[*..14]-(t2)) RETURN p', con = con
#   )
#   # Array type
#   req_and_expect(
#     req = 'MATCH p= AllShortestPaths((t1:Team {Name: "Miami"})-[:WIN*0..14]-(t2:Team {Name:"Portland"}))
# WITH extract(r IN relationships(p)| r.Win) AS RArray
# RETURN RArray',
#     con = con,
#     is = "list",
#     length = 1,
#     names = c("RArray")
#   )
#
#   req_and_expect(
#     req = 'MATCH (t1:Team {Name: "Golden State"}),(t2:Team {Name:"Toronto"}),
# 	p = AllshortestPaths((t1)-[*..14]-(t2))
# RETURN p',
#     con = con,
#     is = "list",
#     length = 1,
#     names = c("p")
#   )
#   req_and_expect(
#     req = 'MATCH (t1:Team {Name: "Golden State"}),(t2:Team {Name:"Toronto"}),
# 	p = AllshortestPaths((t1)-[r:WIN*..14]-(t2))
# WITH r,p,extract(r IN relationships(p)| r.Win ) AS paths
# RETURN paths',
#     con = con,
#     is = "list",
#     length = 1,
#     names = c("paths")
#   )
#   req_and_expect(
#     req = 'MATCH p= AllShortestPaths((t1:Team {Name: "Golden State"})-[:WIN*0..14]-(t2:Team {Name:"Toronto"}))
# WITH extract(r IN relationships(p)| r.Win) AS RArray, LENGTH(p)-1  as s
# RETURN AVG(REDUCE(x = 0, a IN [i IN range(0,s) WHERE i % 2 = 0 | RArray[i] ] | x + a)) - AVG(REDUCE(x = 0, a IN [i IN range(0,s) WHERE i % 2 <> 0 | RArray[i] ] | x + a)) AS NET_WIN',
#     con = con,
#     is = "list",
#     length = 1,
#     names = c("NET_WIN")
#   )
#
#
#   #   req <- call_neo4j('MATCH p= AllShortestPaths((t1:Team {Name: "Golden State"})-[:WIN*0..14]-(t2:Team {Name:"Toronto"}))
#   # WITH extract(r IN relationships(p)| r.Win) AS RArray, LENGTH(p)-1  as s
#   # RETURN AVG(REDUCE(x = 0, a IN [i IN range(0,s) WHERE i % 2 = 0 | RArray[i] ] | x + a)) - AVG(REDUCE(x = 0, a IN [i IN range(0,s) WHERE i % 2 <> 0 | RArray[i] ] | x + a)) AS NET_WIN', con)
#   #   req
# })
