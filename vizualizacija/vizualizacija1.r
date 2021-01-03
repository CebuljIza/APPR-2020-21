require(ggplot2)
require(dplyr)
library(shiny)

# preliminarna analiza
HDI_drzave_leta %>%
  filter(Drzava %in% c("Slovenia", "United States", "Iceland")) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=2) +
  labs(title="Primerjava rasti HDI-ja na v Sloveniji, Združenih državah Amerike in na Islandiji") +
  ylab("Indeks") +
  xlab("Leto")

nov.hdi.tidy %>%
  filter(Drzava %in% c("Slovenia", "South Korea", "India", "Niger", "Hong Kong, China", "Andorra", "Qatar"),
         Indeks %in% c("Stari HDI", "Novi HDI")) %>%
  ggplot(aes(x=Drzava, y=Vrednost, fill=Indeks)) +
  geom_col(position="dodge")

#HDI po letih
HDI_drzave_leta %>%
  filter(Drzava %in% c("Slovenia","Norway", "Iceland")) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=2) +
  labs(title="Rast HDI-ja v Sloveniji in na Norveškem") +
  ylab("Indeks") +
  xlab("Leto")

HDI_drzave_leta %>%
  filter(Drzava %in% c("United States", "Iceland", "Hong Kong, China", "Singapore", "Denmark")) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=1) +
  labs(title="Indeks Združenih držav Amerike glede na ostale države") +
  ylab("Indeks") +
  xlab("Leto") + 
  geom_point(size=2) + 
  scale_x_continuous(breaks = HDI_drzave_leta$Leto, labels = HDI_drzave_leta$Leto) + 
  theme_minimal() +
  theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5)) 

