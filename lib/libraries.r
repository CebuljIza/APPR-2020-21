# knjižnice pri uvozu
library(dplyr)
library(tidyr)
library(readr)
library(rvest)
library(gsubfn)
library(openxlsx)
library(readxl)
library(stringr)
library(knitr)
library(gsubfn)
library(doBy) #za fun which.maxn

# knjižnice za vizualizacije
library(tmap) 
library(ggplot2) 
library(leaflet)
library(plotly)

library(shiny)

options(gsubfn.engine="R")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")

