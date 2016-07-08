setwd("~/Dropbox/projects/aflstats/")
source("code/R/afltables.R")
require(ggplot2)

# university 1908-1914
# and yes it is "bullldogs" with 3x "l"
teams <- c("adelaide", "brisbaneb", "brisbanel", "carlton", "collingwood", "essendon",
           "fitzroy", "fremantle", "geelong", "goldcoast", "gws",
           "hawthorn", "melbourne", "kangaroos", "padelaide", "richmond",
           "stkilda", "swans", "university", "westcoast", "bullldogs")

for(team in teams) {
  print(team)
  team.games <- allGames(team)
  team.games$DateTime <- allGamesDateTime(team.games)
  team.games$date     <- allGamesDate(team.games)
  team.games$Year     <- allGamesYear(team.games)
  team.games$Goals    <- allGamesGoals(team.games)
  team.games$Behinds  <- allGamesBehinds(team.games)
  team.games$Percent  <- allGamesPercent(team.games)
  team.games$Convert  <- allGamesConversion(team.games)
  team.games$Finals   <- allGamesFinals(team.games)
  team.games <- team.games[order(team.games$date, decreasing = T),]
  save(team.games, file = paste("data/", team, ".RData", sep = ""))
  
  team.games$Finals   <- ifelse(team.games$Finals > 0, 1, 0)
  # fix for never finals (all NA)
  team.games$Finals   <- ifelse(is.na(team.games$Finals), 0, team.games$Finals)
  team.games <- allGamesHalfWay(team.games)
  team.games <- subset(team.games, Year > 1981)

  if(nrow(team.games) > 0) {
    pdf(file = paste("output/", team, ".pdf", sep = ""), width = 11, height = 8)
    team.title <- paste("Half-way Percentage 1982-2016: ", team, sep = "")
    print(ggplot(team.games) + geom_boxplot(aes(factor(Year), Percent, fill = factor(Finals))) 
          + theme_bw() + geom_hline(yintercept = median(team.games$Percent), color = "red") 
          + scale_x_discrete(breaks = seq(1982, 2016, by = 2)) 
          + labs(title = team.title) + xlab("Year")
          + scale_fill_manual(name = "Finals", labels = c("no", "yes"), values = c("orange", "skyblue")))
    dev.off()
  }
}