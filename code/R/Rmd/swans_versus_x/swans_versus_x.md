# Sydney Swans versus the rest
Neil Saunders  
`r Sys.time()`  



## Introduction
In "Swans versus the rest" we look at the South Melbourne (SMFC) and Sydney Swans record versus teams and venues in terms of wins/losses, members, finances and coaching history.

## 1. Versus teams and venues
First we get the data for all South Melbourne/Sydney Swans games. For these analyses we'll look only at the "modern" Swans era, 1982 onwards.


```r
swans <- allGames("swans")
swans.date <- strptime(swans$Date, format = "%a %d-%b-%Y %I:%M %p")
swans$Year <- swans.date$year + 1900
swans.mod <- subset(swans, Year > 1981)
```

### 1.1 Win/loss record versus teams
Still unbeaten versus Gold Coast :)

Could do better versus the Cats and Hawks.


```r
swans.mod.r <- as.data.frame(table(swans.mod$Opponent, swans.mod$R))

ggplot() + geom_bar(data = subset(swans.mod.r, Var2 == "W"), aes(Var1, Freq, 
    fill = Var2), stat = "identity") + geom_bar(data = subset(swans.mod.r, Var2 == 
    "L"), aes(Var1, Freq * -1, fill = Var2), stat = "identity") + theme_bw() + 
    coord_flip() + labs(title = "Sydney Swans Win/Loss 1982 - present", x = "Opponent", 
    y = "Games") + scale_fill_manual(name = "Result", labels = c("Loss", "Win"), 
    values = c("ivory3", "tomato3")) + scale_y_continuous(labels = abs(seq(-40, 
    40, 10)), breaks = seq(-40, 40, 10))
```

