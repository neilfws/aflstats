getPlayers <- function() {
  l <- list()
  players <- read.table("data/allplayers.tsv", header = FALSE, stringsAsFactors = FALSE, sep = "\t")
  for(i in 1:nrow(players)) {
    label <- paste(players$V1[i], players$V2[i], sep = ": ")
    value <- players$V3[i]
    l[[label]] <- value
  }
  return(l)
}

shinyUI(fluidPage(
  titlePanel("Player Statistics"),
  sidebarLayout(
    sidebarPanel(
      h4("How to use it"),
      p("Click in the Player box and delete to clear, start typing a player name and select from the choices shown. Plot will appear in the right-hand panel; may take a few seconds to appear."),
      selectizeInput("player", "Player:", choices = getPlayers())
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Results", plotOutput("plot1"))
      )
    )
  )
))