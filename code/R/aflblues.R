source('~/Dropbox/projects/aflstats/code/R/afltables.R')

blues         <- allGames("carlton")
blues$Year    <- allGamesYear(blues)
blues$date    <- as.Date(blues$Date, "%d-%b-%Y %I:%M PM")
blues$Percent <- allGamesPercent(blues)
blues         <- blues[order(blues$date, decreasing = T),]

blues.2007  <- subset(blues, date > as.Date("27-Jul-2007", "%d-%b-%Y"))
blues.2007$Coach <- ifelse(blues.2007$Year > 2012, "Malthouse", "Ratten")
ggplot(blues.2007) + geom_boxplot(aes(factor(Year), Percent, fill = Coach)) + theme_bw()
