### REQUÊTES ###

# DETERMINER LE NOMBRE DE COLLABORATEURS PAR ETUDIANT DU COURS BIO500 (Figure 1/Histogramme)
requete_histogramme <- "
  SELECT count(etudiant2) AS collaboration_tot  FROM (
    SELECT DISTINCT etudiant1, etudiant2
    FROM collaborations
    INNER JOIN noeuds on collaborations.etudiant1 = noeuds.nom_prenom
    WHERE bio500
)
GROUP BY etudiant1
ORDER BY collaboration_tot DESC
;"

histogramme <- dbGetQuery(con, requete_histogramme)

# REQUETE POUR AVOIR TOUS LES ETUDIANTS FAISANT PARTIE DU COURS BIO500 (Figure 2/Reseau)
requete_bio500 <- "
  SELECT etudiant1, count(etudiant2) AS nb_collaborateurs, etudiant2 FROM (
  SELECT DISTINCT etudiant1, etudiant2
  FROM collaborations
  INNER JOIN noeuds ON collaborations.etudiant1 = noeuds.nom_prenom
  WHERE bio500 == 1
)
GROUP BY etudiant1, etudiant2
;"

bio500 <- dbGetQuery(con, requete_bio500)

# CREER UNE NOUVELLE TABLE POUR ASSOCIER LA COLONNE "ETUDIANT2" À BIO500
write.csv(bio500, file = "bio500.csv")
bd_bio500 <- read.csv("bio500.csv", sep = ",", fileEncoding = "UTF-8-BOM")
dbWriteTable(con, append = TRUE, name = "BIO_5002", value = bd_bio500, row.names = FALSE)

# DETERMINER LES COLLABORATIONS ENTRE "ETUDIANT1" DE BIO500 ET "ETUDIANT2" DE BIO500 (Figure 2/Reseau)
requete_reseau <- "
  SELECT etudiant1, count(etudiant2) AS nb_collaborateurs, etudiant2 FROM (
  SELECT DISTINCT etudiant1, etudiant2
  FROM BIO_5002
  INNER JOIN noeuds ON BIO_5002.etudiant2 = noeuds.nom_prenom
  WHERE bio500 == 1 AND bio5002 == 1
)
GROUP BY etudiant1, etudiant2
;"

reseau <- dbGetQuery(con, requete_reseau)

# DENOMBRER LE NOMBRE DE COLLABORATEURS PAR SESSION POUR CHAQUE ÉTUDIANTS DU COURS BIO500 (TABLEAU)
requete_tableau <- "
  SELECT etudiant1, count(etudiant2) AS nb_collaborateurs, session FROM (
  SELECT DISTINCT etudiant1, etudiant2, session
  FROM collaborations
  INNER JOIN noeuds ON collaborations.etudiant1 = noeuds.nom_prenom
  WHERE bio500 == 1
)
GROUP BY etudiant1, session
;"

tableau <- dbGetQuery(con, requete_tableau)

# DENOMBRER LE NOMBRE DE FOIS QUE DEUX COLLABORATEURS COLLABORENT (Figure3/Boxplot)
requete_shannon <- "
SELECT etudiant1, etudiant2, count(etudiant2) AS nb_collaborations
    FROM collaborations
    INNER JOIN noeuds ON collaborations.etudiant1 = noeuds.nom_prenom
    WHERE bio500 == 1
GROUP BY etudiant1, etudiant2
;"

shannon <- dbGetQuery(con, requete_shannon)