![](swans_versus_x_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

### 1.2 Win/loss record at venues
Gives some weight to the notion that the Swans struggle at the MCG.


```r
swans.mod.v <- as.data.frame(table(swans.mod$Venue, swans.mod$R))

ggplot() + geom_bar(data = subset(swans.mod.v, Var2 == "W"), aes(Var1, Freq, 
    fill = Var2), stat = "identity") + geom_bar(data = subset(swans.mod.v, Var2 == 
    "L"), aes(Var1, Freq * -1, fill = Var2), stat = "identity") + theme_bw() + 
    coord_flip() + labs(title = "Sydney Swans Win/Loss 1982 - present", x = "Venue", 
    y = "Games") + scale_fill_manual(name = "Result", labels = c("Loss", "Win"), 
    values = c("ivory3", "tomato3")) + scale_y_continuous(labels = abs(seq(-200, 
    200, 20)), breaks = seq(-200, 200, 20))
```

![](swans_versus_x_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

## 2. Versus teams: members
We fetch membership numbers from [this site](http://www.aflmembershipnumbers.com/). The original data sources are not known. Most of the figures seems accurate when compared with other sources, with a couple of exceptions that are fixed manually.




```r
members <- getMembers()
```

Note that there is often more to these numbers to meet the eye; for example, the rapid rise in Collingwood's numbers occurred when they changed how members were counted.


```r
pal <- colorRampPalette(brewer.pal(8, "Dark2"))(18)
ggplot(members, aes(x = Year, y = Members, col = Team)) + geom_line() + scale_color_manual(values = pal) + 
    theme_bw() + geom_dl(aes(label = Team), list("last.points", cex = 0.6)) + 
    theme(legend.position = "none") + coord_cartesian(xlim = c(1995, 2020))
```

## 3. Versus teams: club payments
These figures are taken from the most recent AFL annual report, which is for the year 2013. Club payments are divided into "base" (the same for all clubs), "future" (different for some clubs) and "other" (various payments, different for all clubs).

In this plot clubs are sorted by "other" and the median total payment is shown. Note that overall the Swans rank 7/18 for "other" payments and are in the lower 50% of total payments.


```r
cp <- getURL("https://raw.githubusercontent.com/neilfws/aflstats/master/data/club_payments_2013.tsv")
club_payments_2013 <- read.delim(text = cp, header = FALSE, dec = ",")
colnames(club_payments_2013) <- c("club", "base", "future", "other", "total")
club_payments_2013$base <- gsub(",", "", club_payments_2013$base)
club_payments_2013$future <- gsub(",", "", club_payments_2013$future)
club_payments_2013$other <- gsub(",", "", club_payments_2013$other)
club_payments_2013$total <- gsub(",", "", club_payments_2013$total)
club_payments_2013$base <- as.numeric(club_payments_2013$base)
club_payments_2013$future <- as.numeric(club_payments_2013$future)
club_payments_2013$other <- as.numeric(club_payments_2013$other)
club_payments_2013$total <- as.numeric(club_payments_2013$total)

cp.other <- club_payments_2013[order(club_payments_2013$other, decreasing = T), 
    ]
cp.other$club <- factor(cp.other$club, levels = cp.other$club)
cpother.melt <- melt(cp.other)

ggplot(subset(cpother.melt, variable != "total"), aes(club, value, fill = variable)) + 
    geom_bar(stat = "identity") + theme_bw() + scale_fill_brewer(palette = "Reds") + 
    labs(title = "Club payments 2013 sorted by \"other\"") + coord_flip() + 
    geom_hline(yintercept = median(club_payments_2013$total)) + scale_y_continuous(breaks = seq(0, 
    20000000, by = 4000000))
```

![](swans_versus_x_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

## 4. Coaches
This section is not so much "versus the rest" as the record of SMFC/Sydney coaches versus each other across the years.



First we get the coaching data, label the team (South Melbourne or Sydney) and indicate grand final appearance in each year.

```r
swans_coaches <- getCoaches("swans")
swans_coaches$swans <- "Other"
swans_coaches$swans <- ifelse(swans_coaches$Team == "South Melbourne", "South Melbourne", 
    swans_coaches$swans)
swans_coaches$swans <- ifelse(swans_coaches$Team == "Sydney", "Sydney", swans_coaches$swans)
swans_coaches$gf <- ifelse(swans_coaches$GF == "X" & swans_coaches$swans != 
    "Other", 1, 0)
```

### 4.1 Coaches win/loss record coloured by teams coached
Now we can plot the win/loss record for each coach by season and colour it in various ways. These plots are better viewed as large PDFs, but you should get the overall impression from this document.

First, by other teams coached by that coach. This shows the long and varied careers of some coaches _e.g._ Ron Barassi, Tom Hafey and Norm Smith.

```r
ggplot(swans_coaches) + geom_bar(aes(as.numeric(Year), as.numeric(W), fill = Team), 
    stat = "identity") + geom_bar(aes(as.numeric(Year), as.numeric(L) * -1, 
    fill = Team), stat = "identity") + geom_hline(yintercept = 0, color = "ivory3", 
    size = 0.5) + facet_grid(.id ~ .) + theme_bw() + theme(strip.text.y = element_text(angle = 0), 
    axis.ticks.y = element_blank(), axis.text.y = element_blank(), panel.border = element_blank()) + 
    labs(x = "Year", y = "Wins/Losses", title = "South Melbourne/Sydney Swans Coaches Win/Loss Records") + 
    scale_fill_discrete(name = "Teams coached") + scale_x_continuous(breaks = seq(1905, 
    2015, 10))
```

![](swans_versus_x_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

### 4.2 Coaches win/loss record coloured by years with SMFC/Sydney
In this view, red is used to indicate the years coaching with SMFC or Sydney. Paul Roos' long contribution is evident.

```r
ggplot(swans_coaches) + geom_bar(aes(as.numeric(Year), as.numeric(W), fill = swans), 
    stat = "identity") + geom_bar(aes(as.numeric(Year), as.numeric(L) * -1, 
    fill = swans), stat = "identity") + geom_hline(yintercept = 0, color = "ivory3", 
    size = 0.5) + facet_grid(.id ~ .) + theme_bw() + theme(strip.text.y = element_text(angle = 0), 
    axis.ticks.y = element_blank(), axis.text.y = element_blank(), panel.border = element_blank()) + 
    labs(x = "Year", y = "Wins/Losses", title = "South Melbourne/Sydney Swans Coaches Win/Loss Records") + 
    scale_fill_manual(name = "Teams coached", values = c("grey", "firebrick3", 
        "firebrick1")) + scale_x_continuous(breaks = seq(1905, 2015, 10))
```

![](swans_versus_x_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

### 4.3 Coaches win/loss record coloured by grand finals with SMFC/Sydney
Finally, seasons coloured by Grand Final appearances. This highlights the long period from the 1930s to 1996 (with no wins from 1933 until 2005) and the exceptional record of Jack Bisset.

```r
ggplot(swans_coaches) + geom_bar(aes(as.numeric(Year), as.numeric(W), fill = factor(gf)), 
    stat = "identity") + geom_bar(aes(as.numeric(Year), as.numeric(L) * -1, 
    fill = factor(gf)), stat = "identity") + geom_hline(yintercept = 0, color = "ivory3", 
    size = 0.5) + facet_grid(.id ~ .) + theme_bw() + theme(strip.text.y = element_text(angle = 0), 
    axis.ticks.y = element_blank(), axis.text.y = element_blank(), panel.border = element_blank()) + 
    labs(x = "Year", y = "Wins/Losses", title = "South Melbourne/Sydney Swans Coaches Win/Loss Records") + 
    scale_fill_manual(name = "Grand Final", values = c("ivory3", "tomato3"), 
        labels = c("no", "yes")) + scale_x_continuous(breaks = seq(1905, 2015, 
    10))
```

![](swans_versus_x_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

## 5. Functions
Here's the code for functions used in this document.

### 5.1 Setup

```r
library(ggplot2)
library(XML)
library(RCurl)
library(plyr)
library(reshape2)
library(directlabels)
library(RColorBrewer)

options(scipen = 10000)
# all games given a team name
allGames <- function(team) {
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
```

### 5.2 Members

```r
getMembers <- function() {
    u <- "http://www.aflmembershipnumbers.com/index.html"
    doc <- htmlTreeParse(u, useInternalNodes = TRUE)
    teams <- data.frame(team = xpathSApply(doc, "//a[@href]", xmlValue), link = xpathSApply(doc, 
        "//a[@href]", xmlAttrs))
    teams <- teams[4:21, ]
    baseurl <- "http://www.aflmembershipnumbers.com/"
    members <- list()
    for (i in 1:nrow(teams)) {
        t <- readHTMLTable(paste(baseurl, teams$link[i], sep = ""))
        members[[as.character(teams$team[i])]] <- t[[1]]
    }
    members.df <- ldply(members)
    colnames(members.df)[1] <- "Team"
    colnames(members.df)[3] <- "Members"
    members.df$Members <- as.character(members.df$Members)
    members.df$Members <- as.numeric(gsub(",", "", members.df$Members))
    # manual fixes for the errors
    members.df[123, 3] <- 40205  # Geelong 2012 from http://en.wikipedia.org/wiki/2012_Geelong_Football_Club_season
    members.df[266, 3] <- 40123  # Sydney from http://www.afl.com.au/news/2014-08-02/club-memberships-rise
    members.df[101, 3] <- 48776  # Fremantle from http://www.afl.com.au/news/2014-08-02/club-memberships-rise
    members.df$Year <- as.numeric(as.character(members.df$Year))
    return(members.df)
}
```

### 5.3 Coaches

```r
getCoaches <- function(team) {
    coaches <- htmlTreeParse(paste("http://afltables.com/afl/stats/coaches/", 
        team, ".html", sep = ""), useInternalNodes = TRUE)
    n1 <- xpathSApply(coaches, "//td/a[@href]", xmlValue)
    u1 <- xpathSApply(coaches, "//td/a[@href]", xmlAttrs)
    l <- list()
    
    for (i in 1:length(u1)) {
        u <- paste("http://afltables.com/afl/", gsub("../../", "", u1[i]), sep = "")
        d <- readHTMLTable(u, stringsAsFactors = FALSE)
        l[[i]] <- d[[1]]
    }
    
    names(l) <- n1
    coaches.df <- ldply(l, as.data.frame)
}
```