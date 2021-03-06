not_all_na <- function(x) any(!is.na(x))

uvozi.hdi.csv <- function(tabela, stolpci, skip, max) {
  uvoz <- read_csv(tabela,
                    locale = locale(encoding="utf-8"),
                    col_names = stolpci,
                    skip = skip,
                    n_max = max,
                    na = c("", " ", "-", ".."))
  uvoz <- uvoz %>% select_if(not_all_na) %>%
    select(-"HDI Rank (2018)") %>%
    pivot_longer(!Drzava, names_to="Leto", values_to="Stevilo")
  
  uvoz$Leto <- as.numeric(uvoz$Leto)
  uvoz <- uvoz %>% filter(uvoz$Leto >= 1998)
  
  uvoz$Drzava <- str_replace(uvoz$Drzava, " *\\(.*?\\) *", "")
  return(uvoz)
}

## 1. tabela (HDI)
st.hdi <- c("HDI Rank (2018)", "Drzava", 1990:2018)
HDI_drzave_leta <- uvozi.hdi.csv("podatki/HDI_countries_years.csv", st.hdi, 2, 195)

# Funkcija za uvoz csv (Indeksi za leto 2018)
uvozi.csv <- function(tabela, stolpci, skip, max) {
  uvoz <- read_csv(tabela,
                   locale = locale(encoding="utf-8"),
                   col_names = stolpci,
                   skip = skip,
                   n_max = max,
                   na = c("", " ", "-", ".."))
  uvoz <- uvoz %>% select_if(not_all_na) %>%
    select(-"HDI Rank (2018)") %>%
    pivot_longer(!Drzava, names_to="Leto", values_to="Indeks")
  
  uvoz$Leto <- as.numeric(uvoz$Leto)
  uvoz <- uvoz %>% 
    filter(uvoz$Leto == 2018) %>%
    select(-"Leto")
  
  uvoz$Drzava <- str_replace(uvoz$Drzava, " *\\(.*?\\) *", "")
  return(uvoz)
}

## 2. tabela (Education Index)
st.ei <- c("HDI Rank (2018)","Drzava","1990","","1991","","1992","","1993","","1994","","1995","","1996","","1997","","1998","","1999","","2000","","2001","","2002","","2003","","2004","","2005","","2006","","2007","","2008","","2009","","2010","","2011","","2012","","2013","","2014","","2015","","2016","","2017","","2018","")
izobrazba <- uvozi.csv("podatki/education_index.csv", st.ei, 2, 189) %>% 
  rename("Indeks_izobrazbe" = "Indeks")

## 3. tabela (Life Expectancy Index)
st.lei <- c("HDI Rank (2018)","Drzava","1990","","1991","","1992","","1993","","1994","","1995","","1996","","1997","","1998","","1999","","2000","","2001","","2002","","2003","","2004","","2005","","2006","","2007","","2008","","2009","","2010","","2011","","2012","","2013","","2014","","2015","","2016","","2017","","2018","")
zivljenje <- uvozi.csv("podatki/life_expectancy_index.csv", st.lei, 2, 189) %>%
  rename("Indeks_zivljenja" = "Indeks")

## 4. tabela (Income Index)
st.ii <- c("HDI Rank (2018)","Drzava","1990","","1991","","1992","","1993","","1994","","1995","","1996","","1997","","1998","","1999","","2000","","2001","","2002","","2003","","2004","","2005","","2006","","2007","","2008","","2009","","2010","","2011","","2012","","2013","","2014","","2015","","2016","","2017","","2018","")
prihodek <- uvozi.csv("podatki/income_index.csv", st.ii, 2, 191) %>%
  rename("Indeks_prihodka" = "Indeks")

## 5. tabela (Coefficient of human inequality)
st.ineq <- c("HDI Rank (2018)","Drzava","2010","","2011","","2012","","2013","","2014","","2015","","2016","","2017","","2018","")
neenakost <- uvozi.csv("podatki/coefficient_of_human_inequality.csv", st.ineq, 2, 189) %>%
  rename("Koeficient" = "Indeks")

