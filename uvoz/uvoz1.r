library(dplyr)
library(tidyr)
library(readr)
library(rvest)
library(gsubfn)
library(openxlsx)
library(readxl)
library(stringr)

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
st.hdi <- c("HDI Rank (2018)", "Drzava", "1990","1991","1992","1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018")
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
  rename("Indeks izobrazbe" = "Indeks")

## 3. tabela (Life Expectancy Index)
st.lei <- c("HDI Rank (2018)","Drzava","1990","","1991","","1992","","1993","","1994","","1995","","1996","","1997","","1998","","1999","","2000","","2001","","2002","","2003","","2004","","2005","","2006","","2007","","2008","","2009","","2010","","2011","","2012","","2013","","2014","","2015","","2016","","2017","","2018","")
zivljenje <- uvozi.csv("podatki/life_expectancy_index.csv", st.lei, 2, 189) %>%
  rename("Indeks zivljenja" = "Indeks")

## 4. tabela (Income Index)
st.ii <- c("HDI Rank (2018)","Drzava","1990","","1991","","1992","","1993","","1994","","1995","","1996","","1997","","1998","","1999","","2000","","2001","","2002","","2003","","2004","","2005","","2006","","2007","","2008","","2009","","2010","","2011","","2012","","2013","","2014","","2015","","2016","","2017","","2018","")
prihodek <- uvozi.csv("podatki/income_index.csv", st.ii, 2, 191) %>%
  rename("Indeks prihodka" = "Indeks")

## 5. tabela (Coefficient of human inequality)
st.ineq <- c("HDI Rank (2018)","Drzava","2010","","2011","","2012","","2013","","2014","","2015","","2016","","2017","","2018","")
neenakost <- uvozi.csv("podatki/coefficient_of_human_inequality.csv", st.ineq, 2, 189)

### nov stolpec - Indeks neenakosti
neenakost$"Indeks neenakosti" <- round(1 - ((neenakost$Stevilo - min(neenakost$Stevilo, na.rm = TRUE) + 0.01)/(max(neenakost$Stevilo, na.rm = TRUE) - min(neenakost$Stevilo, na.rm = TRUE))), digits = 2)

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
st.co2 <- c("Drzava", "Code", "Leto", "CO2 izpust per capita")
izpusti <- uvozi.co2.csv("podatki/co2_emissions_per_capita.csv", st.co2, 1, Inf) 

### nov stolpec - Ekološki indeks
izpusti$"Ekoloski indeks" <- round(1 - ((izpusti$"CO2 izpust per capita" - min(izpusti$"CO2 izpust per capita", na.rm = TRUE) + 0.01)/(max(izpusti$"CO2 izpust per capita", na.rm = TRUE) - min(izpusti$"CO2 izpust per capita", na.rm = TRUE))), digits = 2)

# Funkcija za uvoz datoteke WHO-COVID-19-global-data
uvozi.who.csv <- function(tabela, stolpci, skip, max) {
  uvoz <- read_csv(tabela,
                   locale = locale(encoding="utf-8"),
                   col_names = stolpci,
                   skip = skip,
                   n_max = max,
                   na = c("", " ", "-", ".."))
  uvoz <- uvoz %>% 
    select("Datum", "Drzava", "Stevilo smrti") %>%
    filter(Datum == "2020-11-15")
  uvoz$Drzava <- str_replace(uvoz$Drzava, " *\\(.*?\\) *", "")
  return(uvoz)
}

## 7. tabela (COVID data)
st.cov <- c("Datum", "Country_code", "Drzava", "WHO_region", "New_cases", "Cumulative_cases", "New_deaths", "Stevilo smrti")
covid <- uvozi.who.csv("podatki/WHO-COVID-19-global-data.csv", st.cov, 1, Inf)

# Uvoz iz HTML (Prebivalstvo)
uvozi.html <- function() {
  url <- "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"
  stran <- read_html(url) %>% html_table(fill = TRUE)
  uvoz <- stran[[1]]
  uvoz <- uvoz %>%
    rename("Drzava" = "Country(or dependent territory)") %>%
    rename("Prebivalstvo" = "Population") %>%
    select("Drzava", "Prebivalstvo")
  
  uvoz$Drzava <- str_replace(uvoz$Drzava, " *\\(.*?\\) *", "")
  uvoz$Drzava <- str_replace(uvoz$Drzava, " *\\[.*?\\] *", "")
  
  uvoz$Prebivalstvo <- as.numeric(gsub(",", "", uvoz$Prebivalstvo))
  return(uvoz)
}

