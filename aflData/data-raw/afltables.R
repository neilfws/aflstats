# afltables.R
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)
library(purrr)
library(janitor)
library(lubridate)

base_url <- "http://afltables.com/afl"
teams    <- list(adelaide = "Adelaide", brisbaneb = "Brisbane Bears", brisbanel = "Brisbane Lions",
                 carlton = "Carlton", collingwood = "Collingwood", essendon = "Essendon",
                 fitzroy = "Fitzroy", fremantle = "Fremantle", geelong = "Geelong",
                 goldcoast = "Gold Coast", gws = "Greater Western Sydney", hawthorn = "Hawthorn",
                 melbourne = "Melbourne", kangaroos = "North Melbourne",
                 padelaide = "Port Adelaide", richmond = "Richmond", stkilda = "St Kilda",
                 swans = "Sydney", university = "University", westcoast = "West Coast", bullldogs = "Western Bulldogs")

## things to note
# Sydney = South Melbourne 1897 - 1981
# Western Bulldogs = Footscray 1925 - 1996
# North Melbourne = Kangaroos 1999 - 2007
# when all games are concatenated they will be duplicated -
# filter for distinct date and venue
# use map_df to pass teams to allGames

assignHomeAway <- function(team, type, opponent) {
  switch(type,
         H = c(team, opponent),
         A = c(opponent, team),
         F = c(NA, NA))
}

assignResult <- function(team, type, opponent, result) {
}

allGames <- function(team) {
  team_url <- paste(base_url, "teams", team, "allgames.html", sep = "/")
  games <- read_html(team_url) %>%
    html_nodes(".sortable") %>%
    html_table(fill = TRUE) %>%
    map_df(clean_names) %>%
    rename(type = t, scoring_for = scoring, scoring_against = scoring_2, points_for = f, points_against = a,
           result = r, margin = m) %>%
    filter(!rnd %in% c("Totals", "Averages")) %>%
    mutate(team = teams$team, date = as.POSIXct(strptime(date, "%a %d-%b-%Y %I:%M %p"))) %>%
    select(team, everything()) %>%
    arrange(desc(as_date(date)))
  games
}

# allGames

