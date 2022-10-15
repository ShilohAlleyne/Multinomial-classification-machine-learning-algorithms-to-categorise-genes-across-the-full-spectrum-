# Loads Dependencies -----------------------------------------------------------

install.packages("vip")
library(vip)
library(tidyverse)
library(tidymodels)

# Imports data -----------------------------------------------------------------

data <- read.csv("tmp/anno_cluster.csv", row.names=1)

# Counts the group types -------------------------------------------------------

data %>% 
  count(Group, sort = TRUE)

# Pre-prep data ----------------------------------------------------------------

# Split the data into training and testing sets
cluster_split <- data %>%
  initial_split(prop = 0.8,
                strata = Group)

cluster_train <- training(cluster_split)
cluster_test <- testing(cluster_split)

# Creates recipe
cluster_recipe <- recipe(Group ~ ., data = cluster_train) %>% 
  themis::step_smote(Group)

cluster_prep <- prep(cluster_recipe)
juiced <- juice(cluster_prep)

# Checks Group Balance in the training data ------------------------------------

balance <- cluster_train %>% 
  group_by(Group) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(check = - (n / sum(n) * log(n / sum(n))) / log(length(Group)) ) %>% 
  summarise(balance = sum(check)) %>% 
  pull()

  # 1 is balanced 0 is unbalanced

# Builds Models ----------------------------------------------------------------

rf_spec <- rand_forest(mtry = tune(),
                       trees = 1000,
                       min_n = tune()) %>%
  set_engine("ranger") %>%
  set_mode("classification")

# Creates a workflow -----------------------------------------------------------

wf_rf <- workflow() %>%
  add_recipe(cluster_recipe) %>%
  add_model(rf_spec) 

# Tuning RF Hyper-parameters ---------------------------------------------------

doParallel::registerDoParallel() # Parallel processing

cluster_folds <- vfold_cv(cluster_train, v = 10)

# Trains 20 different models with different hyper-parameters
cl_rf_res <- tune_grid(
  wf_rf,
  resamples = cluster_folds,
  grid = 20
)

# Selects models with good mtry and min_n AUC values
cl_rf_grid <- grid_regular(
  mtry(range = c(0, 50)),
  min_n(range = c(5, 30)),
  levels = 5
)

# A more targeted tuning with selected hyper parameters
cl_regular_res <- tune_grid(
  wf_rf,
  resamples = cluster_folds,
  grid = cl_rf_grid
)

# Chooses best model
cl_best_auc <- select_best(cl_regular_res, "roc_auc")

cl_final_rf <- finalize_model(
  rf_spec,
  cl_best_auc
)

# Finalises workflow
cl_final_wf <- workflow() %>%
  add_recipe(cluster_recipe) %>%
  add_model(cl_final_rf)

cl_final_res <- cl_final_wf %>%
  last_fit(cluster_split)


# Visualization ----------------------------------------------------------------

# Plots the AUC of the min_n and mtry of the different models
cl_rf_res %>%
  collect_metrics() %>%
  filter(.metric == "roc_auc") %>%
  select(mean, min_n, mtry) %>%
  pivot_longer(min_n:mtry,
               values_to = "value",
               names_to = "parameter"
  ) %>%
  ggplot(aes(value, mean, color = parameter)) +
  geom_point(show.legend = FALSE) +
  facet_wrap(~parameter, scales = "free_x") +
  labs(x = NULL, y = "AUC")

# AUC by mtry of each different min value
cl_regular_res %>%
  collect_metrics() %>%
  filter(.metric == "roc_auc") %>%
  mutate(min_n = factor(min_n)) %>%
  ggplot(aes(mtry, mean, color = min_n)) +
  geom_line(alpha = 0.5, size = 1.5) +
  geom_point() +
  labs(y = "AUC")

# Plotting variable importance
cl_final_rf %>%
  set_engine("ranger", importance = "permutation") %>%
  fit(Group ~ .,
      data = juice(cluster_prep)) %>%
  vip(geom = "point")

# Results ----------------------------------------------------------------------

# Gets the metrics for the tuned random forest model predicting cluster groups
cl_final_res %>%
  collect_metrics()

# Confusion matrix for the tuned random forest model predicting cluster groups
cl_final_res %>%
  collect_predictions() %>%
  conf_mat(Group, .pred_class)

# Cross-validation -------------------------------------------------------------

# Ten fold cross validation using the finalized cluster model
cl_cv <- cl_final_wf %>%
  fit_resamples(cluster_folds,
                metrics = metric_set(roc_auc, 
                                     sensitivity, 
                                     specificity, 
                                     accuracy),
                control = control_resamples(save_pred = TRUE)
  )

cl_cv %>% collect_metrics()




