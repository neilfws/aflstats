How often has the same team lineup played a game of V/AFL?
================
Neil Saunders
compiled 2022-03-25 16:21:57

# Summary

There have been almost 16 000 V/AFL games. How many times has a team
made up of the same players played in a game?

# Generate and count the lineups

We start with a dataset of 15992 V/AFL games, obtained using
`fitzRoy::get_fryzigg_stats()` (which is deprecated but does what we
want - gets all games in one call).

We group by game ID and team. This lets us create the team list by
sorting player IDs and combining them into a string. We need to sort,
otherwise the same players in a different order won’t count as the same
team.

Now we can count the player lists and retain those that occur more than
once.

``` r
lineup_multiple_games <- afldata %>% 
  group_by(match_id, player_team) %>% 
  summarise(squad = paste(sort(player_id), collapse = ";")) %>% 
  ungroup() %>% 
  count(player_team, squad, sort = TRUE, name = "n_games") %>% 
  filter(n_games > 1) %>% 
  mutate(n_players = str_count(squad, ";") + 1)
```

# Join back to the original game data

We repeat the procedure but group on more variables. Then we can join
with the squads and their counts.

``` r
games_same_lineup <- afldata %>% 
  group_by(match_id, match_date, match_round, venue_name, player_team) %>% 
  summarise(squad = paste(sort(player_id), collapse = ";")) %>% 
  ungroup() %>% 
  inner_join(lineup_multiple_games)
```

# Analysis

## Most games

What’s the most games played by the same lineup of players?

7, by South Melbourne (named Sydney here) in 1924.

``` r
games_same_lineup %>% 
  filter(n_games == max(n_games)) %>% 
  select(-squad) %>% 
  kable() %>% 
  kable_styling(bootstrap_options = c("striped", "condensed"))
```

<table class="table table-striped table-condensed" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:right;">
match_id
</th>
<th style="text-align:left;">
match_date
</th>
<th style="text-align:left;">
match_round
</th>
<th style="text-align:left;">
venue_name
</th>
<th style="text-align:left;">
player_team
</th>
<th style="text-align:right;">
n_games
</th>
<th style="text-align:right;">
n_players
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
2038
</td>
<td style="text-align:left;">
1924-05-24
</td>
<td style="text-align:left;">
5
</td>
<td style="text-align:left;">
MCG
</td>
<td style="text-align:left;">
Sydney
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
18
</td>
</tr>
<tr>
<td style="text-align:right;">
2039
</td>
<td style="text-align:left;">
1924-05-31
</td>
<td style="text-align:left;">
6
</td>
<td style="text-align:left;">
Lake Oval
</td>
<td style="text-align:left;">
Sydney
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
18
</td>
</tr>
<tr>
<td style="text-align:right;">
2043
</td>
<td style="text-align:left;">
1924-06-07
</td>
<td style="text-align:left;">
7
</td>
<td style="text-align:left;">
Ikon Park
</td>
<td style="text-align:left;">
Sydney
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
18
</td>
</tr>
<tr>
<td style="text-align:right;">
2054
</td>
<td style="text-align:left;">
1924-06-21
</td>
<td style="text-align:left;">
9
</td>
<td style="text-align:left;">
Lake Oval
</td>
<td style="text-align:left;">
Sydney
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
18
</td>
</tr>
<tr>
<td style="text-align:right;">
2065
</td>
<td style="text-align:left;">
1924-07-12
</td>
<td style="text-align:left;">
12
</td>
<td style="text-align:left;">
Lake Oval
</td>
<td style="text-align:left;">
Sydney
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
18
</td>
</tr>
<tr>
<td style="text-align:right;">
2079
</td>
<td style="text-align:left;">
1924-08-23
</td>
<td style="text-align:left;">
16
</td>
<td style="text-align:left;">
Lake Oval
</td>
<td style="text-align:left;">
Sydney
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
18
</td>
</tr>
<tr>
<td style="text-align:right;">
2092
</td>
<td style="text-align:left;">
1924-09-13
</td>
<td style="text-align:left;">
Semi Final
</td>
<td style="text-align:left;">
Windy Hill
</td>
<td style="text-align:left;">
Sydney
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
18
</td>
</tr>
</tbody>
</table>

## Most games with 22 players

How about the most games played by the same lineup of players in the 22
players per team era?

5, which has happened for 3 teams: Sydney in 2005, Adelaide in 2016 and
Brisbane in 2019.

``` r
games_same_lineup %>% 
  filter(n_players == 22) %>% 
  filter(n_games == max(n_games)) %>% 
  select(-squad) %>% 
  kable() %>% 
  kable_styling(bootstrap_options = c("striped", "condensed"))
```

