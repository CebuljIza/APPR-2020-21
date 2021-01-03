# tabela za pomoč pri preliminarni analizi
tabela1 <- nov.hdi %>% select("Drzava", "Stari HDI", "Novi HDI")
tabela1$"Padec HDI" <- tabela1$"Stari HDI" - tabela1$"Novi HDI"
tabela1$"Dvig HDI" <- tabela1$"Novi HDI" - tabela1$"Stari HDI"
