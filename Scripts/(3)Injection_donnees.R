### INJECTION DES DONNEES ###

# INSTALLER LE PACKAGE SQLITE
install.packages('RSQLite')
library(RSQLite)

# OUVRIR LA CONNECTION 
con <- dbConnect(SQLite(), dbname="projetspikee.db")

# CREER LES TABLES SQL
# Creer la table noeuds
noeuds_sql <- '
  CREATE TABLE noeuds (
  nom_prenom VARCHAR(50),
  annee_debut DATE,
  session_debut CHAR(1),
  programme VARCHAR(50),
  coop BOLEAN,
  bio500 BOLEAN,
  bio5002 BOLEAN,
  PRIMARY KEY (nom_prenom)
);'

dbSendQuery(con, noeuds_sql)

# Creer la table collaborations
collaborations_sql <- '
  CREATE TABLE collaborations (
  etudiant1 VARCHAR(50),
  etudiant2 VARCHAR(50),
  sigle CHAR(6),
  session CHAR(3),
  PRIMARY KEY (etudiant1, etudiant2, sigle, session),
  FOREIGN KEY (etudiant1) REFERENCES noeuds(nom_prenom),
  FOREIGN KEY (etudiant2) REFERENCES noeuds(nom_prenom),
  FOREIGN KEY (sigle) REFERENCES cours(sigle)
);'

dbSendQuery(con, collaborations_sql)

# Creer la table cours
cours_sql <- '
  CREATE TABLE cours (
  sigle CHAR(6) NOT NULL,
  credits INTEGER NOT NULL,
  obligatoire BOLEAN,
  laboratoire BOLEAN,
  distance BOLEAN,
  groupes BOLEAN,
  libre BOLEAN,
  PRIMARY KEY (sigle, distance)
);'

dbSendQuery(con, cours_sql)

# VERIFIER LA PRESENCE DES 3 TABLES DANS LE SERVEUR SQL
dbListTables(con)

# INJECTION DES DONNEES DANS LES TABLES SQL
dbWriteTable(con, append = TRUE, name = "noeuds", value = db_noeuds2.2, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "collaborations", value = db_collaborations1.0, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "cours", value = db_cours2.0, row.names = FALSE)