### nov stolpec - Indeks neenakosti
neenakost$"Indeks_neenakosti" <- round(1 - ((neenakost$Koeficient - min(neenakost$Koeficient, na.rm = TRUE))/(max(neenakost$Koeficient, na.rm = TRUE) - min(neenakost$Koeficient, na.rm = TRUE))), digits = 3)

neenakost[neenakost$Drzava == "Comoros",]$Indeks_neenakosti <- 0.01

# Funkcija za uvoz datoteke 'co2 emissions'
uvozi.co2.csv <- function(tabela, stolpci, skip, max) {
  uvoz <- read_csv(tabela,
                   locale = locale(encoding="utf-8"),
                   col_names = stolpci,
                   skip = skip,
                   n_max = max,
                   na = c("", " ", "-", ".."))
  uvoz <- uvoz %>% select(-"Code")
  
  uvoz$Leto <- as.numeric(uvoz$Leto)
  uvoz <- uvoz %>% 
    filter(uvoz$Leto == 2018) %>%
    select(-"Leto")
  return(uvoz)
}

## 6. tabela (CO2 Emissions)
st.co2 <- c("Drzava", "Code", "Leto", "CO2_izpust_per_capita")
izpusti <- uvozi.co2.csv("podatki/co2_emissions_per_capita.csv", st.co2, 1, Inf) 

### nov stolpec - Ekološki indeks
izpusti$"Ekoloski_indeks" <- round(1 - ((izpusti$"CO2_izpust_per_capita" - min(izpusti$"CO2_izpust_per_capita", na.rm = TRUE))/(max(izpusti$"CO2_izpust_per_capita", na.rm = TRUE) - min(izpusti$"CO2_izpust_per_capita", na.rm = TRUE))), digits = 3)

izpusti[izpusti$Drzava == "Qatar",]$"Ekoloski_indeks" <- 0.01

# Funkcija za uvoz datoteke WHO-COVID-19-global-data
uvozi.who.csv <- function(tabela, stolpci, skip, max) {
  uvoz <- read_csv(tabela,
                   locale = locale(encoding="utf-8"),
                   col_names = stolpci,
                   skip = skip,
                   n_max = max,
                   na = c("", " ", "-", ".."))
  uvoz <- uvoz %>% 
    select("Drzava", "Stevilo_primerov_na_milijon")
  uvoz$Drzava <- str_replace(uvoz$Drzava, " *\\(.*?\\) *", "")
  return(uvoz)
}

## 7. tabela (COVID data)
st.cov <- c("Drzava","WHO_Region" ,"Stevilo_primerov" ,"Stevilo_primerov_na_milijon" ,"Cases_in_last_7_days","Cases_in_last_24_hours","Deaths-cumulative_total","Deaths_per_1_million_population","Deaths_in_last_7_days","Deaths_in_last_24_hours","Transmission_Classification")
covid <- uvozi.who.csv("podatki/WHO-COVID-19-global-data.csv", st.cov, 2, Inf) %>% drop_na()

covid$"Indeks_COVID" <- round((1 - ((covid$"Stevilo_primerov_na_milijon" - min(covid$"Stevilo_primerov_na_milijon", na.rm = TRUE)) / (max(covid$"Stevilo_primerov_na_milijon", na.rm = TRUE) - min(covid$"Stevilo_primerov_na_milijon", na.rm = TRUE)))), digits = 5)

covid[covid$Drzava == "Andorra",]$"Indeks_COVID" <- 0.01

