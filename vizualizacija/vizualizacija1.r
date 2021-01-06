require(ggplot2)
require(dplyr)
library(shiny)
library(tmap)
library(leaflet)

# preliminarna analiza
graf1 <- HDI_drzave_leta %>%
  filter(Drzava %in% c("Slovenia", "United States", "Iceland")) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=2) +
  labs(title="Primerjava rasti HDI-ja na v Sloveniji, Združenih državah Amerike in na Islandiji") +
  ylab("Indeks") +
  xlab("Leto")

graf2 <- nov.hdi.tidy %>%
  filter(Drzava %in% c("Slovenia", "South Korea", "India", "Niger", "Hong Kong, China", "Andorra", "Qatar"),
         Indeks %in% c("Stari HDI", "Novi HDI")) %>%
  ggplot(aes(x=Drzava, y=Vrednost, fill=Indeks)) +
  geom_col(position="dodge")

#HDI po letih
slonor <- HDI_drzave_leta %>%
  filter(Drzava %in% c("Slovenia","Norway")) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=2) +
  labs(title="Rast HDI-ja v Sloveniji in na Norveškem") +
  ylab("Indeks") +
  xlab("Leto")

mindrz <- HDI_drzave_leta %>%
  filter(Drzava %in% c(min.drzave2000)) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=1) +
  geom_point(size=2) +
  labs(title="Rast HDI-ja najšibkejših držav") +
  ylab("Indeks") +
  xlab("Leto") +
  scale_x_continuous(breaks = HDI_drzave_leta$Leto, labels = HDI_drzave_leta$Leto) + 
  theme_minimal() +
  theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5))

negrast <- HDI_drzave_leta %>%
  filter(Drzava %in% c("Lebanon", "Libya", "Syrian Arab Republic", "South Sudan", "Venezuela", "Yemen")) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=1) +
  geom_point(size=2) +
  labs(title="Države z negativno rastjo indeksa") +
  ylab("Indeks") +
  xlab("Leto") + 
  scale_x_continuous(breaks = HDI_drzave_leta$Leto, labels = HDI_drzave_leta$Leto) + 
  theme_minimal() +
  theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5)) 

maxdrz <- HDI_drzave_leta %>%
  filter(Drzava %in% max.drzave2000) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=1) +
  geom_point(size=2) +
  labs(title="Rast HDI-ja 5 najboljših držav iz leta 2000") +
  ylab("Indeks") +
  xlab("Leto") +
  scale_x_continuous(breaks = HDI_drzave_leta$Leto, labels = HDI_drzave_leta$Leto) + 
  theme_minimal() +
  theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5))

zda <- HDI_drzave_leta %>%
  filter(Drzava %in% c("United States", "Switzerland", "Germany", "Ireland", "Denmark", "Iceland")) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=1) +
  geom_point(size=2) +
  labs(title="Rast HDI-ja Združenih držav v primerjavi z ostalimi") +
  ylab("Indeks") +
  xlab("Leto") +
  scale_x_continuous(breaks = HDI_drzave_leta$Leto, labels = HDI_drzave_leta$Leto) + 
  theme_minimal() +
  theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5))

vzhod <- HDI_drzave_leta %>%
  filter(Drzava %in% c("United States", "United Kingdom", "Hong Kong, China", "Singapore")) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=2) +
  labs(title="Prenos moči z zahoda na vzhod") +
  ylab("Indeks") +
  xlab("Leto") + 
  scale_x_continuous(breaks = HDI_drzave_leta$Leto, labels = HDI_drzave_leta$Leto) + 
  theme_minimal() +
  theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5)) 

# Zemljevid
zemljevid <- uvozi.zemljevid("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries", encoding = "utf-8")

zem2018 <- tm_shape(merge(zemljevid, leto2018, by.x="NAME_LONG", by.y="Drzava")) +
  tm_polygons("Stevilo", title="HDI leta 2018", palette = c("blue", "lavender", "red"), fill = TRUE) +
  tm_text("ABBREV", size=0.5)