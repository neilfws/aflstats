library(tidyverse)
library(fitzRoy)

match_results <- lapply(2003:2021, function(x) fetch_results_afltables(x)) %>% 
  bind_rows()

blues <- match_results %>% 
  filter(Home.Team == "Carlton" | Away.Team == "Carlton",
         Season > 2002,
         Round.Type == "Regular") %>% 
  mutate(Percent = ifelse(Home.Team == "Carlton", 
                          100 * (Home.Points/Away.Points), 
                          100 * (Away.Points/Home.Points)),
         Margin = ifelse(Home.Team == "Carlton",
                         Margin,
                         -Margin),
         Coach = case_when(
           between(Date, as.Date("2003-03-29"), as.Date("2007-07-22")) ~ "Pagan",
           between(Date, as.Date("2007-07-28"), as.Date("2012-09-02")) ~ "Ratten",
           between(Date, as.Date("2013-03-28"), as.Date("2015-05-22")) ~ "Malthouse",
           between(Date, as.Date("2015-05-29"), as.Date("2015-09-05")) ~ "Barker",
           between(Date, as.Date("2016-03-24"), as.Date("2019-06-02")) ~ "Bolton",
           between(Date, as.Date("2019-06-08"), Sys.Date()) ~ "Teague"
         )) %>% 
  mutate(Coach = factor(Coach, levels = c("Pagan", "Ratten", "Malthouse", "Barker", "Bolton", "Teague")))

blues %>% 
  ggplot(aes(factor(Season), Percent)) + 
    geom_boxplot(aes(fill = Coach))  + 
    geom_hline(aes(yintercept = median(Percent))) + 
    scale_fill_brewer(palette = "Set2") + 
    labs(x = "Year", 
         y = "Percentage", 
         title = "Carlton game percentages by season under different coaches") +
  theme_bw()

blues %>% 
  ggplot(aes(Date, Margin)) + 
  geom_point(aes(color = Coach)) + 
  geom_hline(yintercept = 0, linetype = "dashed") + 
  scale_color_brewer(palette = "Set2") + 
  labs(x = "Date", 
       y = "Margin", 
       title = "Carlton game margins by coach 2003 - 2021", 
       subtitle = "H&A season only, round 1 2003 - round 14 2021")

