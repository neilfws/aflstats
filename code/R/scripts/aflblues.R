source('~/Dropbox/projects/github_projects/aflstats/code/R/scripts/afltables.R')

blues         <- allGames("carlton")
blues$Year    <- allGamesYear(blues)
blues$date    <- as.Date(blues$Date, "%a %d-%b-%Y %I:%M PM")
blues$Percent <- allGamesPercent(blues)
blues         <- blues[order(blues$date, decreasing = T),]

blues.2007  <- subset(blues, date > as.Date("27-Jul-2007", "%d-%b-%Y"))
blues.2007$Coach <- ifelse(blues.2007$Year > 2012, "Malthouse", "Ratten")
blues.2007$Coach <- ifelse(blues.2007$Year == 2015, "Malthouse/Barker", blues.2007$Coach)
blues.2007$Coach <- ifelse(blues.2007$Year > 2015, "Bolton", blues.2007$Coach)
ggplot(blues.2007) + geom_boxplot(aes(factor(Year), Percent, fill = Coach)) + theme_bw() + scale_fill_brewer(palette = "Spectral") + labs(x = "Year", y = "Percentage", title = "Carlton game percentages by season under different coaches")
