# aflstats
This repository contains code to analyse AFL data from a number of online sources, principally the excellent [afltables.com](http://afltables.com/afl/afl_index.html) website.

The repository is currently a bit of a mess; reorganisation is on my to-do list.

## Reports
Located in `code/R/Rmd`.

1. [Career length of senior AFL coaches: R versus The Age](https://github.com/neilfws/aflstats/blob/master/code/R/Rmd/coaches_career_length/coaches.md)
1. [AFL/VFL Drawn Games](https://github.com/neilfws/aflstats/blob/master/code/R/Rmd/drawn_games/drawn_games.md)
1. [The Sydney Swans/SMFC all-time player list](https://github.com/neilfws/aflstats/blob/master/code/R/Rmd/swans_alltime_players/swans_alltime.md)
1. [Sydney Swans Home Game Crowds](https://github.com/neilfws/aflstats/blob/master/code/R/Rmd/swans_home_crowd/swans_home_crowd.md)
1. [Sydney Swans wet weather performance at the SCG](https://github.com/neilfws/aflstats/blob/master/code/R/Rmd/swans_scg_rain/scg_rain.md)
1. [Sydney Swans/South Melbourne greatest (and worst) Q4 turnarounds](https://github.com/neilfws/aflstats/blob/master/code/R/Rmd/swans_turnarounds/turnaround.md)
1. [Sydney Swans versus the rest](https://github.com/neilfws/aflstats/blob/master/code/R/Rmd/swans_versus_x/swans_versus_x.md)
1. [Geelong and the bye](https://github.com/neilfws/aflstats/blob/master/code/R/Rmd/bye_scoring/bye_scoring.md)
1. [Post-bye games visualisation and analysis](https://github.com/neilfws/aflstats/blob/master/code/R/Rmd/bye_scoring/post_bye_results.md)
1. [Returning coaches](https://github.com/neilfws/aflstats/blob/master/code/R/Rmd/returning_coaches/returning_coaches.md)
1. [All-Australian](https://github.com/neilfws/aflstats/blob/master/code/R/Rmd/all_australian/all_australian.md)

## Scripts
Located in `code/R/scripts`.

1. aflblues.R - plots Carlton's percentage by season under different coaches
1. afltables.R - functions for getting data from afltables.com into data frames
1. clubpayments.R - plots club payments using data extracted from the AFL 2013 report
1. players.R - plots age distribution of players in a given season (currently 2014)
1. plotHalfwayPercent.R - plots team percentage up to the halfway stage of the season; comparing the median to the historical median is some indication of finals likelihood

## output
Contains plots in PDF and PNG format, principally the outout of `plotHalfwayPercent.R`

## data
The `.RData` files for each team contain a data frame, `team.games`, with information about every game to date for that team. The files are updated weekly when `plotHalfwayPercent.R` is run.
