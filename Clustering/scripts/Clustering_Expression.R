
install.packages("pvclust")
library(pvclust)

install.packages("fastDummies")
library(fastDummies)

install.packages("dplyr")
library(dplyr)

install.packages("dendextend")
libarary(dendexte)

install.packages("readr")
library(readr)

# import gene expression data
test_data <- read_delim("Human_rpkm.txt", delim = " ", col_names = TRUE)


# Plots a cluster of the test dataset
d <- dist(test_data, method = "euclidean") # distance matrix
fit2 <- hclust(d, method="ward.D") 
plot(fit2)
groups <- cutree(fit2, k=5) # cut tree into 5 clusters
rect.hclust(fit2, k=5, border= 2:6) 

# Plots a cluster of the test data set without FUSIL group as a factor
d2 <- dist(test_cluster2, method = "euclidean") # distance matrix
fit3 <- hclust(d2, method="ward.D") 
plot(fit3)
groups2 <- cutree(fit3, k=5) # cut tree into 5 clusters
rect.hclust(fit3, k=5, border= 2:6) 

# Makes a dataframe from the group
test_groups <- data.frame(groups)
test_groups2 <- data.frame(groups2)

# outputs a csv for each group
write.csv(test_groups2,
          "C:\\Users\\yido6\\Documents\\Uni\\Level 7\\Research Project\\fusil-ml-main\\Clustering\\test_groups2.csv", 
          row.names = TRUE)

write.csv(test_data,
          "C:\\Users\\yido6\\Documents\\Uni\\Level 7\\Research Project\\fusil-ml-main\\Clustering\\test_data.csv", 
          row.names = TRUE)


# Plots the group accuracy

# Doughnut Chart of fusil group -
group1 <- subset(group_size2, FUSIL == "-")

# Makes the bar
group1$fraction = group1$size / sum(group1$size)
group1$ymax = cumsum(group1$fraction)
group1$ymin = c(0, head(group1$ymax, n=-1))
# Makes the labels
group1$labelPosition <- (group1$ymax + group1$ymin) / 2
group1$label <- paste0("Group: ", group1$Group, "\n Number: ", group1$size)


ggplot(group1, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=as.factor(Group))) +
  geom_rect() +
  geom_label( x=2, aes(y=labelPosition, label=label), size=6) +
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("FUSIL: -")


# Doughnut Chart of fusil group CL
group2 <- subset(group_size2, FUSIL == "CL")

# Makes the bars
group2$fraction = group2$size / sum(group2$size)
group2$ymax = cumsum(group2$fraction)
group2$ymin = c(0, head(group2$ymax, n=-1))
# Makes the lables
group2$labelPosition <- (group2$ymax + group2$ymin) / 2
group2$label <- paste0("Group: ", group2$Group, "\n Number: ", group2$size)


ggplot(group2, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=as.factor(Group))) +
  geom_rect() +
  geom_label( x=2, aes(y=labelPosition, label=label), size=6) +
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("FUSIL: CL")


# Doughnut Chart of the fusil group DL
group3 <- subset(group_size2, FUSIL == "DL")

# Makes the Bars
group3$fraction = group3$size / sum(group3$size)
group3$ymax = cumsum(group3$fraction)
group3$ymin = c(0, head(group3$ymax, n=-1))
# Makes the labels
group3$labelPosition <- (group3$ymax + group3$ymin) / 2
group3$label <- paste0("Group: ", group3$Group, "\n Number: ", group3$size)


ggplot(group3, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=as.factor(Group))) +
  geom_rect() +
  geom_label( x=2, aes(y=labelPosition, label=label), size=6) +
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("FUSIL: DL")


# Doughnut Chart of the fusil group VN
group4 <- subset(group_size2, FUSIL == "VN")

# Makes the bars
group4$fraction = group4$size / sum(group4$size)
group4$ymax = cumsum(group4$fraction)
group4$ymin = c(0, head(group4$ymax, n=-1))
# Makes the labels
group4$labelPosition <- (group4$ymax + group4$ymin) / 2
group4$label <- paste0("Group: ", group4$Group, "\n Number: ", group4$size)


ggplot(group4, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=as.factor(Group))) +
  geom_rect() +
  geom_label( x=2, aes(y=labelPosition, label=label), size=6) +
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("FUSIL: VN")


# Doughnut Chart of the fusil group VP
group5 <- subset(group_size2, FUSIL == "VP")

# Makes the bars
group5$fraction = group5$size / sum(group5$size)
group5$ymax = cumsum(group5$fraction)
group5$ymin = c(0, head(group5$ymax, n=-1))
# Makes the labels
group5$labelPosition <- (group5$ymax + group5$ymin) / 2
group5$label <- paste0("Group: ", group5$Group, "\n Number: ", group5$size)


ggplot(group5, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=as.factor(Group))) +
  geom_rect() +
  geom_label( x=2, aes(y=labelPosition, label=label), size=6) +
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("FUSIL: VP")


# Plots a doughnut graph of the SV group
group6 <- subset(group_size2, FUSIL == "SV")

# Makes the bars
group6$fraction = group6$size / sum(group6$size)
group6$ymax = cumsum(group6$fraction)
group6$ymin = c(0, head(group6$ymax, n=-1))
# Makes the labels
group6$labelPosition <- (group6$ymax + group6$ymin) / 2
group6$label <- paste0("Group: ", group6$Group, "\n Number: ", group6$size)


ggplot(group6, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=as.factor(Group))) +
  geom_rect() +
  geom_label( x=2, aes(y=labelPosition, label=label), size=6) +
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("FUSIL: SV")
