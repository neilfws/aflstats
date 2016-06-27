library(ggplot2)
library(stringr)
library(plyr)
library(XML)

setwd("~/Dropbox/projects/aflstats/")

getDOB <- function(u) {
  p <- htmlTreeParse(u, useInternalNodes = TRUE)
  d <- str_match(xpathSApply(p, "//body", xmlValue), "Born:(.*?) ")[,2]
  # sleep for multiple requests
  Sys.sleep(2)
  return(d)
}

getHeight <- function(u) {
  p <- htmlTreeParse(u, useInternalNodes = TRUE)
  d <- str_match(xpathSApply(p, "//body", xmlValue), "Height:(.*?) ")[,2]
  # sleep for multiple requests
  Sys.sleep(2)
  return(d)
}

getAges <- function(year) {
  players.y <- readHTMLTable(paste("http://afltables.com/afl/stats/", year, ".html", sep = ""))
  players.y <- players.y[2:19]
  doc <- htmlTreeParse(paste("http://afltables.com/afl/stats/", year, ".html", sep = ""), useInternalNodes = TRUE)
  teams <- xpathSApply(doc, "//th/a", xmlValue)
  teams <- teams[seq(1, 36, 2)]
  for(i in 1:18) {
      players.y[[i]]$team <- teams[i]
  }
  players <- xpathSApply(doc, "//a[@href]", xmlAttrs)
  players <- ldply(players, rbind)
  players <- players[grep("players", players$href), ]
  baseurl <- "http://afltables.com/afl/stats"
  players$target <- paste(baseurl, players$href, sep = "/")
  players$dob <- sapply(players$target, function(x) getDOB(x))
  players$ht <- sapply(players$target, function(x) getHeight(x))
  players.y.df <- ldply(players.y, rbind)
  players$age <- as.Date(Sys.Date(), "%Y-%m-%d") - as.Date(players$dob, "%e-%b-%Y")
  players.y.df$age <- as.numeric(players$age)
  players.y.df$ht <- as.numeric(players$ht)
  return(players.y.df)
}

#plot
players <- getAges(2016)
png(file = "output/playerAges.png", width = 800, height = 760)
ggplot(players) + geom_violin(aes(reorder(team, age, median), age/365), fill = "darkorange", linetype = 0) +
  theme_bw() + ylab("Current players age (years)") +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = ("Player age distribution by team 2016 sorted by median age"), x = "Team") + geom_hline(yintercept = median(players$age/365), linetype = "dashed") + stat_summary(aes(team, as.numeric(age) / 365), fun.y = "median", geom = "point")
dev.off()