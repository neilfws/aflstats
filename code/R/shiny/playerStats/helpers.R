plotPlayerStats <- function(href) {
  u <- paste("http://afltables.com/afl/stats/", href, sep = "")
  player <- readHTMLTable(u, header = TRUE, stringsAsFactors = FALSE)
  player <- player[[2]]
  player[, 3:27] <- sapply(player[, 3:27], function(x) as.numeric(x))
  player <- melt(player[, c(1:2, 4, 6:27)])
  avg <- aggregate(value ~ variable, player, mean)
  gg <- ggplot(player) + geom_bar(aes(Year, value, fill = Team), stat = "identity") + facet_wrap( ~ variable, scales = "free") + theme_bw() + theme(axis.text.x = element_text(angle = 90)) + labs(title = href, y = "average/game; line = career average") + geom_hline(aes(yintercept = value), data = avg)
  return(gg)
}