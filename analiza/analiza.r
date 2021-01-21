# 4. faza: Analiza podatkov

podatki <- HDI_drzave_leta %>% 
  filter(Drzava == "Germany")

# Regresija oz. napoved

quadratic <- lm(data = podatki, Stevilo ~ I(Leto))
leta <- data.frame(Leto=seq(2019, 2025, 1))
prediction <- mutate(leta, Stevilo=predict(quadratic, leta))

regresija <- podatki %>% 
  ggplot(aes(x=Leto, y=Stevilo)) +
  geom_smooth(method="lm", fullrange=TRUE, color="red", formula=y ~ x) +
  geom_point(size=2, color="blue") +
  geom_point(data=prediction %>% filter(Leto >= 2019), color="green3", size=3) +
  scale_x_continuous('Leto', breaks = seq(1998, 2025, 1), limits = c(1998,2025)) +
  ylab("HDI") +
  labs(title = "Napoved HDI") +
  theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5))

# Ta graf bom vključila v Shiny aplikacijo.


