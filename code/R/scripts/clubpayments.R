library(reshape2)
library(ggplot2)
library(RColorBrewer)
library(scales)

options(scipen = 10000)
setwd("~/Dropbox/projects/github_projects/aflstats")

# read and fix up the data
club_payments_2013 <- read.delim("data/club_payments_2013.tsv", header=FALSE, dec=",")
colnames(club_payments_2013) <- c("club", "base", "future", "other", "total")
club_payments_2013$base   <- gsub(",", "", club_payments_2013$base)
club_payments_2013$future <- gsub(",", "", club_payments_2013$future)
club_payments_2013$other  <- gsub(",", "", club_payments_2013$other)
club_payments_2013$total  <- gsub(",", "", club_payments_2013$total)
club_payments_2013$base   <- as.numeric(club_payments_2013$base)
club_payments_2013$future <- as.numeric(club_payments_2013$future)
club_payments_2013$other  <- as.numeric(club_payments_2013$other)
club_payments_2013$total  <- as.numeric(club_payments_2013$total)

# plot sorted by total
cp.total <- club_payments_2013[order(club_payments_2013$total, decreasing = T),]
cp.total$club <- factor(cp.total$club, levels = cp.total$club)
cptotal.melt <- melt(cp.total)
png(file = "output/payments2013total.png", width = 800, height = 760)
ggplot(subset(cptotal.melt, variable != "total"), aes(club, value, fill = variable)) + 
  geom_bar(stat = "identity") + theme_bw() + scale_fill_brewer(palette = "Reds") + 
  labs(title = "Club payments 2013 sorted by \"total\"") + coord_flip() + 
  geom_hline(y = median(club_payments_2013$total))
dev.off()

# plot sorted by future
cp.future <- club_payments_2013[order(club_payments_2013$future, decreasing = T),]
cp.future$club <- factor(cp.future$club, levels = cp.future$club)
cpfuture.melt <- melt(cp.future)
png(file = "output/payments2013future.png", width = 800, height = 760)
ggplot(subset(cpfuture.melt, variable != "total"), aes(club, value, fill = variable)) + 
  geom_bar(stat = "identity") + theme_bw() + scale_fill_brewer(palette = "Reds") + 
  labs(title = "Club payments 2013 sorted by \"future\"") + coord_flip() + 
  geom_hline(y = median(club_payments_2013$total))
dev.off()

# plot sorted by other
cp.other <- club_payments_2013[order(club_payments_2013$other, decreasing = T),]
cp.other$club <- factor(cp.other$club, levels = cp.other$club)
cpother.melt <- melt(cp.other)
png(file = "output/payments2013other.png", width = 800, height = 760)
ggplot(subset(cpother.melt, variable != "total"), aes(club, value, fill = variable)) + 
  geom_bar(stat = "identity") + theme_bw() + scale_fill_brewer(palette = "Reds") + 
  labs(title = "Club payments 2013 sorted by \"other\"") + coord_flip() + 
  geom_hline(y = median(club_payments_2013$total))
dev.off()

