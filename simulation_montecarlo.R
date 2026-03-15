# Un patient attend 2mn en moyenne, je defini mon parametre lambda en consequence
# Je defini egalement la taille de mon echantillon pour les futures simulations 
lambda = 0.5
n = 1000

# Je "fixe la graine". Cela garantit la reproductilibite de l'experience
# Sans cette "graine" on ne pourrait par exemple pas savoir si une variation dur
# resultat est due a une modif du code ou bien au hasard 
set.seed(69)

# Maintenant je simule mes 1000 temps intzr-arrivees qui suivent une loi 
# exponentielle de parametre 0.5
temps_inter_arrivees = rexp(n, lambda)

# Je veux desormais la moyenne et l'ecart type observés de cet echantillon afin
# de pouvoir les comparer avec les theoriques
moyenne_observee = mean(temps_inter_arrivees)
ecartype_observee = sd(temps_inter_arrivees)

moyenne_theorique = 1/lambda
ecartype_theorique = 1/lambda

# J'affiche mes resultats
cat("Comparaison moyenne", "\n")
cat("Moyenne observée", moyenne_observee, " Moyenne théorique :", 
    moyenne_theorique,"\n")
cat("Ecart :", abs(moyenne_observee - moyenne_theorique), "\n")

cat("Comparaison ecart-type", "\n")
cat("Ecart-type observée", ecartype_observee, " Ecart-type théorique :", 
    ecartype_theorique, "\n")
cat("Ecart :", abs(ecartype_observee - ecartype_theorique), "\n")


# Je genere mes durees de prelevements (loi normale)
moyenne_prelevement = 5
ecartype_prelevement = 1.2

durees_prelevement = rnorm(n,moyenne_prelevement, ecartype_prelevement)

cat("\nDurée moyenne théorique :", moyenne_prelevement, "min\n")
cat("Durée moyenne simulée   :", round(mean(durees_prelevement), 3), "min\n")

# Je verifie que mes temps inter-arrivees suivent bien une loi exponentielle
# en construisant un qq plot
donnees_triees = sort(temps_inter_arrivees)
p = (1:n) / (n + 1)  # probabilités de 0 à 1
quantiles_theoriques_exp = qexp(p, rate = lambda)

png("graphiques/qqplot_exponentielle.png") # Je me cree un png
plot(quantiles_theoriques_exp, donnees_triees,
     main = "QQ-Plot : Temps inter-arrivées vs Loi Exponentielle",
     xlab = "Quantiles théoriques (Exp)",
     ylab = "Quantiles observés",
     col = "blue")
abline(0, 1, col = "red")
dev.off() # pour pas que mon png sois bugger

# qq plot pour les durees prelevement sauf que cette fois pas besoin de faire
# tout a la main on a une fonction qqnorm()
# QQ-Plot pour vérifier si les durées suivent une loi Normale

png("graphiques/qqplot_normale.png")
qqnorm(durees_prelevement,
       main = "QQ-Plot : Durées de prélèvement vs Loi Normale",
       col = "blue")
qqline(durees_prelevement, col = "red")
dev.off()


# oN VA DESORMAIS REALISER UN PP PLOT POUR LES DUREE INTER ARRIVEES
# Probabilités cumulées observées (rang / n+1)
prob_observees = (1:n) / (n + 1)

# Probabilités cumulées théoriques : pexp() = fonction de répartition
prob_theoriques_exp = pexp(donnees_triees, rate = lambda)

png("graphiques/ppplot_exponentielle.png")
plot(prob_theoriques_exp, prob_observees,
     main = "PP-Plot : Temps inter-arrivées vs Loi Exponentielle",
     xlab = "Probabilités théoriques (Exp)",
     ylab = "Probabilités observées",
     col = "blue")
abline(0, 1, col = "red")
dev.off()

# On realisemaintenant le PP Plot pour les durées de prelevement

durees_triees = sort(durees_prelevement)
prob_theoriques_norm = pnorm(durees_triees, mean = moyenne_prelevement, 
                              sd = ecartype_prelevement)

png("graphiques/ppplot_normale.png")
plot(prob_theoriques_norm, prob_observees,
     main = "PP-Plot : Durées de prélèvement vs Loi Normale",
     xlab = "Probabilités théoriques (Normale)",
     ylab = "Probabilités observées",
     col = "blue")
abline(0, 1, col = "red")
dev.off()
