### CORRECTION DES DONNEES ORIGINALES ###
#Supprimer les doublons
db_collaborations <- unique(bd_collaborations,incomparables= FALSE)
db_cours <- unique(bd_cours,imcomparable=FALSE)
db_noeuds <- unique(bd_noeuds,incomparable=FALSE)

#Modification des noms ecrit différement dans la table collaborations
db_collaborations[db_collaborations=="arhire_eliza_rebecca"]<-"arhire_eliza"
db_collaborations[db_collaborations=="laberge_anne_ju"]<-"laberge_anneju"
db_collaborations[db_collaborations=="beaupre_raphaeljonathan"]<-"beaupre_jonathanraphael"
db_collaborations[db_collaborations=="beauregard_crystelle"]<-"beauregard_crystel"
db_collaborations[db_collaborations=="laberge_federic"]<-"laberge_frederic"
db_collaborations[db_collaborations=="dagenais_quesnel_benjamin"]<-"dagenaisquesnel_benjamin"
db_collaborations[db_collaborations=="jade_robitaille"]<-"robitaille_jade"
db_collaborations[db_collaborations=="leduc_francois_xavier"]<-"leduc_francoisxavier"
db_collaborations[db_collaborations=="lemaire_florence "]<-"lemaire_florence"
db_collaborations[db_collaborations=="lesperence_laurie"]<-"lesperance_laurie"
db_collaborations[db_collaborations=="lesprerance_laurie"]<-"lesperance_laurie"
db_collaborations[db_collaborations=="michaudeblanc_esther"]<-"michaudleblanc_esther"

#Modification des sessions ecrit differemment dans la table collaborations
db_collaborations[db_collaborations=="H21 "]<-"H21"

#Modification des noms et les cours écrit différement dans la table noeuds
db_noeuds[db_noeuds=="arhire_eliza_rebecca"]<-"arhire_eliza"
db_noeuds[db_noeuds=="laberge_anne_ju"]<-"laberge_anneju"
db_noeuds[db_noeuds=="dagenais_quesnel_benjamin"]<-"dagenaisquesnel_benjamin"
db_noeuds[db_noeuds=="leduc_francois_xavier"]<-"leduc_francoisxavier"
db_noeuds[db_noeuds=="lemaire_florence "]<-"lemaire_florence"
db_noeuds[db_noeuds=="lesprerance_laurie"]<-"lesperance_laurie"
db_noeuds[db_noeuds=="moleculaire"]<-"biologie moleculaire"
db_noeuds[db_noeuds=="ecologie "]<-"ecologie"


# MODIFICATION DE LA TABLE COLLABORATIONS
#Creation de la table collaboration avec etudiant1 et 2 inverser
db_collaborations0.2 <- db_collaborations[, c(2,1,3,4)]
colnames(db_collaborations0.2) <- c("etudiant1", "etudiant2", "sigle", "session")

#Ajout de la table collaboration inverser pour avoir les collaborations des deux etudiants
db_collaborations0.5 <- rbind(db_collaborations, db_collaborations0.2)

#Supprimer les doublons apres modifications
db_collaborations1.0 <- unique(db_collaborations0.5,incomparables= FALSE)
db_cours1.0 <- unique(db_cours,imcomparable=FALSE)
db_noeuds1.0 <- unique(db_noeuds,incomparable=FALSE)

## MODIFICATION DE LA TABLE NOEUDS
#Ajouter une ligne avec Anais dans la table noeud
Anais <- data.frame("nom_prenom" = "nappertdrouin_anais", "annee_debut" = 2018, "session_debut" = "A", "programme" = "ecologie", "coop" = 0, "BIO500" = 1)
#visualiser le data.frame Anais
Anais

#combiner Anais avec db_noeuds
db_noeuds2.0 <- rbind (db_noeuds1.0, Anais)

#Supprimer les doublons d'etudiant dans la table noeuds qui comporte des erreurs (ex: manque de données)
db_noeuds2.1 <- db_noeuds2.0[-c(12, 20, 31, 39, 42, 62, 68, 85, 92, 109, 119, 120, 122, 128),]

#Copie de la colonne BIO500 
colonne_bio500 <- db_noeuds2.1$BIO500

#Transformation de la copie en data.frame
colonne_bio500df <-data.frame(colonne_bio500)

#Nommer la nouvelle colonne avec un nom different
names(colonne_bio500df) [1] <- "BIO5002"

#Integration de la nouvelle colonne (BIO5002) dans la base de donnees noeuds
db_noeuds2.2 <- cbind(db_noeuds2.1, colonne_bio500df)

##Modification de la table cours
#Supression des derniers doublons dans la table cours
install.packages("tidyverse")
library(tidyverse)
db_cours2.0 <- distinct(db_cours1.0, sigle, .keep_all=T)

#Remplacer les NA des stages dans la colonne "credits" par des zeros
db_cours2.0[is.na(db_cours2.0)] <- 0
