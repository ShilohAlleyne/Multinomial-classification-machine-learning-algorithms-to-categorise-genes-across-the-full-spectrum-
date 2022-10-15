
install.packages("missForest")
library(missForest)

library(tidyverse)

# Tidying data------------------------------------------------------------------

# removes row names
anno2 <- anno[,-1]
rownames(anno2) <- anno[,1]

# Imputation--------------------------------------------------------------------

# Using missforest 
anno.imp <- missForest(anno2)

write.csv(anno.imp[["ximp"]], "output data\\anno_imp.csv")
