library(dplyr)
library(tidyr)
library(readr)
library(rvest)
library(gsubfn)
library(openxlsx)
library(readxl)
library(stringr)

not_all_na <- function(x) any(!is.na(x))

uvozi.csv <- function(tabela, stolpci, skip, max) {
  uvoz <- read_csv(tabela,
                    locale = locale(encoding="utf-8"),
                    col_names = stolpci,
                    skip = skip,
                    n_max = max,
                    na = c("", " ", "-", ".."))
  uvoz <- uvoz %>% select_if(not_all_na) %>%
    select(-"HDI Rank (2018") %>%
    pivot_longer(!Drzava, names_to="Leto", values_to="Stevilo")
  
  uvoz$Leto <- as.numeric(uvoz$Leto)
  uvoz <- uvoz %>% filter(uvoz$Leto >= 1998)
  
  uvoz$Drzava <- str_replace(uvoz$Drzava, " *\\(.*?\\) *", "")
  return(uvoz)
}

## 1. tabela (HDI)
st.hdi <- c("HDI Rank (2018)", "Drzava", "1990","1991","1992","1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018")
HDI_drzave_leta <- uvozi.csv("podatki/HDI_countries_years.csv", st.hdi, 2, 195)
HDI_drzave_leta %>% View

## 2. tabela (Education Index)
st.ei <- c("HDI Rank (2018)","Drzava","1990","","1991","","1992","","1993","","1994","","1995","","1996","","1997","","1998","","1999","","2000","","2001","","2002","","2003","","2004","","2005","","2006","","2007","","2008","","2009","","2010","","2011","","2012","","2013","","2014","","2015","","2016","","2017","","2018","")
izobrazba <- uvozi.csv("podatki/education_index.csv", st.ei, 2, 189) 
izobrazba %>% View

## 3. tabela (Life Expectancy Index)
st.lei <- c("HDI Rank (2018)","Drzava","1990","","1991","","1992","","1993","","1994","","1995","","1996","","1997","","1998","","1999","","2000","","2001","","2002","","2003","","2004","","2005","","2006","","2007","","2008","","2009","","2010","","2011","","2012","","2013","","2014","","2015","","2016","","2017","","2018","")
zivljenje <- uvozi.csv("podatki/life_expectancy_index.csv", st.lei, 2, 189) 
zivljenje %>% View

## 4. tabela (Income Index)
st.ii <- c("HDI Rank (2018)","Drzava","1990","","1991","","1992","","1993","","1994","","1995","","1996","","1997","","1998","","1999","","2000","","2001","","2002","","2003","","2004","","2005","","2006","","2007","","2008","","2009","","2010","","2011","","2012","","2013","","2014","","2015","","2016","","2017","","2018","")
prihodek <- uvozi.csv("podatki/income_index.csv", st.ii, 2, 191)
prihodek %>% View

## 5. tabela (Coefficient of human inequality)
st.ineq <- c("HDI Rank (2018)","Drzava","2010","","2011","","2012","","2013","","2014","","2015","","2016","","2017","","2018","")
neenakost <- uvozi.csv("podatki/coefficient_of_human_inequality.csv", st.ineq, 2, 189)
neenakost %>% View

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
  uvoz <- uvoz %>% filter(uvoz$Leto >= 1998)
  return(uvoz)
}

## 6. tabela (CO2 Emissions)
st.co2 <- c("Drzava", "Code", "Leto", "CO2 izpust per capita")
izpusti <- uvozi.co2.csv("podatki/co2_emissions_per_capita.csv", st.co2, 1, Inf) 
izpusti %>% View

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
covid %>% View

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

## 8. tabela (Države po celinah)
st.cont <- c("Celina","Continent_Code","Drzava","Two_Letter_Country_Code","Three_Letter_Country_Code","Country_Number")
celine <- uvozi.cont.csv("podatki/countries_by_continents.csv", st.cont, 1, Inf)
celine %>% View

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

# 9. tabela (Prebivalstvo po državah)
prebivalstvo <- uvozi.html()
prebivalstvo %>% View
