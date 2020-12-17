require(ggplot2)
require(dplyr)

HDI_drzave_leta %>%
  filter(Drzava %in% c("Slovenia", "United States", "Iceland")) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=2) +
  labs(title="Primerjava rasti HDI-ja na v Sloveniji, Združenih državah Amerike in na Islandiji") +
  ylab("Indeks") +
  xlab("Leto")

nov.hdi.tidy %>%
  filter(Drzava %in% c("Slovenia", "Belgium", "South Korea", "United Arab Emirates", "Lichtenstein", "India", "Niger"),
         Indeks %in% c("Stari HDI", "Novi HDI")) %>%
  ggplot(aes(x=Drzava, y=Vrednost, fill=Indeks)) +
  geom_col(position="dodge")
