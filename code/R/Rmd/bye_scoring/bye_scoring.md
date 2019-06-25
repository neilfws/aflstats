AFL: wins and losses after the bye
================
Neil Saunders
2019-06-26 08:57:50

# Introduction

Geelong have not won a game after the bye since 2011. Is this unusual?
Can we shed any light as to why?

# Data

Our data comes from two sources:

  - `fitzRoy::get_match_results()`
  - AFL historical odds in Excel format [available from
    here](http://www.aussportsbetting.com/data/historical-afl-results-and-odds-data/)

# Processing

First question: when asking whether wins/losses after the bye are
unusual, we need to ask “compared with what?”

For this study we’ll compare the round before the bye with the week
after.

A very long dplyr/tidyr chain gives us the relevant games. 257 games
have been played either side of a bye since 2011. Of these, 174 games
involved one team in the bye, and 83 involved both teams in the bye.

# Analysis

## Visualisation

Let’s confirm that Geelong have indeed not won a game after a bye since
2011:

| Season | Round | Date       | Venue             | Margin | Status    | Team    | bye    | Result |
| -----: | :---- | :--------- | :---------------- | -----: | :-------- | :------ | :----- | :----- |
|   2011 | R5    | 2011-04-26 | M.C.G.            |     19 | Away.Team | Geelong | before | W      |
|   2011 | R7    | 2011-05-07 | Kardinia Park     |     66 | Home.Team | Geelong | after  | W      |
|   2011 | R21   | 2011-08-14 | Football Park     |     11 | Away.Team | Geelong | before | W      |
|   2011 | R23   | 2011-08-27 | Kardinia Park     |   \-13 | Home.Team | Geelong | after  | L      |
|   2012 | R11   | 2012-06-08 | Docklands         |     12 | Away.Team | Geelong | before | W      |
|   2012 | R13   | 2012-06-22 | S.C.G.            |    \-6 | Away.Team | Geelong | after  | L      |
|   2013 | R11   | 2013-06-08 | Sydney Showground |     59 | Away.Team | Geelong | before | W      |
|   2013 | R13   | 2013-06-23 | Gabba             |    \-5 | Away.Team | Geelong | after  | L      |
|   2014 | R7    | 2014-05-04 | M.C.G.            |      5 | Home.Team | Geelong | before | W      |
|   2014 | R9    | 2014-05-17 | Subiaco           |   \-32 | Away.Team | Geelong | after  | L      |
|   2016 | R14   | 2016-06-25 | Docklands         |    \-3 | Away.Team | Geelong | before | L      |
|   2016 | R16   | 2016-07-08 | Kardinia Park     |   \-38 | Home.Team | Geelong | after  | L      |
|   2017 | R11   | 2017-06-02 | Kardinia Park     |     22 | Home.Team | Geelong | before | W      |
|   2017 | R13   | 2017-06-15 | Subiaco           |   \-13 | Away.Team | Geelong | after  | L      |
|   2018 | R13   | 2018-06-17 | M.C.G.            |   \-18 | Home.Team | Geelong | before | L      |
|   2018 | R15   | 2018-06-29 | Docklands         |    \-2 | Away.Team | Geelong | after  | L      |
|   2019 | R12   | 2019-06-07 | M.C.G.            |     67 | Away.Team | Geelong | before | W      |
|   2019 | R14   | 2019-06-22 | Adelaide Oval     |   \-11 | Away.Team | Geelong | after  | L      |

Various ways to visualise this:

![](bye_scoring_files/figure-gfm/plot-win-loss-02-1.png)<!-- -->

## Fisher exact test

We’ll try a Fisher exact test to compare the win/loss count before the
bye with the count after the bye.

The result is significant for Geelong alone at *p* \< 0.05, albeit with
a very wide confidence interval.

|      Team       | estimate | p.value | conf.low | conf.high |
| :-------------: | :------: | :-----: | :------: | :-------: |
|     Geelong     |   21.4   | 0.01522 |  1.533   |   1396    |
|     Sydney      |   5.43   | 0.1698  |  0.6027  |   79.83   |
| North Melbourne |  0.1736  | 0.2941  | 0.002835 |   2.438   |
|    Richmond     |   3.68   | 0.3469  |  0.4059  |   43.34   |
|   Collingwood   |  3.719   | 0.3498  |  0.4048  |   53.81   |
|    Fremantle    |  3.719   | 0.3498  |  0.4048  |   53.81   |
|    St Kilda     |  0.3054  | 0.3698  | 0.03005  |   2.464   |
| Brisbane Lions  |  0.2769  |  0.582  | 0.00446  |   4.346   |
|    Hawthorn     |  0.3942  | 0.6285  | 0.02689  |   3.886   |
|    Adelaide     |  2.234   | 0.6499  |  0.2725  |   21.94   |
|     Carlton     |  0.5896  |    1    | 0.03705  |   7.114   |
|    Essendon     |  0.6562  |    1    | 0.06909  |   5.759   |
|    Footscray    |    1     |    1    |  0.1188  |   8.418   |
|   Gold Coast    |    1     |    1    | 0.01117  |   89.51   |
|       GWS       |    1     |    1    | 0.05191  |   19.26   |
|    Melbourne    |    1     |    1    |  0.1188  |   8.418   |
|  Port Adelaide  |  1.521   |    1    |  0.1731  |   15.02   |
|   West Coast    |  0.6573  |    1    |  0.0666  |   5.776   |

## Visualisation by home/away

Splitting the results further by home/away is interesting: Geelong has
lost all away games that occurred after a bye.

The only comparable team in that respect is Port Adelaide. However,
other teams have struggled to win away *before* a bye (Brisbane), or *at
home before* a bye (Carlton, North Melbourne). Of course, some teams
struggle to win regardless of venue, opponent or proximity to a bye
(Gold Coast).

![](bye_scoring_files/figure-gfm/plot-win-loss-03-1.png)<!-- -->

Note that several of the lost post-bye away games were at venues
traditionally viewed as being difficult to win at for an away team
(Adelaide,
Perth):

| Season | Round | Date       | Venue         | Margin | Status    | Team    | bye   | Result |
| -----: | :---- | :--------- | :------------ | -----: | :-------- | :------ | :---- | :----- |
|   2012 | R13   | 2012-06-22 | S.C.G.        |    \-6 | Away.Team | Geelong | after | L      |
|   2013 | R13   | 2013-06-23 | Gabba         |    \-5 | Away.Team | Geelong | after | L      |
|   2014 | R9    | 2014-05-17 | Subiaco       |   \-32 | Away.Team | Geelong | after | L      |
|   2017 | R13   | 2017-06-15 | Subiaco       |   \-13 | Away.Team | Geelong | after | L      |
|   2018 | R15   | 2018-06-29 | Docklands     |    \-2 | Away.Team | Geelong | after | L      |
|   2019 | R14   | 2019-06-22 | Adelaide Oval |   \-11 | Away.Team | Geelong | after | L      |

Also, three of the losses were against a side also coming off the bye,
but playing at
home:

| Season | Round | Date       | Venue   | Margin | Status    | Team    | bye   | Result |
| -----: | :---- | :--------- | :------ | -----: | :-------- | :------ | :---- | :----- |
|   2012 | R13   | 2012-06-22 | S.C.G.  |    \-6 | Away.Team | Geelong | after | L      |
|   2014 | R9    | 2014-05-17 | Subiaco |   \-32 | Away.Team | Geelong | after | L      |
|   2017 | R13   | 2017-06-15 | Subiaco |   \-13 | Away.Team | Geelong | after | L      |

For comparison, the away games before
byes:

| Season | Round | Date       | Venue             | Margin | Status    | Team    | bye    | Result |
| -----: | :---- | :--------- | :---------------- | -----: | :-------- | :------ | :----- | :----- |
|   2011 | R5    | 2011-04-26 | M.C.G.            |     19 | Away.Team | Geelong | before | W      |
|   2011 | R21   | 2011-08-14 | Football Park     |     11 | Away.Team | Geelong | before | W      |
|   2012 | R11   | 2012-06-08 | Docklands         |     12 | Away.Team | Geelong | before | W      |
|   2013 | R11   | 2013-06-08 | Sydney Showground |     59 | Away.Team | Geelong | before | W      |
|   2016 | R14   | 2016-06-25 | Docklands         |    \-3 | Away.Team | Geelong | before | L      |
|   2019 | R12   | 2019-06-07 | M.C.G.            |     67 | Away.Team | Geelong | before | W      |

## Odds

We might ask of the games lost after a bye - how many were Geelong
expected to win?

For this we join the dataset with historical betting odds. Their
accuracy is taken at face value.

Note that Geelong have never won after a bye when expected to lose. Of
their 8 losses after the bye, 2 were expected and 6 were not.

| bye    | Result | Expected | n |
| :----- | :----- | :------- | -: |
| after  | L      | L        | 2 |
| after  | L      | W        | 6 |
| after  | W      | W        | 1 |
| before | L      | L        | 1 |
| before | L      | W        | 1 |
| before | W      | L        | 1 |
| before | W      | W        | 6 |

# Conclusion

Geelong’s win/loss record after the bye does seem to be somewhat
unusual. Losses after the bye compared with before are significant and
unexpected.

Six of the eight post-bye losses have been away games, three of which
were against teams with strong records at home. Scheduling might
therefore explain some of the results.
