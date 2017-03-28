shinyUI(fluidPage(
  titlePanel("VFL/AFL Teams Winning Percentage"),
  sidebarLayout(
    sidebarPanel(
      p("Calculates a rolling mean of winning percentage for the given team, time interval and game window width."),
      selectInput("team", "Team:", teams, multiple = FALSE, selected = teams[1]),
      sliderInput("years", "Years:", min = 1897, max = 2015, value = c(1897, 2015), sep = ""),
      sliderInput("window", "Game window:", min = 10, max = 100, value = 50, sep = "")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Results", plotOutput("plot1"))
      )
    )
  )
))