<table class="table table-striped table-condensed" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:right;">
match_id
</th>
<th style="text-align:left;">
match_date
</th>
<th style="text-align:left;">
match_round
</th>
<th style="text-align:left;">
venue_name
</th>
<th style="text-align:left;">
player_team
</th>
<th style="text-align:right;">
n_games
</th>
<th style="text-align:right;">
n_players
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
12800
</td>
<td style="text-align:left;">
2005-08-06
</td>
<td style="text-align:left;">
19
</td>
<td style="text-align:left;">
Marvel Stadium
</td>
<td style="text-align:left;">
Sydney
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
12810
</td>
<td style="text-align:left;">
2005-08-14
</td>
<td style="text-align:left;">
20
</td>
<td style="text-align:left;">
ANZ Stadium
</td>
<td style="text-align:left;">
Sydney
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
12818
</td>
<td style="text-align:left;">
2005-08-21
</td>
<td style="text-align:left;">
21
</td>
<td style="text-align:left;">
SCG
</td>
<td style="text-align:left;">
Sydney
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
12822
</td>
<td style="text-align:left;">
2005-08-27
</td>
<td style="text-align:left;">
22
</td>
<td style="text-align:left;">
MCG
</td>
<td style="text-align:left;">
Sydney
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
12829
</td>
<td style="text-align:left;">
2005-09-02
</td>
<td style="text-align:left;">
Qualifying Final
</td>
<td style="text-align:left;">
Subiaco
</td>
<td style="text-align:left;">
Sydney
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
14901
</td>
<td style="text-align:left;">
2016-06-23
</td>
<td style="text-align:left;">
14
</td>
<td style="text-align:left;">
Adelaide Oval
</td>
<td style="text-align:left;">
Adelaide
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
14912
</td>
<td style="text-align:left;">
2016-07-03
</td>
<td style="text-align:left;">
15
</td>
<td style="text-align:left;">
MCG
</td>
<td style="text-align:left;">
Adelaide
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
14972
</td>
<td style="text-align:left;">
2016-08-20
</td>
<td style="text-align:left;">
22
</td>
<td style="text-align:left;">
Adelaide Oval
</td>
<td style="text-align:left;">
Adelaide
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
14988
</td>
<td style="text-align:left;">
2016-09-10
</td>
<td style="text-align:left;">
Elimination Final
</td>
<td style="text-align:left;">
Adelaide Oval
</td>
<td style="text-align:left;">
Adelaide
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
14990
</td>
<td style="text-align:left;">
2016-09-17
</td>
<td style="text-align:left;">
Semi Final
</td>
<td style="text-align:left;">
SCG
</td>
<td style="text-align:left;">
Adelaide
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
15556
</td>
<td style="text-align:left;">
2019-07-20
</td>
<td style="text-align:left;">
18
</td>
<td style="text-align:left;">
Gabba
</td>
<td style="text-align:left;">
Brisbane Lions
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
15578
</td>
<td style="text-align:left;">
2019-08-04
</td>
<td style="text-align:left;">
20
</td>
<td style="text-align:left;">
Gabba
</td>
<td style="text-align:left;">
Brisbane Lions
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
15582
</td>
<td style="text-align:left;">
2019-08-10
</td>
<td style="text-align:left;">
21
</td>
<td style="text-align:left;">
Gabba
</td>
<td style="text-align:left;">
Brisbane Lions
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
15590
</td>
<td style="text-align:left;">
2019-08-17
</td>
<td style="text-align:left;">
22
</td>
<td style="text-align:left;">
Gabba
</td>
<td style="text-align:left;">
Brisbane Lions
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
15609
</td>
<td style="text-align:left;">
2019-09-07
</td>
<td style="text-align:left;">
Qualifying Final
</td>
<td style="text-align:left;">
Gabba
</td>
<td style="text-align:left;">
Brisbane Lions
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
22
</td>
</tr>
</tbody>
</table>

## Games with the same lineup across seasons

Has the same lineup ever played a game in more than one season?

Just once: the same Western Bulldogs team played in 2005 and 2006.

``` r
games_same_lineup %>% 
  group_by(squad) %>% 
  filter(n_distinct(year(match_date)) > 1) %>% 
  ungroup() %>% 
  select(-squad) %>% 
  kable() %>% 
  kable_styling(bootstrap_options = c("striped", "condensed"))
```

<table class="table table-striped table-condensed" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:right;">
match_id
</th>
<th style="text-align:left;">
match_date
</th>
<th style="text-align:left;">
match_round
</th>
<th style="text-align:left;">
venue_name
</th>
<th style="text-align:left;">
player_team
</th>
<th style="text-align:right;">
n_games
</th>
<th style="text-align:right;">
n_players
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
12731
</td>
<td style="text-align:left;">
2005-05-29
</td>
<td style="text-align:left;">
10
</td>
<td style="text-align:left;">
Marvel Stadium
</td>
<td style="text-align:left;">
Western Bulldogs
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
12839
</td>
<td style="text-align:left;">
2006-03-31
</td>
<td style="text-align:left;">
1
</td>
<td style="text-align:left;">
Marvel Stadium
</td>
<td style="text-align:left;">
Western Bulldogs
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
22
</td>
</tr>
<tr>
<td style="text-align:right;">
12847
</td>
<td style="text-align:left;">
2006-04-08
</td>
<td style="text-align:left;">
2
</td>
<td style="text-align:left;">
Marvel Stadium
</td>
<td style="text-align:left;">
Western Bulldogs
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
22
</td>
</tr>
</tbody>
</table>

## Games with the same lineup for both teams

Let’s see if the logic is correct here.

If two teams of the same players play each other, then the match ID
appears twice in our dataset.

If those teams play more than one game against each other then an
ordered string composed of all players from both teams should be counted
more than once.

If we got this correct: it seems that 99 games have involved two teams
of players which have played in other games, but never more than once
against each other. In other words the same two opposing lineups have
never played each other more than once.

``` r
games_same_lineup %>% 
  group_by(match_id) %>% 
  filter(n() > 1) %>% 
  summarise(players = join_teams(first(squad), last(squad))) %>% 
  ungroup() %>% 
  count(players, name = "n_games") %>% 
  count(n_games) %>% 
  kable() %>% 
  kable_styling(bootstrap_options = c("striped", "condensed"))
```

<table class="table table-striped table-condensed" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:right;">
n_games
</th>
<th style="text-align:right;">
n
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
99
</td>
</tr>
</tbody>
</table>
