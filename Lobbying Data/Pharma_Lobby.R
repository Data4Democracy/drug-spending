require(RPostgreSQL)
pw <- {
  "REDACTED"
}

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv, dbname = "jacob",
                 host = "localhost", port = 5432,
                 user = "jacob", password = pw)
V = function(x) {dbGetQuery(x, conn = con)}
  
V("Drop table if exists LobbyIndus")

V(
"CREATE TABLE LobbyIndus(
    client varchar(50), 
    sub varchar(50), 
    total float, 
    year char (6), 
    catcode varchar(10)
   )
   ")

V("Copy LobbyIndus from '/home/jacob/Data for Democracy/lob_indus.txt' with CSV QUOTE '|' DELIMITER ',';")

V("Create table PharmaLobby as select * from Lobbyindus where catcode in ('H4000', 'H4100', 'H4200', 'H4300', 'H4400', 'H4500');")

write.csv(V("Select * from PharmaLobby;"), file="/home/jacob/Data for Democracy/drug-spending/Lobbying Data/Pharma_Lobby.csv")
