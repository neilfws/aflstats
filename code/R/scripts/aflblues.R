library(tidyverse)
library(fitzRoy)

match_results %>% 
  filter(Home.Team == "Carlton" | Away.Team == "Carlton") %>% 
  mutate(Percent = ifelse(Home.Team == "Carlton", 
                          100 * (Home.Points/Away.Points), 
                          100 * (Away.Points/Home.Points)),
         Coach = ifelse(Season > 2012, "Malthouse", "Ratten"),
         Coach = ifelse(Season == 2015, "Malthouse/Barker", Coach),
         Coach = ifelse(Season > 2015, "Bolton", Coach)) %>% 
  filter(Season > 2006, 
         Round.Type == "Regular") %>% 
  ggplot(aes(factor(Season), Percent)) + 
    geom_boxplot(aes(fill = Coach))  + 
    geom_hline(aes(yintercept = median(Percent))) + 
    scale_fill_brewer(palette = "Spectral") + 
    labs(x = "Year", 
         y = "Percentage", 
         title = "Carlton game percentages by season under different coaches") +
  theme_bw()
