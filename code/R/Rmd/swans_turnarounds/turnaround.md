Sydney Swans/South Melbourne greatest (and worst) Q4 turnarounds
================
Neil Saunders
compiled 2021-12-16 15:29:12

-   [Introduction](#introduction)
-   [Getting the data](#getting-the-data)
-   [Analysis](#analysis)
    -   [Come from behind at Q3 to win](#come-from-behind-at-q3-to-win)
    -   [Slip from in front at Q3 to
        lose](#slip-from-in-front-at-q3-to-lose)

# Introduction

How many times have the Swans come from behind going into the last
quarter to win? Or been in front, but then gone on to lose? In each
case, what were the biggest swings in the scoreline?

# Getting the data

We download and process Swans game data from [AFL
Tables](http://afltables.com).

There are currently 2492 of them.

# Analysis

## Come from behind at Q3 to win

We select the subset of cases where the margin is negative at the end of
Q3, but the result is a win. Then we sort by the difference between Q3
and Q4 margin.

The top 10:

|        date         | rnd | type |    opponent    | q3margin | margin |
|:-------------------:|:---:|:----:|:--------------:|:--------:|:------:|
| 1995-04-30 14:15:00 | R5  |  H   |    Adelaide    |   -17    |   57   |
| 2002-08-10 19:10:00 | R19 |  A   |   Kangaroos    |   -11    |   47   |
| 1915-06-12 15:00:00 | R8  |  H   |    Geelong     |   -29    |   18   |
| 2015-04-04 16:35:00 | R1  |  H   |    Essendon    |   -34    |   12   |
| 1987-04-25 14:10:00 | R5  |  A   |    Richmond    |   -26    |   20   |
| 1990-08-17 19:40:00 | R20 |  H   | Brisbane Bears |   -14    |   31   |
| 1933-05-06 14:45:00 | R2  |  H   |   Footscray    |   -19    |   26   |
| 1926-07-17 14:45:00 | R12 |  A   |    Richmond    |   -12    |   33   |
| 2003-04-25 18:45:00 | R5  |  H   |   Melbourne    |   -20    |   24   |
| 1958-07-19 14:15:00 | R13 |  H   |    Fitzroy     |   -12    |   32   |
| 1933-09-16 14:30:00 | SF  |  F   |    Richmond    |   -26    |   18   |

They’ve come from behind in Q3 to win 181 times.

## Slip from in front at Q3 to lose

The procedure is very similar, except that we select the cases where
margin is positive at the end of Q3, but the result is a loss.

|        date         | rnd | type |    opponent     | q3margin | margin |
|:-------------------:|:---:|:----:|:---------------:|:--------:|:------:|
| 1936-07-25 14:30:00 | R12 |  A   |    Melbourne    |    12    |  -52   |
| 1938-05-14 14:45:00 | R4  |  A   |    Melbourne    |    11    |  -52   |
| 1991-04-25 14:10:00 | R6  |  A   | North Melbourne |    2     |  -54   |
| 1962-07-21 14:20:00 | R13 |  H   |    St Kilda     |    36    |  -17   |
| 1991-04-19 19:40:00 | R5  |  H   |    Essendon     |    21    |  -31   |
| 1978-04-22 14:10:00 | R4  |  A   |     Fitzroy     |    32    |  -19   |
| 1992-07-25 14:10:00 | R19 |  A   |    Footscray    |    2     |  -46   |
| 1957-05-18 14:15:00 | R5  |  H   |    Essendon     |    5     |  -42   |
| 2004-08-07 19:10:00 | R19 |  H   |    Kangaroos    |    40    |   -6   |
| 1937-06-05 14:30:00 | R7  |  A   |    Essendon     |    12    |  -32   |

They’ve thrown it away in the last quarter 163 times.
