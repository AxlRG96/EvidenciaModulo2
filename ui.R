#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Sistema Integrado de Monitoreo y Manejo de Agua (SIMMA)"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            
            selectInput("idSitio", label = h5("Seleccione Sitio a Graficar"), 
                        choices = list(
                            "Pozo ATR-42" = "SA1", 
                            "Pozo ATR-03" = "SA2", 
                            "Pozo 07-05" = "SA3",
                            "Pozo ATR-47" = "SA4", 
                            "Pozo ATR-33" = "SA5",
                            "Pozo ATR-49" = "SA6",
                            "Pozo ATR-45" = "SA7"
                            ),
                        selected = 1),
            dateInput("fecha1", "Fecha Inicio:", value = "2021-03-01"),
            dateInput("fecha2", "Fecha Final:", value = "2021-03-21"),
            selectInput("hC", label = h5("Seleccione una Hora de Corte"), 
                        choices = list(
                            "1" = "1", 
                            "12" = "12", 
                            "17" = "17",
                            "24" = "24"
                        ),
                        selected = 1),
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Plot", plotlyOutput("distPlot")),
                tabPanel("Summary", verbatimTextOutput("summary")),
                tabPanel("Table", dataTableOutput("table"))
            )
        )
    )
))
