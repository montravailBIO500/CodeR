### PRODUCTION DES FIGURES ET DU TABLEAU ###

# CREATION DE LA FIGURE 1 (HISTOGRAMME)
# Creation d'une matrice
matrice_histogramme <- data.matrix(histogramme, rownames.force = NA)

# Histogramme des frequences du nombre de collaborateurs
pdf(file= "Figure1_hist.pdf")
hist(matrice_histogramme,
     main=" ",
     xlab="Nombre de collaborateurs",
     ylab="Fréquence du nombre de collaborateurs",
     breaks=20,
     xlim=c(0,26),
     col="darkgreen",
     axe=F
)
box(bty="l")
axis(1)
axis(2)
dev.off()

# CREATION DE LA FIGURE 2 (RÉSEAU)
# Creation d'une matrice d'adjacence
tableau_reseau <- table(reseau[,c(1,3)])
reseau.bio500 <- as.matrix(tableau_reseau)

# Verification des dimensions de la matrice
dim(reseau.bio500)

# Installation du package necessaire au réseau
install.packages("igraph")
library(igraph)

# Creation de la figure
g <- graph.adjacency(reseau.bio500)
plot(g)

# Ajustement des parametres de la figure
plot(g, vertex.label= NA, edge.arrow.mode = 0,
     vertex.frame.color= NA)
deg <- apply(reseau.bio500, 2, sum) + apply(reseau.bio500, 1, sum)
rk <- rank(deg)
col.vec <- heat.colors(60)
V(g)$color = col.vec[rk]
reg <- degree(g, mode="all")

pdf(file= "Figure2_reseau.pdf")
plot(g,
     main =" ",
     edge.arrow.size = .1,
     vertex.frame.color= NA, vertex.size = reg*0.3,
     vertex.label.color="black",
     edge.color="grey",
     rescale=FALSE, asp=0,
     layout = layout.circle(g))
dev.off()

# CREATION DU TABLEAU
# Rearranger le tableau pour avoir les sessions en colonnes
tableau2 <- tableau %>%
  pivot_wider(names_from = session, values_from=nb_collaborateurs)

# Tranformer la colonne "etudiant1" en noms de ligne
tableau3 <- as.data.frame(tableau2)
rownames(tableau3) <- tableau3[,1]
tableau3[,1] <- NULL

# Remplacer les "NA" du tableau par des zeros
tableau3[is.na(tableau3)] <- 0

# Arranger les colonnes sessions en ordre chronologique
tableau4 <- tableau3[,c(7,3,8,1,5,2,6,4)]

# Ajouter les moyennes par session au tableau
moyennes_colonnes <- colMeans(tableau4)
tableau5 <- rbind(tableau4, moyennes_colonnes)
rownames(tableau5)[42] <- "Moyennes"

# Ajouter les moyennes par etudiant au tableau
moyennes_lignes <- rowMeans(tableau5)
tableau6 <- cbind(tableau5, moyennes_lignes)
colnames(tableau6)[9] <- "Moyennes"

# Changer les nombres decimals en nombres entiers
tableau7 <- round(tableau6, digits = 0)
tableau7

# Créer un tableau exportable dans LaTex
install.packages("xtable")
library(xtable)
print(xtable(tableau7, type = "latex", digits = 0), file = "tableau.tex")

# CREATION DE LA FIGURE 3 (BOXPLOT DE LA DIVERSITÉ)
# Rearranger le tableau pour avoir les sessions en colonnes
shannon2 <- shannon %>%
  pivot_wider(names_from = etudiant2, values_from=nb_collaborations)

# Tranformer la colonne "etudiant1" en noms de lignes
shannon3 <- as.data.frame(shannon2)
rownames(shannon3) <- shannon3[,1]
shannon3[,1] <- NULL

# Remplacer les "NA" du tableau par des zeros
shannon3[is.na(shannon3)] <- 0

# Installation du package pour calculer la diversite
install.packages("vegan")
library(vegan)

# Calculer l'indice de diversite de Shannon par etudiant
indice_shannon <- diversity(shannon3, index="shannon", MARGIN=1, base=exp(1))

# Faire le boxplot de la diversite de Shannon de toute la classe BIO500
df_shannon <- as.data.frame(indice_shannon)
par(mar = c(5,6,2,1))
par(mfrow = c(1,1))

pdf(file="Figure3_shannon.pdf")
boxplot <- boxplot(df_shannon,
            xlab = "Étudiants du cours BIO500",
            ylab = "Indice de diversité de Shannon",
            col = "darkgreen",
            border = "darkblue",
            notch = TRUE,
            axes=F
)
box(bty="l")
axis(2)
dev.off()