## 8. tabela (Prebivalstvo po državah)
prebivalstvo <- uvozi.html()

## 9. tabela (Število COVID smrti na prebivalca - združimo tabeli covid in prebivalstvo)

### Nekatera imena moramo popraviti, da se bosta tabeli ujemali
prebivalstvo[prebivalstvo$Drzava == "Brunei",]$Drzava <- "Brunei Darussalam"
prebivalstvo[prebivalstvo$Drzava == "Cape Verde",]$Drzava <- "Cabo Verde"
prebivalstvo[prebivalstvo$Drzava == "Ivory Coast",]$Drzava <- "Côte d'Ivoire"
prebivalstvo[prebivalstvo$Drzava == "Czech Republic",]$Drzava <- "Czechia"
prebivalstvo[prebivalstvo$Drzava == "F.S. Micronesia",]$Drzava <- "Micronesia"
prebivalstvo[prebivalstvo$Drzava == "Russia",]$Drzava <- "Russian Federation"
prebivalstvo[prebivalstvo$Drzava == "Syria",]$Drzava <- "Syrian Arab Republic"
prebivalstvo[prebivalstvo$Drzava == "Vietnam",]$Drzava <- "Viet Nam"

covid[covid$Drzava == "Democratic Republic of the Congo",]$Drzava <- "DR Congo"
covid[covid$Drzava == "Kosovo[1]",]$Drzava <- "Kosovo"
covid[covid$Drzava == "occupied Palestinian territory, including east Jerusalem",]$Drzava <- "Palestine"
covid[covid$Drzava == "Republic of Korea",]$Drzava <- "South Korea"
covid[covid$Drzava == "Republic of Moldova",]$Drzava <- "Moldova"
covid[covid$Drzava == "The United Kingdom",]$Drzava <- "United Kingdom"
covid[covid$Drzava == "United Republic of Tanzania",]$Drzava <- "Tanzania"
covid[covid$Drzava == "United States of America",]$Drzava <- "United States"

skupaj <- left_join(covid,prebivalstvo,by = "Drzava")
skupaj <- skupaj %>%
  drop_na()

### nov stolpec
skupaj$"Stevilo smrti na 1000 prebivalcev" <- round(((skupaj$"Stevilo smrti" / skupaj$"Prebivalstvo") * 1000), digits = 2)

### nov stolpec z indeksom COVID
skupaj$"Indeks COVID" <- round((1 - ((skupaj$"Stevilo smrti na 1000 prebivalcev" - min(skupaj$"Stevilo smrti na 1000 prebivalcev")) / (max(skupaj$"Stevilo smrti na 1000 prebivalcev") - min(skupaj$"Stevilo smrti na 1000 prebivalcev")))), digits = 2)

## 10. tabela (Združimo tabele z indeksi izobrazbe, življenja, prihodka, neenakosti, izpustov in COVIDa)
nov.hdi <- left_join(izobrazba, zivljenje, by='Drzava') %>%
  left_join(., prihodek, by='Drzava') %>%
  left_join(., neenakost, by="Drzava") %>%
  left_join(., izpusti, by="Drzava") %>%
  left_join(., skupaj, by="Drzava") %>%
  select("Drzava", "Indeks izobrazbe", "Indeks zivljenja", "Indeks prihodka", "Indeks neenakosti", "Ekoloski indeks", "Indeks COVID")


# Ne vem še, če bom potrebovala
# Funkcija za uvoz datoteke 'countries by continents'
uvozi.cont.csv <- function(tabela, stolpci, skip, max) {
  uvoz <- read_csv(tabela,
                   locale = locale(encoding="utf-8"),
                   col_names = stolpci,
                   skip = skip,
                   n_max = max,
                   na = c("", " ", "-", ".."))
  uvoz <- uvoz %>% select("Celina", "Drzava")
  
  uvoz$Drzava <- str_replace(uvoz$Drzava, ",.*", "")
  uvoz$Drzava <- str_replace(uvoz$Drzava, " *\\(.*?\\) *", "")
  return(uvoz)
}

## 11. tabela (Države po celinah)
st.cont <- c("Celina","Continent_Code","Drzava","Two_Letter_Country_Code","Three_Letter_Country_Code","Country_Number")
celine <- uvozi.cont.csv("podatki/countries_by_continents.csv", st.cont, 1, Inf)
