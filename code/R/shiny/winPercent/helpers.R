plotWinningPercent <-function(team, start, end, window) {
  start.date <- as.Date(paste(start, "01", "01", sep = "-"), "%Y-%m-%d")
  end.date   <- as.Date(paste(end, "12", "31", sep = "-"), "%Y-%m-%d")
  team.games <- subset(games, (team1 == team | team2 == team) & Date >= start.date & Date <= end.date)
  team.games$won <- ifelse(team.games$winner == team, 1, 0)
  team.games$won <- ifelse(is.na(team.games$won), 0, team.games$won)
  team.games$roll <- rollmean(team.games$won, as.numeric(window), fill = NA)
  gg <- ggplot(team.games) + geom_point(aes(Date, roll), size = 2, color = "skyblue3") + theme_bw() + labs(x = "Date", y = paste("Percentage (rolling mean over ", window, "games)"), title = team)
  return(gg)
}