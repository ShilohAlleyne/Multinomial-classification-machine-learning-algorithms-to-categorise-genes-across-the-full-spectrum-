
install.packages("ggrepel")
library(ggrepel)

# Clusters the subset
d4 <- dist(rpkm_subset, method = "euclidean") # distance matrix
fit5 <- hclust(d4, method="ward.D") 
plot(fit5)
rkpm_groups <- cutree(fit5, k=5) # cut tree into 5 clusters
rect.hclust(fit5, k=5, border= 2:6)


# Shows the number of each group
barplot(table(subset_groups_df$rkpm_groups),
        xlab = "Group",
        ylab = "Group size",
        main = "Size of each Group",
        col=c("lightblue", "mistyrose", "lightcyan", 
              "lavender", "cornsilk"))

# Plots the group accuracy 

# Doughnut Chart of fusil group CL
CL <- subset(rpkm_group_size, FUSIL == "CL")

# Makes the bars
CL$fraction = CL$size / sum(CL$size)
CL$ymax = cumsum(CL$fraction)
CL$ymin = c(0, head(CL$ymax, n=-1))
# Makes the lables
CL$labelPosition <- (CL$ymax + CL$ymin) / 2
CL$label <- paste0("Group: ", CL$Group, "\n Number: ", CL$size)


ggplot(CL, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=as.factor(Group))) +
  geom_rect() +
  geom_label_repel(x=2, aes(y=labelPosition, label=label), size=6,) +
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("FUSIL: CL")


# Doughnut Chart of the fusil Group DL
DL <- subset(rpkm_group_size, FUSIL == "DL")

# Makes the bars
DL$fraction = DL$size / sum(DL$size)
DL$ymax = cumsum(DL$fraction)
DL$ymin = c(0, head(DL$ymax, n=-1))
# Makes the lables
DL$labelPosition <- (DL$ymax + DL$ymin) / 2
DL$label <- paste0("Group: ", DL$Group, "\n Number: ", DL$size)


ggplot(DL, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=as.factor(Group))) +
  geom_rect() +
  geom_label_repel(x=2, aes(y=labelPosition, label=label), size=6,) +
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("FUSIL: DL")

# Doughnut Chart of the fusil Group SV
SV <- subset(rpkm_group_size, FUSIL == "SV")

# Makes the bars
SV$fraction = SV$size / sum(SV$size)
SV$ymax = cumsum(SV$fraction)
SV$ymin = c(0, head(SV$ymax, n=-1))
# Makes the lables
SV$labelPosition <- (SV$ymax + SV$ymin) / 2
SV$label <- paste0("Group: ", SV$Group, "\n Number: ", SV$size)


ggplot(SV, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=as.factor(Group))) +
  geom_rect() +
  geom_label_repel(x=2, aes(y=labelPosition, label=label), size=6,) +
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("FUSIL: SV")


# Doughnut Chart of the fusil Group VN
VN <- subset(rpkm_group_size, FUSIL == "VN")

# Makes the bars
VN$fraction = VN$size / sum(VN$size)
VN$ymax = cumsum(VN$fraction)
VN$ymin = c(0, head(VN$ymax, n=-1))
# Makes the lables
VN$labelPosition <- (VN$ymax + VN$ymin) / 2
VN$label <- paste0("Group: ", VN$Group, "\n Number: ", VN$size)


ggplot(VN, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=as.factor(Group))) +
  geom_rect() +
  geom_label_repel(x=2, aes(y=labelPosition, label=label), size=6,) +
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("FUSIL: VN")


# Doughnut Chart of the fusil Group VP
VP <- subset(rpkm_group_size, FUSIL == "VP")

# Makes the bars
VP$fraction = VP$size / sum(VP$size)
VP$ymax = cumsum(VP$fraction)
VP$ymin = c(0, head(VP$ymax, n=-1))
# Makes the lables
VP$labelPosition <- (VP$ymax + VP$ymin) / 2
VP$label <- paste0("Group: ", VP$Group, "\n Number: ", VP$size)


ggplot(VP, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=as.factor(Group))) +
  geom_rect() +
  geom_label_repel(x=2, aes(y=labelPosition, label=label), size=6,) +
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("FUSIL: VP")
