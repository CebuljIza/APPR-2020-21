# HDI po letih
maxdrz <- HDI_drzave_leta %>%
  filter(Drzava %in% c(max.drzave2000, "Slovenia")) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=1) +
  geom_point(size=2) +
  labs(title="Rast HDI-ja 5 najboljših držav iz leta 2000 in Slovenije") +
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
  labs(title="Negativna rast indeksa") +
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
  labs(title="Rast HDI-ja ZDA v primerjavi z ostalimi") +
  ylab("Indeks") +
  xlab("Leto") +
  scale_x_continuous(breaks = HDI_drzave_leta$Leto, labels = HDI_drzave_leta$Leto) + 
  theme_minimal() +
  theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5))

vzhod <- HDI_drzave_leta %>%
  filter(Drzava %in% c("United States", "United Kingdom", "Hong Kong, China", "Singapore")) %>%
  ggplot(aes(x=Leto, y=Stevilo, color=Drzava)) + 
  geom_line(size=2) +
  labs(title="Razvoj na Zahodu in Vzhodu") +
  ylab("Indeks") +
  xlab("Leto") + 
  scale_x_continuous(breaks = HDI_drzave_leta$Leto, labels = HDI_drzave_leta$Leto) + 
  theme_minimal() +
  theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5)) 

# Zemljevid
zemljevid <- uvozi.zemljevid("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries", encoding = "utf-8")

zem2018 <- tm_shape(merge(zemljevid, leto2018, by.x="NAME_LONG", by.y="Drzava")) +
  tm_polygons("Stevilo", title="HDI leta 2018", palette = c("blue", "lavender", "red"), fill = TRUE) 
# +
#   tm_text("ABBREV", size=0.2)

# Novi HDI
graf.priheko <- ggplot(priheko, aes(Indeks_prihodka, Indeks_izpusta_CO2, color=Drzava)) +
  geom_point() +
  geom_smooth(method="gam", formula = y ~ s(x, bs = "cs"), se=F, color="grey") +
  labs(title = "Povezava med prihodkom in izpustom ogljikovega dioksida") + 
  ylab("Izpust CO2") +
  xlab("Prihodek") +
  theme_minimal() +
  theme(legend.position = "none")

graf.priheko1 <- graf.priheko %>% ggplotly()

##
graf.maxpadec <- maxpadec1 %>%
  filter(Indeks %in% c("Stari_HDI", "Novi_HDI")) %>%
  ggplot(aes(x=Drzava, y=Vrednost, fill=Indeks)) +
  geom_col(position="dodge") +
  labs(title="Najgloblji padec indeksa") +
  ylab("Vrednost") +
  xlab("Država") + 
  theme_minimal() +
  theme(axis.text.x=element_text(angle=45, size=10, vjust=0.5))

graf.maxpadec1 <- graf.maxpadec %>% ggplotly()

graf.maxpadec2 <- maxpadec1 %>%
  filter(Drzava %in% c("Hong Kong, China", "Qatar", "Bahrain", "South Korea", "Liechtenstein"),
         Indeks %in% c("Indeks_neenakosti", "Ekoloski_indeks", "Indeks_COVID")) %>%
  ggplot(aes(x=Drzava, y=Vrednost, fill=Indeks)) +
  geom_col(position="dodge") +
  labs(title="Razlogi za padec indeksa") +
  ylab("Vrednost") +
  xlab("Država") + 
  theme_minimal() +
  theme(axis.text.x=element_text(angle=45, size=10, vjust=0.5))

graf.maxpadec3 <- graf.maxpadec2 %>% ggplotly()

graf.novhdi <- nov.hdi.tidy %>%
  filter(Drzava %in% c("Slovenia", "United States", max.drzave2018),
         Indeks %in% c("Stari_HDI", "Novi_HDI")) %>%
  ggplot(aes(x=Drzava, y=Vrednost, fill=Indeks)) +
  geom_col(position="dodge") +
  labs(title="Stari in novi indeks") +
  ylab("Vrednost") +
  xlab("Država") + 
  theme_minimal() +
  theme(axis.text.x=element_text(angle=45, size=10, vjust=0.5))

graf.novhdi1 <- graf.novhdi %>% ggplotly()

graf.novhdi2 <- nov.hdi.tidy %>%
  filter(Drzava %in% c("Slovenia", "United States", max.drzave2018),
         Indeks %in% c("Indeks_neenakosti", "Ekoloski_indeks", "Indeks_COVID")) %>%
  ggplot(aes(x=Drzava, y=Vrednost, fill=Indeks)) +
  geom_col(position="dodge") +
  labs(title="Razlogi za padec indeksa") +
  ylab("Vrednost") +
  xlab("Država") + 
  theme_minimal() +
  theme(axis.text.x=element_text(angle=45, size=10, vjust=0.5))

graf.novhdi3 <- graf.novhdi2 %>% ggplotly()
