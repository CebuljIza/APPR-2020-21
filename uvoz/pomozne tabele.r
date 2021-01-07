# tabela za pomoč pri preliminarni analizi
tabela1 <- nov.hdi %>% select("Drzava", "Stari_HDI", "Novi_HDI")
tabela1$"Padec_HDI" <- tabela1$"Stari_HDI" - tabela1$"Novi_HDI"
tabela1$"Dvig_HDI" <- tabela1$"Novi_HDI" - tabela1$"Stari_HDI"

# tabela za države leta 2000
leto2000 <- HDI_drzave_leta %>% filter(Leto == 2000) %>%
  select(-"Leto")

tabela3 <- leto2000[c(which.maxn(leto2000$Stevilo, n=5)),] 
max.drzave2000 <- as.vector(tabela3$Drzava)

tabela4 <- leto2000[c(which.minn(leto2000$Stevilo, n=5)),]
min.drzave2000 <- as.vector(tabela4$Drzava)

leto2018 <- HDI_drzave_leta %>% 
  filter(Leto == 2018) %>%
  select(-"Leto")

# Novi HDI

priheko <- nov.hdi.tidy %>% 
  filter(Indeks %in% c("Indeks_prihodka", "Ekoloski_indeks")) %>%
  pivot_wider(names_from = "Indeks", values_from = "Vrednost")

priheko$"Indeks_izpusta_CO2" <- 1 - priheko$"Ekoloski_indeks"

priheko <- priheko %>% select(-"Ekoloski_indeks")

## največji padec
maxpadec <- tabela1[c(which.maxn(tabela1$Padec_HDI, n=10)),]

maxpadec1 <- left_join(maxpadec, nov.hdi) %>% 
  select(-"Padec_HDI", -"Dvig_HDI") %>%
  pivot_longer(c(-Drzava), names_to="Indeks", values_to="Vrednost")

## največja rast
maxrast <- tabela1[c(which.maxn(tabela1$Dvig_HDI, n=10)),]

maxrast1 <- left_join(maxrast, nov.hdi) %>% 
  select(-"Padec_HDI", -"Dvig_HDI") %>%
  pivot_longer(c(-Drzava), names_to="Indeks", values_to="Vrednost")

tabela5 <- leto2018[c(which.maxn(leto2018$Stevilo, n=6)),] %>%
  filter(Drzava != "Hong Kong, China")
max.drzave2018 <- as.vector(tabela5$Drzava)
