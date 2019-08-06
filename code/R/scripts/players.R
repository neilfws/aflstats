library(rvest)
library(stringr)
library(lubridate)


age_to_date <- function(born, age) {
  age <- str_split(age, "\\s+")
  age_year <- age[[1]][1] %>%
    gsub("y", "", .) %>%
    as.numeric()
  age_day <- age[[1]][2] %>%
    gsub("d", "", .) %>%
    as.numeric() %>%
    ifelse(is.na(.), 0, .)
  age <- born + years(age_year) + days(age_day)
  age
}

player_stats <- function(u) {
  
  page <- read_html(u)
  main <- page %>%
    html_nodes("body center") %>% 
    html_text()
  games <- page %>%
    html_node("table.sortable") %>%
    html_table()
  
  born <- main %>% 
    str_match(., "Born:(.*?) ") %>% .[, 2] %>%
    dmy()
  debut <- main %>% 
    str_match(., "Debut:(.*?)Last") %>% .[, 2]
  last <- main %>% 
    str_match(., "Last:(.*?)\\)") %>% .[, 2]
  total_games <- games %>%
    dplyr::filter(Year == "Totals") %>%
    .$GM
  height <- main %>% 
    str_match(., "Height:(.*?)Weight") %>% .[, 2] %>%
    gsub("\\s+cm\\s+", "", .) %>%
    as.numeric()
  weight <- main %>% 
    str_match(., "Weight:(.+)") %>% .[, 2] %>%
    gsub(" kg", "", .) %>%
    as.numeric()
  
  # debut to date
  debut <- age_to_date(born, debut)
  
  # last to date
  last <- age_to_date(born, last)

  tibble(url = u,
         born = born, 
         height = height, 
         weight = weight, 
         games = total_games,
         debut = debut, 
         last = last)
}