library(tidyverse)
library(fitzRoy)

afldata <- fetch_player_stats_afltables(season = 2003:year(Sys.Date()))

match_results <- afldata %>% 
  distinct(Season, Date, Round, Venue, Home.team, Home.score, Away.team, Away.score, Playing.for, Coach) %>% 
  mutate(Margin = Home.score - Away.score,
         Round.Type = ifelse(grepl("F", Round), "Finals", "Regular"))

blues <- match_results %>% 
  filter(Playing.for == "Carlton",
         Round.Type == "Regular") %>% 
  mutate(Percent = ifelse(Home.team == "Carlton", 
                          100 * (Home.score/Away.score), 
                          100 * (Away.score/Home.score)),
         Margin = ifelse(Home.team == "Carlton",
                         Margin,
                         -Margin))

# doesn't fill as may be > 1 coach/season
blues %>% 
  ggplot(aes(Season, Percent)) + 
    geom_boxplot(aes(fill = Coach,
                     group = Season))  + 
    geom_hline(aes(yintercept = median(Percent))) + 
    scale_fill_brewer(palette = "Set2") + 
    labs(x = "Year", 
         y = "Percentage", 
         title = "Carlton game percentages by season under different coaches") +
  theme_bw()

# better
blues %>% 
  ggplot(aes(Date, Margin)) + 
  geom_point(
    aes(color = Coach)
    ) + 
  geom_hline(
    yintercept = 0, 
    linetype = "dashed") +
  scale_color_brewer(palette = "Set2") + 
  labs(x = "Date", 
       y = "Margin", 
       title = "Carlton game margins by coach",
       subtitle = paste0("2003 - ", year(Sys.Date()))) +
  theme_bw()

# jitter
blues %>% 
  ggplot(aes(Season, Margin)) + 
  geom_jitter(
    aes(color = Coach),
    width = 0.2
  ) +
  stat_summary(
#    fun.y = mean,
#    fun.ymin = mean,
#    fun.ymax = mean,
    fun.data = mean_cl_normal,
    geom = "crossbar",
    width = 0.5,
    aes(color = Coach)
  ) + 
  geom_hline(
    yintercept = 0, 
    linetype = "dashed") +
  scale_color_brewer(palette = "Set2") + 
  labs(x = "Date", 
       y = "Margin", 
       title = "Carlton game margins by coach",
       subtitle = paste0("2003 - ", year(Sys.Date()))) +
  theme_bw()


+
  stat_summary(
    fun.y = mean,
    fun.ymin = mean,
    fun.ymax = mean,
    geom = "crossbar",
    width = 0.5,
    aes(color = Coach)
  )