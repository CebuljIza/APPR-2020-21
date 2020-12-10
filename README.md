# Analiza podatkov s programom R, 2020/21

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2020/21

* [![Shiny](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/CebuljIza/APPR-2020-21/master?urlpath=shiny/APPR-2020-21/projekt1.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/CebuljIza/APPR-2020-21/master?urlpath=rstudio) RStudio

## Tematika

### Analiza indeksa človekovega razvoja (HDI)

##### Opis 
Indeks človekovega razvoja je primerjalno merilo za države.
Ustvarjen je bil z namenom ocenjevati in primerjati revščino po širših merilih kot le na podlagi dohodkov.

Izračunan je glede na podatke o:
* zdravju (indeks pričakovane življenjske dobe, LEI), 
* izobrazbi (indeks izobrazbe, EI) in 
* dohodku per capita (BNDpc po pariteti kupne moči, II). 

HDI je geometrijsko povprečje teh treh komponent: <img src="https://render.githubusercontent.com/render/math?math=HDI = \sqrt[3]{LEI * EI * II}">

Kljub temu pa indeks predstavlja nekaj problemov, saj ne upošteva revščine oz. ekonomske neenakosti znotraj države ali neenakosti med spoloma, visok HDI pa je tudi tesno povezan z visokim ekološkim odtisom, kar pa za razvoj gospodarstva in kvaliteto življenja v prihodnosti ni dobro.

##### Podatkovni viri
Podatkovne vire sem zbrala v mapi **podatki**. So v obliki CSV datotek, ki sem jih pridobila s spletnih strani [Razvojnega programa Združenih narodov](http://hdr.undp.org/en/data#), [Our World in Data](https://ourworldindata.org/co2-emissions) in [Svetovne zdravstvene organizacije](https://covid19.who.int/table).

##### Podatkovno delo
* **analiza HDI** (podatki v tabeli [HDI_countries_years.csv](podatki/HDI_countries_years.csv)) po letih
  * izris zemljevidov
* **problematizacija HDI** - izračunala bi nov indeks HDI, ki bi vključeval še druge spremenljivke, ki kažejo na dobro razvito državo:
  * izpust ogljikovega dioksida v tonah, per capita (tabela [co2_emissions_per_capita.csv](podatki/co2_emissions_per_capita.csv))
  * neenakost med prebivalci v zdravju, izobrazbi in prihodku (tabela [coefficient_of_human_inequality.csv](podatki/coefficient_of_human_inequality.csv))
  * odziv in soočanje z novim koronavirusom glede na celotno število primerov (tabela [WHO-COVID-19-global-data.csv](podatki/WHO-COVID-19-global-data.csv)), tu bi s pomočjo tabele [celotnega prebivalstva](podatki/WPP2019_TotalPopulationBySex.csv) izračunala delež primerov (ali smrti) glede na celotno prebivalstvo
  
Za vsako od novih spremenljivk bom izračunala indeks, ki ga bom potem uporabila pri računanju novega HDI: <img src="https://render.githubusercontent.com/render/math?math=INDEX = 1 - \frac{vrednost - vrednost_{min}}{vrednost_{max} - vrednost_{min}}">. Indeks je 1, ko je vrednost najmanjša in 0, ko je vrednost največja.
  
Potem bom izračunala geometrijsko sredino šestih indeksov in primerjala nov HDI s starim, da bom ugotovila, kako nove spremenljivke vplivajo na indeks človekovega razvoja. 
  
##### Analiza podatkov in cilj projekta
Analizirala bom **človekov razvoj zadnjih 20 let**, kdaj je rastel/padal, kdaj je kakšna država po razvoju prehitela druge ter kako so na indeks vplivali takratni dogodki (krize, vojne, bolezni, tehnološki napredek). 

Izračunala bom **nov HDI**, ki bo upošteval spremenljivke, povezane z ekologijo, neenakostjo in odzivom na COVID-19, saj so to trenutno zelo pomembni indikatorji za razvitost držav, ki pa jih HDI še ne upošteva.

Cilj projekta je dobiti vpogled v razvoj sveta glede na čas in države ter pokazati, da kljub temu, da je trenutno najbolj dopolnjeno merilo, indeks človekovega razvoja vseeno ni najboljši kriterij. Izboljšati se ga da z dodajanjem novih spremenljivk, ki prav tako vplivajo na človekov razvoj. 

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `rgeos` - za podporo zemljevidom
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `tidyr` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `tmap` - za izrisovanje zemljevidov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-202021)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
