
# Loads Dependencies -----------------------------------------------------------

install.packages("bestNormalize")
install.packages("ggforce")
install.packages("learntidymodels")
install.packages("fastICA")
install.packages("embed")
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("mixOmics")

library(corrplot)
library(tidymodels)
library(bestNormalize)
library(patchwork)
library(ggforce)
library(learntidymodels)
library(fastICA)
library(embed)
library(mixOmics)

# Exploratory Plots ------------------------------------------------------------

tmwr_cols <- colorRampPalette(c("#91CBD765", "#CA225E"))
trainingdata %>% 
  select(-fusil) %>% 
  cor() %>% 
  corrplot(col = tmwr_cols(200), tl.col = "black", method = "ellipse")

# Pre-prep ---------------------------------------------------------------------

anno_val <- validation_split(DL.CLSV.VNVP, strata = fusil, prop = 4/5)

anno_rec <- recipe(fusil ~ ., data = analysis(anno_val$splits[[1]])) %>%
  step_zv(all_numeric_predictors()) %>%
  step_orderNorm(all_numeric_predictors()) %>% 
  step_normalize(all_numeric_predictors())

anno_rec_trained <- prep(anno_rec)

# Baking the recipe ------------------------------------------------------------

anno_validation <- anno_val$splits %>% pluck(1) %>% assessment()
anno_val_processed <- bake(anno_rec_trained, new_data = anno_validation)

# Visualization ----------------------------------------------------------------

# Estimates the transformation and plots
# the resulting data in a scatter plot matrix
plot_validation_results <- function(
  recipe, dat = assessment(anno_val$splits[[1]])) {
  recipe %>%
    # Estimate any additional steps
    prep() %>%
    # Process the data (the validation set by default)
    bake(new_data = dat) %>%
    # Create the scatter plot matrix
    ggplot(aes(x = .panel_x, y = .panel_y, color = fusil, fill = fusil)) +
    geom_point(alpha = 0.4, size = 0.5) +
    geom_autodensity(alpha = .3) +
    facet_matrix(vars(-fusil), layer.diag = 2) + 
    scale_color_brewer(palette = "Dark2") + 
    scale_fill_brewer(palette = "Dark2")
}

# PCA
anno_rec_trained %>%
  step_pca(all_numeric_predictors(), num_comp = 4) %>%
  plot_validation_results() + 
  ggtitle("Principal Component Analysis")

# PLS
anno_rec_trained %>%
  step_pls(all_numeric_predictors(), outcome = "fusil", num_comp = 4) %>%
  plot_validation_results() + 
  ggtitle("Partial Least Squares")

# ICA
anno_rec_trained %>%
  step_ica(all_numeric_predictors(), num_comp = 4) %>%
  plot_validation_results() + 
  ggtitle("Independent Component Analysis")

# UMAP
anno_rec_trained %>%
  step_umap(all_numeric_predictors(), num_comp = 4) %>%
  plot_validation_results() +
  ggtitle("UMAP")
