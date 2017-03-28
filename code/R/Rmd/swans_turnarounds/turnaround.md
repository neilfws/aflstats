# Sydney Swans/South Melbourne greatest (and worst) Q4 turnarounds
Neil Saunders  
compiled `r Sys.time()`  



## Introduction

How many times have the Swans come from behind going into the last quarter to win? Or been in front, but then gone on to lose? In each case, what were the biggest swings in the scoreline?

## Getting the data

First, we define a function to download and process Swans game data from [AFL Tables](http://afltables.com).


```r
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
```

Now we can fetch all Swans games.


```r
team.games <- allGames("swans")
```

```
## Loading required package: XML
```

```
## Loading required package: plyr
```

There are currently 2384 of them.

## Scores for Q3 and Q4

We need 4 values: total score (for and against) at the end of Q3 and the same for the end of Q4. Another function:


```r
allGamesQuarterScore <- function(games, quarter = 4, who = "Scoring.F") {
  stopifnot(who == "Scoring.F" || who == "Scoring.A")
  score    <- games[[who]]
  quarters <- strsplit(score, " ")
  qchoose  <- sapply(quarters, function(x) x[quarter])
  total    <- sapply(strsplit(qchoose, "\\."), function(x) 6 * as.numeric(x[1]) + as.numeric(x[2]))
  return(total)
}
```

Let's make a new data frame, q34, with 4 columns: Q3 scores for/against, Q4 scores for/against.


```r
q34 <- data.frame(q3.f = allGamesQuarterScore(team.games, 3, "Scoring.F"),
                  q3.a = allGamesQuarterScore(team.games, 3, "Scoring.A"),
                  q4.f = allGamesQuarterScore(team.games, 4, "Scoring.F"),
                  q4.a = allGamesQuarterScore(team.games, 4, "Scoring.A")
                  )
```

To calculate turnarounds, we subtract the difference (Q3.F - Q3.A) from (Q4.F - Q4.A).


```r
q34$diff <- (q34$q4.f - q34$q4.a) - (q34$q3.f - q34$q3.a)
head(q34)
```

```
##   q3.f q3.a q4.f q4.a diff
## 1   66   88   82  110   -6
## 2  105   36  133   53   11
## 3   91   46  131   71   15
## 4   55   41   93   68   11
## 5   80   79  103  113  -11
## 6   66   45   88   49   18
```

## Come from behind at Q3 to win

We select the subset of cases where the score "for" is less than the score "against" at the end of Q3, but greater than the score "against" at the end of Q4. Then we sort by the diff column.


```r
wins <- subset(q34, q3.f < q3.a & q4.f > q4.a)
wins <- wins[order(wins$diff, decreasing = TRUE),]
```

They've come from behind to win 174 times. Now we can use the row names of wins as indexes to extract the top 10 comebacks of all time from the games data.


```r
library(knitr)
wins.10 <- team.games[as.numeric(rownames(wins)[1:10]),]
#print(xtable(wins.10, digits = 0, align = "lllllrlrllrr"), type = "html", include.rownames = FALSE)
kable(wins.10, row.names = FALSE)
```



Rnd   T    Opponent         Scoring.F                 F  Scoring.A                 A  R    M    W-D-L    Venue          Crowd  Date                    
----  ---  ---------------  ---------------------  ----  ---------------------  ----  ---  ---  -------  ------------  ------  ------------------------
R5    H    Adelaide         1.4 5.13 9.15 20.24     144  5.7 7.10 12.14 12.15     87  W    57   2-0-3    S.C.G.         15491  Sun 30-Apr-1995 2:15 PM 
R19   A    Kangaroos        5.4 6.5 12.7 22.12      144  4.3 10.3 14.6 15.7       97  W    47   6-1-12   S.C.G.         14776  Sat 10-Aug-2002 7:10 PM 
R8    H    Geelong          4.1 5.10 6.12 14.17     101  5.0 7.0 12.5 13.5        83  W    18   3-0-4    Lake Oval         NA  Sat 12-Jun-1915 3:00 PM 
R1    H    Essendon         0.1 1.7 3.8 10.12        72  4.3 5.5 9.6 9.6          60  W    12   1-0-0    Stad. Aust.    23274  Sat 04-Apr-2015 4:35 PM 
R5    A    Richmond         4.5 7.9 13.15 21.20     146  5.5 11.8 18.11 19.12    126  W    20   4-0-1    M.C.G.         22154  Sat 25-Apr-1987 2:10 PM 
R20   H    Brisbane Bears   1.6 3.11 4.15 11.20      86  3.4 4.7 7.11 7.13        55  W    31   4-0-16   S.C.G.          5272  Fri 17-Aug-1990 7:40 PM 
R2    H    Footscray        2.4 6.10 11.12 18.17    125  5.4 7.8 14.13 14.15      99  W    26   1-0-1    Lake Oval      29000  Sat 06-May-1933 2:45 PM 
R12   A    Richmond         2.3 4.5 8.8 16.12       108  2.5 5.11 9.14 10.15      75  W    33   7-0-5    Punt Rd        27000  Sat 17-Jul-1926 2:45 PM 
R5    H    Melbourne        2.3 6.4 7.4 17.7        109  3.2 5.4 10.6 13.7        85  W    24   2-0-3    S.C.G.         24286  Fri 25-Apr-2003 6:45 PM 
R13   H    Fitzroy          4.0 10.1 12.2 19.6      120  3.9 3.9 11.20 11.22      88  W    32   3-0-10   Lake Oval      12000  Sat 19-Jul-1958 2:15 PM 

## Slip from in front at Q3 to lose

The procedure is very similar, except that we select the cases where score "for" is greater than "against" in Q3, but less than "against" in Q4.


```r
losses <- subset(q34, q3.f > q3.a & q4.f < q4.a)
losses <- losses[order(losses$diff, decreasing = FALSE),]
```

They've thrown it away in the last quarter 157 times.


```r
losses.10 <- team.games[as.numeric(rownames(losses)[1:10]),]
#print(xtable(losses.10, digits = 0, align = "lllllrlrllrr"), type = "html", include.rownames = FALSE)
kable(losses.10, row.names = FALSE)
```



Rnd   T    Opponent          Scoring.F                 F  Scoring.A                  A  R    M     W-D-L    Venue            Crowd  Date                    
----  ---  ----------------  ---------------------  ----  ----------------------  ----  ---  ----  -------  --------------  ------  ------------------------
R12   A    Melbourne         6.3 10.4 14.11 14.12     96  4.2 8.7 12.11 22.16      148  L    -52   10-0-2   M.C.G.           26510  Sat 25-Jul-1936 2:45 PM 
R4    A    Melbourne         3.2 8.4 14.9 15.11      101  3.3 8.6 12.10 23.15      153  L    -52   1-0-3    M.C.G.           14569  Sat 14-May-1938 2:45 PM 
R6    A    North Melbourne   9.3 19.6 21.8 21.8      134  5.7 13.12 19.18 27.26    188  L    -54   1-0-4    M.C.G.           15664  Thu 25-Apr-1991 2:10 PM 
R13   H    St Kilda          4.4 6.6 9.9 9.9          63  2.4 2.9 3.9 11.14         80  L    -17   2-0-11   Lake Oval        14380  Sat 21-Jul-1962 2:20 PM 
R5    H    Essendon          6.4 8.11 17.12 19.16    130  4.6 10.9 13.15 24.17     161  L    -31   1-0-3    S.C.G.           13140  Fri 19-Apr-1991 7:40 PM 
R4    A    Fitzroy           6.3 9.8 16.12 18.16     124  2.5 6.9 11.10 21.17      143  L    -19   1-0-3    Junction Oval    13664  Sat 22-Apr-1978 2:10 PM 
R19   A    Footscray         5.4 6.6 8.8 8.9          57  3.1 6.6 7.12 15.13       103  L    -46   3-1-13   Western Oval     12742  Sat 25-Jul-1992 2:10 PM 
R5    H    Essendon          3.6 5.10 6.12 7.16       58  2.2 4.11 5.13 14.16      100  L    -42   1-0-4    Lake Oval        27500  Sat 18-May-1957 2:15 PM 
R19   H    Kangaroos         5.2 9.3 16.4 18.4       112  2.4 3.10 8.12 17.16      118  L    -6    10-0-9   S.C.G.           24028  Sat 07-Aug-2004 7:10 PM 
R7    A    Essendon          3.1 7.4 11.7 11.10       76  1.2 3.5 9.7 16.12        108  L    -32   1-1-5    Windy Hill       12000  Sat 05-Jun-1937 2:30 PM 
