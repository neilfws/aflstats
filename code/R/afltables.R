# all games given a team name
allGames <- function(team) {
  require(XML)
  require(plyr)
  games <- readHTMLTable(paste("http://afltables.com/afl/teams/", team, "/allgames.html", sep = ""), stringsAsFactors = FALSE)
  # fix for 2 "Scoring" columns
  for(i in 1:length(games)) {
    colnames(games[[i]])[c(4,6)] <- c("Scoring.F", "Scoring.A")
    }
  games <- ldply(games, rbind)
  games$.id <- NULL
  games$F <- as.numeric(games$F)
  games$A <- as.numeric(games$A)
  games$Crowd <- as.numeric(games$Crowd)
  return(games)
}

# convert game date to POSIXlt/POSIXt class
allGamesDateTime <- function(games) {
  datetime <- strptime(games$Date, format = "%d-%b-%Y %I:%M %p")
  return(datetime)
}

# convert game datetime to Date class
allGamesDate <- function(games) {
  datetime <- allGamesDateTime(games)
  date     <- as.Date(datetime)
  return(date)
}

# convert game date to year
allGamesYear <- function(games) {
  datetime <- allGamesDateTime(games)
  year     <- datetime$year + 1900
  return(year)
}

# Goals
allGamesGoals <- function(games) {
  final <- sapply(strsplit(games$Scoring.F, " "), function(x) x[[4]])
  goals <- sapply(strsplit(final, "\\."), function(x) x[1])
  return(as.numeric(goals))
}

# Behinds
allGamesBehinds <- function(games) {
  final   <- sapply(strsplit(games$Scoring.F, " "), function(x) x[[4]])
  behinds <- sapply(strsplit(final, "\\."), function(x) x[2])
  return(as.numeric(behinds))
}

# Percentage
allGamesPercent <- function(games) {
  percent <- 100 * (games$F / games$A)
  return(percent)
}

# Conversion (percentage of goals to goals + behinds)
allGamesConversion <- function(games) {
  goals      <- allGamesGoals(games)
  behinds    <- allGamesBehinds(games)
  conversion <- 100 * (goals / (goals + behinds))
  return(conversion)
}

# Finals games by season
allGamesFinals <- function(games) {
  types  <- as.data.frame(table(games$Year, games$T))
  f      <- subset(types, Var2 == "F")
  m      <- match(games$Year, f$Var1)
  finals <- f[m, "Freq"]
  return(finals)
}

# sample the first half of the season
allGamesHalfWay <- function(games) {
  require(plyr)
  halfway  <- list()
  year.now <- 1900 + as.POSIXlt(Sys.time())$year
  years    <- unique(games$Year)
  for(i in 1:length(years)) {
    y <- subset(games, Year == years[i])
    y <- y[grep("^R", y$Rnd), ]
    if(years[i] < year.now) {
      n <- round(nrow(y) / 2)
    }
    else {
      n <- nrow(y)
    }
    halfway[[i]] <- tail(y, n)
  }
  halfway <- do.call(rbind, halfway)
  return(halfway)
}

# get the total score for or against for a quarter
allGamesQuarterScore <- function(games, quarter = 4, who = "Scoring.F") {
  stopifnot(who == "Scoring.F" || who == "Scoring.A")
  score    <- games[[who]]
  quarters <- strsplit(score, " ")
  qchoose  <- sapply(quarters, function(x) x[quarter])
  total    <- sapply(strsplit(qchoose, "\\."), function(x) 6 * as.numeric(x[1]) + as.numeric(x[2]))
  return(total)
}