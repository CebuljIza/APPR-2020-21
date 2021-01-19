library(shiny)

shinyServer(function(input, output) {
  
  output$drzava1 <- renderPlot({
    graf.hdi.drzave <- ggplot(HDI_drzave_leta %>% 
                                filter(Drzava == input$drzava1)) +
      aes(x = Leto, y = Stevilo) + 
      geom_line(size=2, color="forestgreen") +
      geom_point(size=3, color="yellow") +
      ylab("Indeks") +
      xlab("Leto") + 
      scale_x_continuous(breaks = HDI_drzave_leta$Leto, labels = HDI_drzave_leta$Leto) + 
      theme(axis.text.x=element_text(angle=90, size=15, vjust=0.5),
            axis.text.y=element_text(size=15))
    
    print(graf.hdi.drzave)
    })
  
  output$drzava2 <- renderPlot({
    graf.nov.hdi <- ggplot(nov.hdi.tidy %>%
      filter(Drzava == input$drzava2,
             Indeks %in% c("Indeks_neenakosti", "Ekoloski_indeks", "Indeks_COVID", "Stari_HDI", "Novi_HDI"))) +
      aes(x=Drzava, y=Vrednost, fill=Indeks) +
      geom_col(position="dodge") +
      ylab("Vrednost") +
      theme(legend.text=element_text(size=15),
            axis.text.x=element_text(size=20),
            axis.text.y=element_text(size=15))
    
    print(graf.nov.hdi)
  })
  
  # Graf za linearno regresijo oz. napoved
  output$drzava3 <- renderPlot({
    podatki <- HDI_drzave_leta %>% 
      filter(Drzava == input$drzava3)
    
    quadratic <- lm(data = podatki, Stevilo ~ I(Leto) + I(Leto^2))
    leta <- data.frame(Leto=seq(2019, 2025, 1))
    prediction <- mutate(leta, Stevilo=predict(quadratic, leta))
    
    regresija <- podatki %>% 
      ggplot(aes(x=Leto, y=Stevilo)) +
      geom_smooth(method="lm", fullrange=TRUE, color="red", formula=y ~ poly(x,2,raw=TRUE)) +
      geom_point(size=2, color="blue") +
      geom_point(data=prediction %>% filter(Leto >= 2019), color="green3", size=3) +
      scale_x_continuous('Leto', breaks = seq(1998, 2025, 1), limits = c(1998,2025)) +
      ylab("HDI") +
      labs(title = "Napoved HDI") +
      theme(axis.text.x=element_text(angle=90, size=15, vjust=0.5),
            axis.text.y=element_text(size=15))
    
    print(regresija)
  })
})
