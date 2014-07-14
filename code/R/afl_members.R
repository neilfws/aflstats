library(ggplot2)
library(XML)
library(plyr)
library(directlabels)
library(RColorBrewer)

setwd("~/Dropbox/projects/aflstats/")
u <- "http://www.aflmembershipnumbers.com/index.html"
doc <- htmlTreeParse(u, useInternalNodes = TRUE)
teams <- data.frame(team = xpathSApply(doc, "//a[@href]", xmlValue),
                    link = xpathSApply(doc, "//a[@href]", xmlAttrs))
teams <- teams[4:21,]
baseurl <- "http://www.aflmembershipnumbers.com/"
members <- list()
for(i in 1:nrow(teams)) {
    t <- readHTMLTable(paste(baseurl, teams$link[i], sep = ""))
    members[[as.character(teams$team[i])]] <- t[[1]]
}

members.df <- ldply(members)
colnames(members.df)[1] <- "Team"
colnames(members.df)[3] <- "Members"
members.df$Members <- as.character(members.df$Members)
members.df$Members <- as.numeric(gsub(",", "", members.df$Members))
members.df[123, 3] <- 40000
members.df$Year <- as.numeric(as.character(members.df$Year))

# plots
pal <- colorRampPalette(brewer.pal(8, "Dark2"))(18)

png(file = "output/afl_membership.png", width = 800, height = 760)
ggplot(members.df, aes(x = Year, y = Members, col = Team)) + 
  geom_line() + scale_color_manual(values = pal) + 
  theme_bw() + geom_dl(aes(label = Team), list("last.points", cex = 0.6)) + 
  theme(legend.position = "none") + coord_cartesian(xlim = c(1995, 2020))
dev.off()

png(file = "output/afl_membership_2013.png", width = 800, height = 760)
m.2013 <- subset(members.df, Year == 2013)
m.2013 <- m.2013[order(m.2013$Members, decreasing = TRUE),]
m.2013$Team <- factor(m.2013$Team, levels = m.2013$Team)
ggplot(m.2013, aes(Team, Members)) + geom_bar(stat = "identity", fill = "skyblue3") + 
  theme_bw() + theme(axis.text.x = element_text(angle = 90)) + 
  geom_hline(y = median(m.2013$Members)) + labs(title = "2013 Membership Numbers")
dev.off()