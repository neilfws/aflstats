library(ggplot2)
library(stringr)
library(plyr)
library(XML)

setwd("~/Dropbox/projects/aflstats/")

getDOB <- function(u) {
  p <- htmlTreeParse(u, useInternalNodes = TRUE)
  d <- str_match(xpathSApply(p, "//body", xmlValue), "Born:(.*?) ")[,2]
  return(d)
}

players.2014 <- readHTMLTable("http://afltables.com/afl/stats/2014.html")
players.2014 <- players.2014[2:19]
doc <- htmlTreeParse("http://afltables.com/afl/stats/2014.html", useInternalNodes = TRUE)
teams <- xpathSApply(doc, "//th/a", xmlValue)
teams <- teams[seq(1, 36, 2)]
for(i in 1:18) {
    players.2014[[i]]$team <- teams[i]
}
players <- xpathSApply(doc, "//a[@href]", xmlAttrs)
players <- ldply(players, rbind)
players <- players[grep("players", players$href), ]
baseurl <- "http://afltables.com/afl/stats"
p1 <- htmlTreeParse(paste(baseurl, players$href[1], sep = "/"), useInternalNodes = TRUE)
players$target <- paste(baseurl, players$href, sep = "/")
players$dob <- sapply(players$target, function(x) getDOB(x))
players.2014.df <- ldply(players.2014, rbind)
players$age <- as.Date(Sys.Date(), "%Y-%m-%d") - as.Date(players$dob, "%e-%b-%Y")
players.2014.df$age <- as.numeric(players$age)

#plot
png(file = "output/players2014.png", width = 800, height = 760)
ggplot(players.2014.df) + geom_boxplot(aes(team, age), fill = "salmon") + 
  theme_bw() + ylab("Current players age (days)") + 
  theme(axis.text.x = element_text(angle = 90)) + 
  labs(title = ("Player age (in days) distribution by team"))
dev.off()