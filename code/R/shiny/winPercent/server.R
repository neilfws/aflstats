library(ggplot2)
library(XML)
library(reshape2)
library(zoo)

source("helpers.R")

shinyServer(function(input, output) {
  output$plot1 <- renderPlot({
      if(input$window == "")
        return(NULL)
    plotWinningPercent(input$team, input$years[1], input$years[2], input$window)
  }
, height = 600, width = 800
)
})