### Nekatera imena moramo ročno popraviti, da se bodo tabele ujemale
izpusti[izpusti$Drzava == "Brunei",]$Drzava <- "Brunei Darussalam"
izpusti[izpusti$Drzava == "Cape Verde",]$Drzava <- "Cabo Verde"
izpusti[izpusti$Drzava == "Cote d'Ivoire",]$Drzava <- "Côte d'Ivoire"
izpusti[izpusti$Drzava == "Czech Republic",]$Drzava <- "Czechia"
izpusti[izpusti$Drzava == "Russia",]$Drzava <- "Russian Federation"
izpusti[izpusti$Drzava == "Syria",]$Drzava <- "Syrian Arab Republic"
izpusti[izpusti$Drzava == "Vietnam",]$Drzava <- "Viet Nam"
covid[covid$Drzava == "Kosovo[1]",]$Drzava <- "Kosovo"
covid[covid$Drzava == "occupied Palestinian territory, including east Jerusalem",]$Drzava <- "Palestine, State of"
izpusti[izpusti$Drzava == "Palestine",]$Drzava <- "Palestine, State of"
covid[covid$Drzava == "Republic of Korea",]$Drzava <- "Korea"
izpusti[izpusti$Drzava == "South Korea",]$Drzava <- "Korea"
covid[covid$Drzava == "Republic of Moldova",]$Drzava <- "Moldova"
covid[covid$Drzava == "The United Kingdom",]$Drzava <- "United Kingdom"
covid[covid$Drzava == "United Republic of Tanzania",]$Drzava <- "Tanzania"
covid[covid$Drzava == "United States of America",]$Drzava <- "United States"
izpusti[izpusti$Drzava == "Timor",]$Drzava <- "Timor-Leste"

## 8. tabela (Združimo tabele z indeksi izobrazbe, življenja, prihodka, neenakosti, izpustov in COVIDa)
nov.hdi <- left_join(izobrazba, zivljenje, by='Drzava') %>%
  left_join(., prihodek, by='Drzava') %>%
  left_join(., neenakost, by="Drzava") %>%
  left_join(., izpusti, by="Drzava") %>%
  left_join(., covid, by="Drzava") %>%
  select("Drzava", "Indeks_izobrazbe", "Indeks_zivljenja", "Indeks_prihodka", "Indeks_neenakosti", "Ekoloski_indeks", "Indeks_COVID")

### nova stolpca za star in nov HDI
nov.hdi$"Stari_HDI" <- round((nov.hdi$`Indeks_izobrazbe` * nov.hdi$`Indeks_zivljenja` * nov.hdi$`Indeks_prihodka`) ** (1/3), digits = 3)
nov.hdi$"Novi_HDI" <- round((nov.hdi$`Indeks_izobrazbe` * nov.hdi$`Indeks_zivljenja` * nov.hdi$`Indeks_prihodka` * nov.hdi$`Indeks_neenakosti` * nov.hdi$`Ekoloski_indeks` * nov.hdi$`Indeks_COVID`) ** (1/6), digits = 3)

### Popravimo, kjer je za isto državo več vrstic 
### Filtriramo glede na novi HDI, kar sicer povzroči izbris držav, ki tega podatka nimajo, vendar bomo v nadaljevanju tako ali tako analizirali le tiste države, ki imajo vse podatke
nov.hdi <- nov.hdi %>% 
  group_by(Drzava) %>% 
  filter(Novi_HDI == max(Novi_HDI)) %>% 
  distinct

## 9. tabela (Tabelo nov.hdi prečistimo in spravimo v tidy data)
nov.hdi.tidy <- nov.hdi %>% pivot_longer(c(-Drzava), names_to="Indeks", values_to="Vrednost")

### Sem potrebovala pri COVID tabeli, ko nisem uporabila stolpca 'število primerov na milijon prebivalcev', je pa to koda za uvoz iz html-ja
###   # Uvoz iz HTML (Prebivalstvo)
###   uvozi.html <- function() {
###     url <- "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"
###     stran <- read_html(url) %>% html_table(fill = TRUE)
###     uvoz <- stran[[1]]
###     uvoz <- uvoz %>%
###       rename("Drzava" = "Country(or dependent territory)") %>%
###       rename("Prebivalstvo" = "Population") %>%
###       select("Drzava", "Prebivalstvo")
###     
###     uvoz$Drzava <- str_replace(uvoz$Drzava, " *\\(.*?\\) *", "")
###     uvoz$Drzava <- str_replace(uvoz$Drzava, " *\\[.*?\\] *", "")
###     
###     uvoz$Prebivalstvo <- as.numeric(gsub(",", "", uvoz$Prebivalstvo))
###     return(uvoz)
###   }
###   
###   ## tabela (Prebivalstvo po državah)
###   prebivalstvo <- uvozi.html()
