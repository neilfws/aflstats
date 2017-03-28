library(ggplot2)
library(XML)
library(reshape2)

source("helpers.R")

shinyServer(function(input, output) {
  output$plot1 <- renderPlot({
    withProgress(message = "Fetching data...", {
      if(input$player == "")
        return(NULL)
      plotPlayerStats(input$player)
    })
  }, height = 600, width = 800)
})