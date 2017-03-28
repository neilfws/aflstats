# Sydney Swans wet weather performance at the SCG
Neil Saunders  
compiled `r Sys.time()`  

## Introduction
"We don't go well in the wet" say Sydney Swans fans. Is that true? An attempt to find out using data.

## 1. Sydney Swans data
Load the Swans games data. Data for all games is extracted from [the AFL Tables website](http://afltables.com/afl/teams/swans/allgames.html) and stored as a data frame using [these functions](https://github.com/neilfws/aflstats/blob/master/code/R/afltables.R), which are called by [this code](https://github.com/neilfws/aflstats/blob/master/code/R/plotHalfwayPercent.R).

```r
library(ggplot2)
load("~/Dropbox/projects/github_projects/aflstats/data/swans.RData")
```

## 2. Rainfall data
How can we find out if it was raining on the day of a game? Our starting point is [this web page](http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_nccObsCode=139&p_display_type=dataFile&p_startYear=&p_c=-875479904&p_stn_num=066160) from where we can download meteorological data for Centennial Park from 1900 onwards. This station is very close to the SCG. The downloaded zip file uncompresses to a CSV file which is easy to load into R.

```r
centennial <- read.csv("~/Dropbox/projects/github_projects/aflstats/data/IDCJAC0009_066160_1800_Data.csv")
colnames(centennial)[c(1,2,6,7)] <- c("product", "station", "rain.mm", "period.days")
```

We can add a _date_ column by combining the Year, Month and Day values. However, note that "observations of Daily rainfall are nominally made at 9 am local clock time and record the total for the previous 24 hours." In theory then, many of the observations include the afternoon and evening of the previous day. We cannot know for sure whether it was raining at game time, so we will assume that any non-zero rain amount at 09:00 indicates rain during the game on the previous day. So we'll substract 1 day from the dates.


```r
centennial$date <- as.Date(paste(centennial$Year, centennial$Month, centennial$Day, sep = "-"), format = "%Y-%m-%d")
centennial$date <- centennial$date - 1
```

## 3. Joining the data
Now we can subset those games played at the SCG and simply match the date columns. We'll also add some binary variables. _Wet_, _heavy_ and _very heavy_ are taken from definitions on [this BoM page](http://www.bom.gov.au/climate/data-services/content/faqs-elements.html).

* _wetBin_    = 1 if rain >= 1 mm, otherwise = 0
* _heavyBin_  = 1 if rain >= 10 mm, otherwise = 0
* _vHeavyBin_ = 1 if rain >= 25 mm, otherwise = 0
* _restBin_   = 1 if result (R) = win (W), otherwise = 0


```r
scg      <- subset(team.games, Venue == "S.C.G.")
m        <- match(scg$date, centennial$date)
scg$rain <- centennial[m, "rain.mm"]

scg$wetBin    <- ifelse(scg$rain >= 1, 1, 0)
scg$heavyBin  <- ifelse(scg$rain >= 10, 1, 0)
scg$vHeavyBin <- ifelse(scg$rain >= 25, 1, 0)
scg$resBin    <- ifelse(scg$R == "W", 1, 0)
```

## 4. Analysis
### 4.1 Game results plotted by date and rainfall
First, we can plot the amount of rain for the day in which each game at the SCG took place. The points are coloured by game result and point shape indicates whether more than 1 mm of rain was recorded.

```r
ggplot(scg) + geom_point(aes(date, rain, color = R, shape = factor(wetBin)), size = 3) + theme_bw() + scale_color_manual(values = c("grey", "darkorange", "cornflowerblue"))
```

![](scg_rain_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

If the Swans were in general a team that performed poorly in the wet, we might expect to see more losses (orange) with increasing rainfall. This is not apparent. Note, for example, that there were far more wins than losses (5:1) between 20 and 30 mm rain, and equal numbers of wins and losses between 30 and 40 mm.

### 4.2 Is the proportion of wins/losses different for wet versus dry days?
We can represent the data as 2x2 contingency tables - win/loss versus dry/wet - and so test for differences using Fisher's exact test.

```r
# this table represents: 98 dry + loss/draw; 40 wet + loss/draw; 140 dry + win; 55 wet + win
table(scg$resBin, scg$wetBin)
```

```
##    
##       0   1
##   0  98  40
##   1 140  55
```

```r
# fisher test
fisher.test(table(scg$resBin, scg$wetBin))
```

```
## 
## 	Fisher's Exact Test for Count Data
## 
## data:  table(scg$resBin, scg$wetBin)
## p-value = 0.9023
## alternative hypothesis: true odds ratio is not equal to 1
## 95 percent confidence interval:
##  0.5786583 1.6090030
## sample estimates:
## odds ratio 
##  0.9625869
```

```r
# and the same for heavy, very heavy
fisher.test(table(scg$resBin, scg$heavyBin))
```

```
## 
## 	Fisher's Exact Test for Count Data
## 
## data:  table(scg$resBin, scg$heavyBin)
## p-value = 1
## alternative hypothesis: true odds ratio is not equal to 1
## 95 percent confidence interval:
##  0.4656732 2.2561732
## sample estimates:
## odds ratio 
##   1.012209
```

```r
fisher.test(table(scg$resBin, scg$vHeavyBin))
```

```
## 
## 	Fisher's Exact Test for Count Data
## 
## data:  table(scg$resBin, scg$vHeavyBin)
## p-value = 0.7784
## alternative hypothesis: true odds ratio is not equal to 1
## 95 percent confidence interval:
##  0.2300286 3.0241653
## sample estimates:
## odds ratio 
##  0.8196518
```
None of these tests indicate a significant difference in wins/losses due to rain.

### 4.3 Game results by opponent and rainfall
Do the Swans tend to win/lose against particular opponents when conditions are wet/dry?

```r
opponents    <- as.data.frame(table(scg$R, scg$wetBin, scg$Opponent), stringsAsFactors = FALSE)
# set counts negative if result = loss
opponents$f2 <- ifelse(opponents$Var1 == "L", 0 - opponents$Freq, opponents$Freq)

ggplot() + geom_bar(data = subset(opponents, Var1 == "L"), aes(x = reorder(Var3, f2), y = f2, fill = Var2), stat = "identity") + geom_bar(data = subset(opponents, Var1 == "W"), aes(x = reorder(Var3, f2), y = f2, fill = Var2), stat = "identity") + theme_bw() + coord_flip() + geom_hline(yintercept = 0) + scale_fill_manual(labels = c("dry", "wet"), values = c("cornflowerblue", "darkorange"), name = "rain") + labs(y = "number of wins/losses", x = "opponent")
```

![](scg_rain_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

There are no general trends in this chart, but some points of interest. For example: more losses to teams from the west coast have occurred when wet, more losses when wet versus wins than wet versus North Melbourne, more wins than wet versus losses when wet versus Saint Kilda. However, it seems that for most teams, rain makes little difference to win/loss ratios.

### 4.4 Runs of losses in the wet
It may be that wet weather performance varies over time, for example with different players in the team. In this case, assuming that personnel are relatively stable across a period of weeks within a season, we might expect to see runs of losses whenever conditions were wet.

Since most (71.5%) of SCG games have been dry, there are very few runs of consecutive wet games. The longest is 5, which occurred in 1983. The Swans won 4 of those games.

```r
wet <- rle(scg$wetBin)
max(wet$lengths[which(wet$values == 1)])
```

```
## [1] 5
```

```r
scg[323:327, c(1:8)]
```

```
##     Rnd T  Opponent            Scoring.F   F              Scoring.A   A R
## 732  R7 H   Carlton 4.4 7.10 11.13 11.17  83     3.1 9.3 11.8 12.16  88 L
## 731  R6 H Footscray  8.3 13.4 17.8 25.11 161     1.1 6.6 7.13 11.17  83 W
## 729  R4 H  Hawthorn    3.2 3.4 4.12 5.14  44      3.2 4.7 7.12 8.15  63 L
## 728  R3 H   Fitzroy   3.5 7.8 12.9 18.12 120 10.5 17.10 22.11 26.15 171 L
## 768 R21 H  Essendon 5.1 10.5 15.11 23.17 155    5.4 8.8 12.13 14.15  99 W
```

There have been only two consecutive games which were losses in the wet.

```r
wetloss <- rle(paste(scg$wetBin, scg$R, sep = ":"))
max(wetloss$lengths[which(wetloss$values == "1:L")])
```

```
## [1] 2
```

Of course, this analysis does not include the intervening games at venues other than the SCG. However, it seems that whilst the Swans have had their share of long runs of losing games, rain was not a factor in any of the losing streaks.

## Conclusion
These analyses are incomplete and should be treated with caution. In particular, we cannot know for certain whether it rained during a game based on the available rainfall data. However, based on what is available, there is no evidence that the Swans have systemic or long-term performance problems due to rain when playing at the SCG.
