# tabela za pomoč pri preliminarni analizi
tabela1 <- nov.hdi %>% select("Drzava", "Stari_HDI", "Novi_HDI")
tabela1$"Padec_HDI" <- tabela1$"Stari_HDI" - tabela1$"Novi_HDI"

# tabela za države leta 2000
leto2000 <- HDI_drzave_leta %>% 
  filter(Leto == 2000) %>%
  select(-"Leto")

tabela3 <- leto2000 %>% arrange(desc(Stevilo)) %>% slice(1:5) 
max.drzave2000 <- as.vector(tabela3$Drzava)

# Novi HDI
## tabela za povezavo med dohodkom in ekološkim indeksom
priheko <- nov.hdi.tidy %>% 
  filter(Indeks %in% c("Indeks_prihodka", "Ekoloski_indeks")) %>%
  pivot_wider(names_from = "Indeks", values_from = "Vrednost")

priheko$"Indeks_izpusta_CO2" <- 1 - priheko$"Ekoloski_indeks"

priheko <- priheko %>% select(-"Ekoloski_indeks")

## največji padec
maxpadec <- tabela1 %>% 
  filter(Padec_HDI >= 0.1)

maxpadec1 <- left_join(maxpadec, nov.hdi) %>% 
  select(-"Padec_HDI") %>%
  pivot_longer(c(-Drzava), names_to="Indeks", values_to="Vrednost")
