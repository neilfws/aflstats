Returning AFL coaches
================
Neil Saunders
2022-10-14 21:20:56

- <a href="#introduction" id="toc-introduction">Introduction</a>
- <a href="#data-processing" id="toc-data-processing">Data processing</a>
- <a href="#coaching-data" id="toc-coaching-data">Coaching data</a>
  - <a href="#counting-clubs" id="toc-counting-clubs">Counting clubs</a>
  - <a href="#worked-examples" id="toc-worked-examples">Worked examples</a>
    - <a href="#mick-malthouse" id="toc-mick-malthouse">Mick Malthouse</a>
    - <a href="#jock-mchale" id="toc-jock-mchale">Jock McHale</a>
    - <a href="#allan-jeans" id="toc-allan-jeans">Allan Jeans</a>
    - <a href="#david-parkin" id="toc-david-parkin">David Parkin</a>
- <a href="#putting-it-all-together"
  id="toc-putting-it-all-together">Putting it all together</a>

# Introduction

We might ask the question:

> Surely Ross Lyon doesn't coach at StK. But if he did, how many coaches
> have returned to a previously coached at club?
>
> — Liam Crow (@crow_data_sci) [October 14,
> 2022](https://twitter.com/crow_data_sci/status/1580744416561856512)

Let’s try to find out using data from [AFL
Tables](https://afltables.com/afl/afl_index.html).

# Data processing

# Coaching data

Coach names and links to their individual data are located [in this HTML
table](https://afltables.com/afl/stats/coaches/coaches_idx.html).

We can fetch and process it like so:

``` r
p <- read_html("https://afltables.com/afl/stats/coaches/coaches_idx.html")
coaches <- tibble(name = p %>% 
                    html_nodes("table a") %>% 
                    html_text(), 
                  link = p %>% 
                    html_nodes("table a") %>% 
                    html_attr("href")) %>% 
  slice(1:378)
```

``` r
coaches %>% 
  head(10) %>% 
  kbl(format = "simple") %>% 
    kable_styling(bootstrap_options = c("striped"))
```

| name            | link                |
|:----------------|:--------------------|
| Malthouse, Mick | Mick_Malthouse.html |
| McHale, Jock    | Jock_McHale.html    |
| Sheedy, Kevin   | Kevin_Sheedy.html   |
| Jeans, Allan    | Allan_Jeans.html    |
| Hafey, Tom      | Tom_Hafey.html      |
| Parkin, David   | David_Parkin.html   |
| Barassi, Ron    | Ron_Barassi0.html   |
| Matthews, Leigh | Leigh_Matthews.html |
| Smith, Norm     | Norm_Smith.html     |
| Reynolds, Dick  | Dick_Reynolds.html  |

## Counting clubs

The function `count_coaches_teams()` does the following:

1.  Fetches the data page for a coach
2.  Extracts the names of each club coached and the years that the coach
    was at the club
3.  Determines whether the coach (1) left to coach another club and then
    returned or (2) had a break of one or more seasons then returned to
    the same club
4.  Returns the results

``` r
count_coaches_teams <- function(coachhtml) {
  coachurl <- paste0("https://afltables.com/afl/stats/coaches/", coachhtml) %>% 
    URLencode()
  coach_data <- coachurl %>% 
    read_html() %>% 
    html_table(header = FALSE) %>%
    .[[1]] %>%
    filter(str_detect(X1, "\\d{4}")) %>%
    select(1:2) %>% 
    setNames(c("year", "team"))
  
  team_count <- coach_data %>% 
    mutate(from = lag(team, default = "None"), 
           to = team,
           year = as.numeric(year),
           flag_same_club = ifelse(from == to, 1, 0),
           flag_gap_year = ifelse(year - lag(year) > 1, 1, 0))
  
  diff_team_count <- team_count %>% 
    filter(flag_same_club == 0) %>% 
    count(to) %>% 
    filter(n > 1) %>% 
    mutate(link = coachhtml,
           type = "return from other club")
  
  same_team_count <- team_count %>% 
    filter(flag_same_club == 1,
           flag_gap_year == 1) %>% 
    count(to) %>% 
    mutate(link = coachhtml,
           type = "return to same club after break")
  
  output <- bind_rows(diff_team_count, same_team_count)
  output
}
```

## Worked examples

### Mick Malthouse

Coached 4 different clubs, consecutively with no breaks. Therefore
`count_coaches_teams` returns no rows.

``` r
  coach_data <- "https://afltables.com/afl/stats/coaches/Mick_Malthouse.html" %>% 
    read_html() %>% 
    html_table(header = FALSE) %>%
    .[[1]] %>%
    filter(str_detect(X1, "\\d{4}")) %>%
    select(1:2) %>% 
    setNames(c("year", "team"))

coach_data
```

    ## # A tibble: 31 × 2
    ##    year  team      
    ##    <chr> <chr>     
    ##  1 1984  Footscray 
    ##  2 1985  Footscray 
    ##  3 1986  Footscray 
    ##  4 1987  Footscray 
    ##  5 1988  Footscray 
    ##  6 1989  Footscray 
    ##  7 1990  West Coast
    ##  8 1991  West Coast
    ##  9 1992  West Coast
    ## 10 1993  West Coast
    ## # … with 21 more rows

``` r
  team_count <- coach_data %>% 
    mutate(from = lag(team, default = "None"), 
           to = team,
           year = as.numeric(year),
           flag_same_club = ifelse(from == to, 1, 0),
           flag_gap_year = ifelse(year - lag(year) > 1, 1, 0))

team_count
```

    ## # A tibble: 31 × 6
    ##     year team       from       to         flag_same_club flag_gap_year
    ##    <dbl> <chr>      <chr>      <chr>               <dbl>         <dbl>
    ##  1  1984 Footscray  None       Footscray               0            NA
    ##  2  1985 Footscray  Footscray  Footscray               1             0
    ##  3  1986 Footscray  Footscray  Footscray               1             0
    ##  4  1987 Footscray  Footscray  Footscray               1             0
    ##  5  1988 Footscray  Footscray  Footscray               1             0
    ##  6  1989 Footscray  Footscray  Footscray               1             0
    ##  7  1990 West Coast Footscray  West Coast              0             0
    ##  8  1991 West Coast West Coast West Coast              1             0
    ##  9  1992 West Coast West Coast West Coast              1             0
    ## 10  1993 West Coast West Coast West Coast              1             0
    ## # … with 21 more rows

``` r
mm <- count_coaches_teams("Mick_Malthouse.html")

mm
```

    ## # A tibble: 0 × 4
    ## # … with 4 variables: to <chr>, n <int>, link <chr>, type <chr>

### Jock McHale

Coached 1 club continuously with no breaks. Therefore
`count_coaches_teams` returns no rows.

``` r
  coach_data <- "https://afltables.com/afl/stats/coaches/Jock_McHale.html" %>% 
    read_html() %>% 
    html_table(header = FALSE) %>%
    .[[1]] %>%
    filter(str_detect(X1, "\\d{4}")) %>%
    select(1:2) %>% 
    setNames(c("year", "team"))

coach_data
```

    ## # A tibble: 38 × 2
    ##    year  team       
    ##    <chr> <chr>      
    ##  1 1912  Collingwood
    ##  2 1913  Collingwood
    ##  3 1914  Collingwood
    ##  4 1915  Collingwood
    ##  5 1916  Collingwood
    ##  6 1917  Collingwood
    ##  7 1918  Collingwood
    ##  8 1919  Collingwood
    ##  9 1920  Collingwood
    ## 10 1921  Collingwood
    ## # … with 28 more rows

``` r
  team_count <- coach_data %>% 
    mutate(from = lag(team, default = "None"), 
           to = team,
           year = as.numeric(year),
           flag_same_club = ifelse(from == to, 1, 0),
           flag_gap_year = ifelse(year - lag(year) > 1, 1, 0))

team_count
```

    ## # A tibble: 38 × 6
    ##     year team        from        to          flag_same_club flag_gap_year
    ##    <dbl> <chr>       <chr>       <chr>                <dbl>         <dbl>
    ##  1  1912 Collingwood None        Collingwood              0            NA
    ##  2  1913 Collingwood Collingwood Collingwood              1             0
    ##  3  1914 Collingwood Collingwood Collingwood              1             0
    ##  4  1915 Collingwood Collingwood Collingwood              1             0
    ##  5  1916 Collingwood Collingwood Collingwood              1             0
    ##  6  1917 Collingwood Collingwood Collingwood              1             0
    ##  7  1918 Collingwood Collingwood Collingwood              1             0
    ##  8  1919 Collingwood Collingwood Collingwood              1             0
    ##  9  1920 Collingwood Collingwood Collingwood              1             0
    ## 10  1921 Collingwood Collingwood Collingwood              1             0
    ## # … with 28 more rows

``` r
jm <- count_coaches_teams("Jock_McHale.html")

jm
```

    ## # A tibble: 0 × 4
    ## # … with 4 variables: to <chr>, n <int>, link <chr>, type <chr>

### Allan Jeans

Coached 3 clubs, the first continuously, the second with a break.

``` r
  coach_data <- "https://afltables.com/afl/stats/coaches/Allan_Jeans.html" %>% 
    read_html() %>% 
    html_table(header = FALSE) %>%
    .[[1]] %>%
    filter(str_detect(X1, "\\d{4}")) %>%
    select(1:2) %>% 
    setNames(c("year", "team"))

coach_data
```

    ## # A tibble: 26 × 2
    ##    year  team    
    ##    <chr> <chr>   
    ##  1 1961  St Kilda
    ##  2 1962  St Kilda
    ##  3 1963  St Kilda
    ##  4 1964  St Kilda
    ##  5 1965  St Kilda
    ##  6 1966  St Kilda
    ##  7 1967  St Kilda
    ##  8 1968  St Kilda
    ##  9 1969  St Kilda
    ## 10 1970  St Kilda
    ## # … with 16 more rows

``` r
  team_count <- coach_data %>% 
    mutate(from = lag(team, default = "None"), 
           to = team,
           year = as.numeric(year),
           flag_same_club = ifelse(from == to, 1, 0),
           flag_gap_year = ifelse(year - lag(year) > 1, 1, 0))

team_count
```

    ## # A tibble: 26 × 6
    ##     year team     from     to       flag_same_club flag_gap_year
    ##    <dbl> <chr>    <chr>    <chr>             <dbl>         <dbl>
    ##  1  1961 St Kilda None     St Kilda              0            NA
    ##  2  1962 St Kilda St Kilda St Kilda              1             0
    ##  3  1963 St Kilda St Kilda St Kilda              1             0
    ##  4  1964 St Kilda St Kilda St Kilda              1             0
    ##  5  1965 St Kilda St Kilda St Kilda              1             0
    ##  6  1966 St Kilda St Kilda St Kilda              1             0
    ##  7  1967 St Kilda St Kilda St Kilda              1             0
    ##  8  1968 St Kilda St Kilda St Kilda              1             0
    ##  9  1969 St Kilda St Kilda St Kilda              1             0
    ## 10  1970 St Kilda St Kilda St Kilda              1             0
    ## # … with 16 more rows

``` r
aj <- count_coaches_teams("Allan_Jeans.html")

aj
```

    ## # A tibble: 1 × 4
    ##   to           n link             type                           
    ##   <chr>    <int> <chr>            <chr>                          
    ## 1 Hawthorn     1 Allan_Jeans.html return to same club after break

### David Parkin

Coached 3 clubs, returning to Carlton after a spell at Fitzroy.

``` r
  coach_data <- "https://afltables.com/afl/stats/coaches/David_Parkin.html" %>% 
    read_html() %>% 
    html_table(header = FALSE) %>%
    .[[1]] %>%
    filter(str_detect(X1, "\\d{4}")) %>%
    select(1:2) %>% 
    setNames(c("year", "team"))

coach_data
```

    ## # A tibble: 22 × 2
    ##    year  team    
    ##    <chr> <chr>   
    ##  1 1977  Hawthorn
    ##  2 1978  Hawthorn
    ##  3 1979  Hawthorn
    ##  4 1980  Hawthorn
    ##  5 1981  Carlton 
    ##  6 1982  Carlton 
    ##  7 1983  Carlton 
    ##  8 1984  Carlton 
    ##  9 1985  Carlton 
    ## 10 1986  Fitzroy 
    ## # … with 12 more rows

``` r
  team_count <- coach_data %>% 
    mutate(from = lag(team, default = "None"), 
           to = team,
           year = as.numeric(year),
           flag_same_club = ifelse(from == to, 1, 0),
           flag_gap_year = ifelse(year - lag(year) > 1, 1, 0))

team_count
```

    ## # A tibble: 22 × 6
    ##     year team     from     to       flag_same_club flag_gap_year
    ##    <dbl> <chr>    <chr>    <chr>             <dbl>         <dbl>
    ##  1  1977 Hawthorn None     Hawthorn              0            NA
    ##  2  1978 Hawthorn Hawthorn Hawthorn              1             0
    ##  3  1979 Hawthorn Hawthorn Hawthorn              1             0
    ##  4  1980 Hawthorn Hawthorn Hawthorn              1             0
    ##  5  1981 Carlton  Hawthorn Carlton               0             0
    ##  6  1982 Carlton  Carlton  Carlton               1             0
    ##  7  1983 Carlton  Carlton  Carlton               1             0
    ##  8  1984 Carlton  Carlton  Carlton               1             0
    ##  9  1985 Carlton  Carlton  Carlton               1             0
    ## 10  1986 Fitzroy  Carlton  Fitzroy               0             0
    ## # … with 12 more rows

``` r
dp <- count_coaches_teams("David_Parkin.html")

dp
```

    ## # A tibble: 1 × 4
    ##   to          n link              type                  
    ##   <chr>   <int> <chr>             <chr>                 
    ## 1 Carlton     2 David_Parkin.html return from other club

These examples capture the possibilities.

# Putting it all together

Let’s apply the function to all coaches.

``` r
teams_list <- lapply(coaches$link, count_coaches_teams)

teams_list_df <- teams_list %>% 
  bind_rows() %>% 
  mutate(coach = gsub("(_|\\.html)", " ", link) %>% 
           trimws()) %>% 
  select(coach, returning_to = to, count = n, return_type = type)
```

The full list of coaches who returned to a club, either after a break or
after time coaching another club.

There are 52 instances, involving 49 coaches, returning to 13 clubs.

``` r
teams_list_df %>% 
  arrange(coach) %>% 
  kbl(format = "simple") %>% 
    kable_styling(bootstrap_options = c("striped"))
```

| coach            | returning_to    | count | return_type                     |
|:-----------------|:----------------|------:|:--------------------------------|
| Alan Joyce       | Hawthorn        |     1 | return to same club after break |
| Alec Hall        | Melbourne       |     2 | return from other club          |
| Alex Jesaulenko  | Carlton         |     2 | return from other club          |
| Allan Hopkins    | Footscray       |     1 | return to same club after break |
| Allan Jeans      | Hawthorn        |     1 | return to same club after break |
| Arthur Coghlan   | Geelong         |     1 | return to same club after break |
| Arthur Olliver   | Footscray       |     1 | return to same club after break |
| Bill Findlay     | Footscray       |     2 | return to same club after break |
| Bill Stephen     | Fitzroy         |     2 | return from other club          |
| Bill Stephen     | Fitzroy         |     1 | return to same club after break |
| Billy Strickland | Collingwood     |     1 | return to same club after break |
| Bob Davis        | Geelong         |     1 | return to same club after break |
| Bob McCaskill    | North Melbourne |     1 | return to same club after break |
| Bob Rose         | Collingwood     |     2 | return from other club          |
| Charlie Ricketts | South Melbourne |     1 | return to same club after break |
| Charlie Sutton   | Footscray       |     1 | return to same club after break |
| Darren Crocker   | North Melbourne |     1 | return to same club after break |
| Dave McNamara    | St Kilda        |     1 | return to same club after break |
| David Parkin     | Carlton         |     2 | return from other club          |
| Dick Harris0     | Richmond        |     1 | return to same club after break |
| Don McKenzie1    | Footscray       |     1 | return to same club after break |
| Eric Guy         | St Kilda        |     1 | return to same club after break |
| Frank Hughes1    | Melbourne       |     2 | return to same club after break |
| George Sparrow   | St Kilda        |     2 | return to same club after break |
| Gerald Brosnan   | University      |     1 | return to same club after break |
| Gordon Rattray   | Fitzroy         |     1 | return to same club after break |
| Graham Campbell  | Fitzroy         |     1 | return to same club after break |
| Herbie Matthews0 | South Melbourne |     1 | return to same club after break |
| Horrie Clover    | Carlton         |     1 | return to same club after break |
| Ian Stewart      | South Melbourne |     2 | return from other club          |
| Jack Titus       | Richmond        |     2 | return to same club after break |
| James Hird       | Essendon        |     1 | return to same club after break |
| Jimmy Smith0     | St Kilda        |     2 | return to same club after break |
| John Kennedy0    | Hawthorn        |     2 | return to same club after break |
| John Worrall     | Essendon        |     1 | return to same club after break |
| Johnny Leonard   | South Melbourne |     1 | return to same club after break |
| Keith McKenzie   | Carlton         |     1 | return to same club after break |
| Neil Mann        | Collingwood     |     2 | return to same club after break |
| Norman Clark     | Carlton         |     2 | return from other club          |
| Norman Clark     | Carlton         |     1 | return to same club after break |
| Percy Parratt    | Fitzroy         |     1 | return to same club after break |
| Ray Brew         | Carlton         |     1 | return to same club after break |
| Reg Hickey       | Geelong         |     2 | return to same club after break |
| Ron Barassi0     | Melbourne       |     2 | return from other club          |
| Ron Clegg        | South Melbourne |     1 | return to same club after break |
| Roy Cazaly       | South Melbourne |     1 | return to same club after break |
| Ted Whitten0     | Footscray       |     1 | return to same club after break |
| Tony Jewell      | Richmond        |     2 | return from other club          |
| Vic Belcher      | Fitzroy         |     1 | return to same club after break |
| Vic Belcher      | South Melbourne |     1 | return to same club after break |
| Wally Carter0    | North Melbourne |     2 | return to same club after break |
| Wels Eicke       | St Kilda        |     1 | return to same club after break |
