# Sydney Swans Home Game Crowds
Neil Saunders  
19/05/2015  

## Introduction
This document compares crowds for home games at the Sydney Cricket Ground ("S.C.G.") versus ANZ Stadium (formerly known as Stadium Australia, "Stad. Aust.").

## 1. Getting the data
Data for all Swans games by season are obtained from [AFL Tables](http://afltables.com/afl/teams/swans/allgames.html). The functions used are shown at the end of this document.


```r
setwd("~/Dropbox/projects/github_projects/aflstats/code/R")
source("scripts/afltables.R")

swans <- allGames("swans")
swans$DateTime <- allGamesDateTime(swans)
swans$date     <- allGamesDate(swans)
swans$Year     <- allGamesYear(swans)

# get the home games since moving to Sydnet
swans.h <- subset(swans, T == "H" & Year > 1981)
table(swans.h$Venue)
```

```
## 
##      S.C.G. Stad. Aust. 
##         343          42
```

## 2. Plotting the data
We start with a basic scatterplot coloured by Venue.


```r
library(ggplot2)
ggplot(swans.h) + geom_point(aes(date, Crowd, color = Venue)) + theme_bw() + 
    scale_color_manual(values = c("darkorange", "cornflowerblue")) + labs(x = "Date", 
    title = "Sydney Swans Home Game Crowds")
```

![](swans_home_crowd_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

Clearly there are two "eras" of crowd numbers: small crowds pre-1996 (with spikes in 1986-1987) and larger crowds post-1996. We can indicate the median crowds for those two time periods, for the SCG and ANZ Stadium.


```r
ggplot(swans.h) + geom_point(aes(date, Crowd, color = Venue)) + theme_bw() + 
    scale_color_manual(values = c("darkorange", "cornflowerblue")) + geom_segment(aes(x = as.Date("1982-01-01", 
    "%Y-%m-%d"), xend = as.Date("1995-12-31", "%Y-%m-%d"), y = median(subset(swans.h, 
    Venue == "S.C.G." & Year < 1996)$Crowd), yend = median(subset(swans.h, Venue == 
    "S.C.G." & Year < 1996)$Crowd)), color = "darkorange", linetype = "dashed") + 
    geom_segment(aes(x = as.Date("1996-01-01", "%Y-%m-%d"), xend = as.Date("2015-12-31", 
        "%Y-%m-%d"), y = median(subset(swans.h, Venue == "S.C.G." & Year >= 
        1996)$Crowd), yend = median(subset(swans.h, Venue == "S.C.G." & Year >= 
        1996)$Crowd)), color = "darkorange") + geom_segment(aes(x = as.Date("2002-01-01", 
    "%Y-%m-%d"), xend = as.Date("2015-12-31", "%Y-%m-%d"), y = median(subset(swans.h, 
    Venue == "Stad. Aust." & Year >= 2002)$Crowd), yend = median(subset(swans.h, 
    Venue == "Stad. Aust." & Year >= 2002)$Crowd)), color = "cornflowerblue") + 
    labs(x = "Date", title = "Sydney Swans Home Game Crowds\nshowing medians for SCG (1982-1995 and 1996-2015) and ANZ (2002-2015")
```

![](swans_home_crowd_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

Finally, we can try to superimpose a trend for crowds at ANZ Stadium.


```r
ggplot(swans.h) + geom_point(aes(date, Crowd, color = Venue)) + theme_bw() + 
    scale_color_manual(values = c("darkorange", "cornflowerblue")) + geom_segment(aes(x = as.Date("1982-01-01", 
    "%Y-%m-%d"), xend = as.Date("1995-12-31", "%Y-%m-%d"), y = median(subset(swans.h, 
    Venue == "S.C.G." & Year < 1996)$Crowd), yend = median(subset(swans.h, Venue == 
    "S.C.G." & Year < 1996)$Crowd)), color = "darkorange", linetype = "dashed") + 
    geom_segment(aes(x = as.Date("1996-01-01", "%Y-%m-%d"), xend = as.Date("2015-12-31", 
        "%Y-%m-%d"), y = median(subset(swans.h, Venue == "S.C.G." & Year >= 
        1996)$Crowd), yend = median(subset(swans.h, Venue == "S.C.G." & Year >= 
        1996)$Crowd)), color = "darkorange") + geom_smooth(data = subset(swans.h, 
    Venue == "Stad. Aust."), aes(x = date, y = Crowd)) + labs(x = "Date", title = "Sydney Swans Home Game Crowds\nshowing SCG medians (1982-1995 and 1996-2015) and ANZ trend")
```

```
## `geom_smooth()` using method = 'loess'
```

![](swans_home_crowd_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

## 3. Summary
In general, home game crowds have been larger at ANZ Stadium compared with the SCG. We can speculate that this is due in large part to marketing; games at ANZ Stadium are promoted as "big games" (finals, not included in this analysis or games featuring high-quality opposition).

However, in recent years crowds have declined to levels comparable with the SCG. This may be part of the reason behind [the decision](www.afl.com.au/news/2014-11-24/swans-set-to-quit-homebush) to host all home games at the SCG after 2016.

### Functions used


```r
# all games given a team name
allGames <- function(team) {
    require(XML)
    require(plyr)
    games <- readHTMLTable(paste("http://afltables.com/afl/teams/", team, "/allgames.html", 
        sep = ""), stringsAsFactors = FALSE)
    # fix for 2 'Scoring' columns
    for (i in 1:length(games)) {
        colnames(games[[i]])[c(4, 6)] <- c("Scoring.F", "Scoring.A")
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
    date <- as.Date(datetime)
    return(date)
}

# convert game date to year
allGamesYear <- function(games) {
    datetime <- allGamesDateTime(games)
    year <- datetime$year + 1900
    return(year)
}
```