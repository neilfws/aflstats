library(tidyverse)
library(lubridate)
library(rvest)

# function to get match, date and lengths of quarters
get_match_times <- function(match_url) {
  
  # for debug
  cat(match_url, "\n")
  
  p <- read_html(match_url)
  # don't hammer server (much)
  Sys.sleep(1)
  
  match_id <- str_match(match_url, "\\/(\\d+)\\.html")[, 2] %>% 
    as.numeric()
  
  match_date <- p %>% 
    html_elements(., xpath = "//table[1]/tr[1]/td[2]") %>% 
    html_text() %>% 
    str_match(., "Date:\\s+[A-Za-z]{3},\\s+(.*?)\\s+") %>% 
    .[[2]] %>% 
    dmy()
  
  quarters <- p %>% 
    html_elements(., xpath = "//tr/td") %>% 
    html_text() %>% 
    str_match(., "quarter\\s+\\((.*?)\\)") %>%
    .[!is.na(.)] %>% 
    .[5:8] %>% 
    ms(.) %>% 
    as.numeric()
  
  match_data <- tibble(
    url = match_url,
    match_id = match_id,
    match_date = match_date
  ) %>% 
    bind_cols(., matrix(quarters,
                        nrow = 1,
                        dimnames = list("", c("Q1", "Q2", "Q3", "Q4"))))
  
  match_data

}

# sample usage
# get page for a season
season2025 <- "https://afltables.com/afl/seas/2025.html"

# get pages for each game
games2025 <- season2025 %>% 
  read_html() %>% 
  html_elements("a") %>% 
  html_attr('href') %>% 
  .[grepl("stats/games", .)]

# change relative path to absolute URL
games2025 <- str_replace(games2025, "../", "https://afltables.com/afl/")

# get AFL Tables match ID, date and quarter lengths in seconds for each game
# and put into a tibble
quarters2025 <- lapply(games2025, get_match_times) %>% 
  bind_rows()
