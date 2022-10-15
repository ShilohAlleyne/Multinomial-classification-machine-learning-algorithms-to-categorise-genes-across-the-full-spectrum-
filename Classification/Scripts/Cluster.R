

anno <- read.csv("~/Uni/Level 7/Research Project/fusil-ml-main/Clustering/tmp/human_rpkm_subset.csv", row.names=1)

# Plots a K wise cluster 
d <- dist(anno, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward.D")
plot(fit)

groups <- cutree(fit, k=5) # cut tree into 5 clusters
rect.hclust(fit, k=5, border= 2:6)

# Makes group df
anno_groups <- data.frame(groups)

# Outputs group df
write.csv(anno_groups,
          "tmp\\anno_groups.csv", 
          row.names = TRUE)
