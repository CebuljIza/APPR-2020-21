# tabela za pomoč pri preliminarni analizi
tabela1 <- nov.hdi %>% select("Drzava", "Stari HDI", "Novi HDI")
tabela1$"Padec HDI" <- tabela1$"Stari HDI" - tabela1$"Novi HDI"
tabela1$"Dvig HDI" <- tabela1$"Novi HDI" - tabela1$"Stari HDI"

# tabela za države leta 2000
leto2000 <- HDI_drzave_leta %>% filter(Leto == 2000) %>%
  select(-"Leto")

library(doBy)

tabela3 <- leto2000[c(which.maxn(leto2000$Stevilo, n=5)),] 
max.drzave2000 <- as.vector(tabela3$Drzava)

tabela4 <- leto2000[c(which.minn(leto2000$Stevilo, n=5)),]
min.drzave2000 <- as.vector(tabela4$Drzava)

leto2018 <- HDI_drzave_leta %>% 
  filter(Leto == 2018) %>%
  select(-"Leto")
