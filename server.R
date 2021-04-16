#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(httr)
library(jsonlite)
library("dplyr")
library(ggplot2)
library(reshape2)
library(plotly)
library(ggplot2)
library(ggthemes)
library(plotly)
urlS <- "http://localhost:4000/api/reporteb/hoja123"
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$distPlot <- renderPlotly({
        bodyS <- toJSON(list(
            list("fecha1"=input$fecha1,
                 "fecha2"=input$fecha2,
                 "fechat1"=input$fecha1,
                 "fechat2"=input$fecha2,
                 "hora"=input$hC,
                 "sitios1"=list(
                     list("sitio"=paste(input$idSitio,"-A-1"))
                 ),
                 "sitios2"=list(
                 )
            )
        )
        , auto_unbox=TRUE)
        # Obtengo el Json de entrada
        r <- POST(urlS, body = bodyS,content_type("application/json"))
        dataS <- content(r)
        
        # Separo las variables
        lec = dataS$h1[[1]]$lecturas
        caudal <- lec[[1]]$caudal
        volumen <- lec[[1]]$volumen
        vola <- lec[[1]]$vola
        flec <- as.Date(lec[[1]]$fechalectura)
        
        for (i in 2:length(lec)){
            caudal <- append(caudal,lec[[i]]$caudal)
            volumen <- append(volumen,lec[[i]]$volumen)
            vola <- append(vola,lec[[i]]$vola)
            flec <- append(flec,as.Date(lec[[i]]$fechalectura))
        }
        
        dataF <- data.frame(flec,volumen,vola,caudal);
        test_data_long <- melt(dataF, id="flec")
        
            ggplotly(
                ggplot(data=test_data_long,
                       aes(x=flec, y=value, colour=variable)) +
                    geom_line(size=1)+
                    geom_point(size=1)
            )
        "
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
        "
    })
    
    output$table <- renderDataTable(
        iris,options = list(
            pageLength = 10,
            initComplete = I("function(settings, json) {alert('Done.');}")
        )
    )

})
