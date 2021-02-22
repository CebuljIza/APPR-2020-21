library(shiny)

shinyUI(fluidPage(
  navbarPage("Analiza indeksa",
             tabPanel("Rast po letih",
                      titlePanel("Rast indeksa po letih"),
                      sidebarPanel(
                        selectInput(inputId = "drzava1", 
                                    label = "Izberi državo",
                                    choices = unique(HDI_drzave_leta$Drzava))),
                      mainPanel(plotOutput("drzava1"))),
             
             tabPanel("Analiza novega HDI",
                      titlePanel("Razlogi za dvig ali padec indeksa"),
                      sidebarPanel(
                        selectInput(inputId = "drzava2",
                                    label = "Izberi državo",
                                    choices = unique(nov.hdi.tidy$Drzava))),
                      mainPanel(plotOutput("drzava2"))),
             
             tabPanel("Napoved",
                      titlePanel("Napoved HDI"),
                      sidebarPanel(
                        selectInput(inputId = "drzava3",
                                    label = "Izberi državo",
                                    choices = unique(HDI_drzave_leta$Drzava))),
                      mainPanel(plotOutput("drzava3")))
)))
