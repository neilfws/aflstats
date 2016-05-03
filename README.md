# aflstats

This repository contains code to analyse AFL data from a number of online sources, principally the excellent [afltables.com](http://afltables.com/afl/afl_index.html) website.

The repository is currently a bit of a mess; reorganisation is on my to-do list. Here's a brief description of the files currently in `code/R`.

1. afl_members.R - plots membership number using data from [this site](http://www.aflmembershipnumbers.com/index.html)
2. aflblues.R - plots Carlton's percentage by season under Ratten and Malthouse (to do: Bolton)
3. afltables.R - functions for getting data from afltables.com into data frames
4. clubpayments.R - plots club payments using data extracted from the AFL 2013 report
5. players.R - plots age distribution of players in a given season (currently 2014)
6. plotHalfwayPercent.R - plots team percentage up to the halfway stage of the season; comparing the median to the historical median is some indication of finals likelihood

## output

Contains plots in PDF and PNG format, principally the outout of `plotHalfwayPercent.R`

## data
The `.RData` files for each team contain a data frame, `team.games`, with information about every game to date for that team. The files are updated weekly when `plotHalfwayPercent.R` is run.
