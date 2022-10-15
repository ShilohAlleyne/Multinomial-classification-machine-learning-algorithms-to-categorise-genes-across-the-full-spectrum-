
# Loads Dependencies -----------------------------------------------------------

install.packages("kknn")
install.packages("xgboost")
install.packages("glmnet")
install.packages("stacks")
install.packages("discrim")
install.packages("mda")
install.packages("earth")
install.packages("baguette")
install.packages("parsnip")
install.packages("klaR")

library(parsnip)
library(vip)
library(tidyverse)
library(tidymodels)
library(kknn)
library(xgboost)
library(glmnet)
library(stacks)
library(doParallel)
library(corrplot)
library(bestNormalize)
library(patchwork)
library(ggforce)
library(fastICA)
library(embed)
library(kernlab)
library(discrim)
library(mda)
library(earth)
library(klaR)


# Imports data -----------------------------------------------------------------

# data <- simple2

# Counts the fusil types -------------------------------------------------------
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
data %>% 
  count(fusil, sort = TRUE)

juiced %>%
  count(fusil, sort = TRUE)

# Plots class distribution 
barplot(prop.table(table(data$fusil)),
        col = rainbow(5),
        main = "Class Distribution")

# Pre-prep data ----------------------------------------------------------------

# Split the data into training and testing sets
data_split <- data %>%
  initial_split(prop = 0.8,
                strata = fusil)

trainingdata <- training(data_split)
testingdata <- testing(data_split)

# Creates recipe
recipe <- recipe(fusil ~ ., data = trainingdata) %>% 
  step_zv(all_numeric_predictors()) %>%
  step_normalize(all_numeric_predictors())

prep <- prep(recipe)
juiced <- juice(prep)

# Checks Group Balance in the training data ------------------------------------

balance <- trainingdata %>% 
  group_by(fusil) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(check = - (n / sum(n) * log(n / sum(n))) / log(length(fusil)) ) %>% 
  summarise(balance = sum(check)) %>% 
  pull()

# 1 is balanced 0 is unbalanced

# Builds Models ----------------------------------------------------------------

# Random forest
rf_spec <- rand_forest(
  mtry = tune(),
  trees = 1000,
  min_n = tune()) %>%
  set_engine("ranger") %>%
  set_mode("classification")

# Multinomial Logistic Regression with Regularization
glm_spec <- multinom_reg(
  penalty = tune(),
  mixture = 1) %>% 
  set_engine("glmnet")

# K Nearest Neighbors (knn) 
knn_spec <- nearest_neighbor(
  neighbors = tune(), 
  weight_func = tune(), 
  dist_power = tune()) %>% 
  set_engine("kknn") %>% 
  set_mode("classification")

# Boosted Trees (boost) 
boost_spec <- boost_tree(
  trees = tune(), 
  mtry = tune(),
  min_n = tune(),
  learn_rate = tune(),
  tree_depth = tune()) %>% 
  set_engine("xgboost") %>% 
  set_mode("classification")

# Support Vector Machine
svm_spec <- svm_rbf(
  cost = tune(), 
  rbf_sigma = tune()) %>%
  set_engine("kernlab") %>%
  set_mode("classification")

# Flexible discriminant analysis
discrim_spec <- discrim_flexible(
  num_terms = tune(),
  prod_degree = tune(),
  prune_method = tune()) %>%
  set_engine("earth") %>%
  set_mode("classification")

# Single Layer Neural Network
nnet_spec <- mlp(
  hidden_units = tune(), 
  penalty = tune(), 
  epochs = tune()) %>%
  set_mode("classification") %>%
  set_engine("nnet")

# Naive Bayes model
naive_spec <-naive_Bayes(
  smoothness = tune(), 
  Laplace = tune()) %>% 
  set_engine("klaR") 

# Creates Workflows ------------------------------------------------------------

rf_wf <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(rf_spec) 

glm_wf <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(glm_spec)

knn_wf <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(knn_spec)

boost_wf <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(boost_spec)

svm_wf <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(svm_spec)

discrim_wf <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(discrim_spec)

nnet_wf <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(nnet_spec)

naive_wf <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(naive_spec)

# Extract Tuning parameters ----------------------------------------------------

# Extract the parameters that require tuning to pass into the tuning grid

trained_data <- recipe %>% prep() %>% bake(new_data = NULL)

rf_param <- hardhat::extract_parameter_set_dials(rf_wf) %>% 
  finalize(trained_data)
knn_param <- hardhat::extract_parameter_set_dials(knn_wf) 
lasso_param <- hardhat::extract_parameter_set_dials(glm_wf)
boost_param <- hardhat::extract_parameter_set_dials(boost_wf) %>%
  finalize(trained_data)
svm_param <- hardhat::extract_parameter_set_dials(svm_wf)
discrim_param <- hardhat::extract_parameter_set_dials(discrim_wf)
nnet_param <- hardhat::extract_parameter_set_dials(nnet_wf)
naive_param <- hardhat::extract_parameter_set_dials(naive_wf)


# Tuning Hyper-parameters ------------------------------------------------------

folds <- vfold_cv(data = trainingdata, v = 10, strata = "fusil")
ctrl_res <- control_stack_resamples()

# select the number of cores to parallelize the calcs across
cl <- makePSOCKcluster(6)
registerDoParallel(cl)

rf_tune <- rf_wf %>%
  tune_grid(
    folds,
    grid = 30,
    param_info = rf_param,
    control = control_grid(
      verbose = TRUE,
      allow_par = TRUE,
      save_pred = TRUE,
      save_workflow = TRUE,
      parallel_over = "resamples"
    )
  )

knn_tune <- knn_wf %>%
  tune_grid(
    folds,
    grid = 30,
    param_info = knn_param,
    control = control_grid(
      verbose = TRUE,
      allow_par = TRUE,
      save_pred = TRUE,
      save_workflow = TRUE,
      parallel_over = "resamples"
    )
  )

glm_tune <- glm_wf %>%
  tune_grid(
    folds,
    grid = 30,
    param_info = lasso_param,
    control = control_grid(
      verbose = TRUE,
      allow_par = TRUE,
      save_pred = TRUE,
      save_workflow = TRUE,
      parallel_over = "resamples"
    )
  )

boost_tune <- boost_wf %>%
  tune_grid(
    folds,
    grid = 30,
    param_info = boost_param,
    control = control_grid(
      verbose = TRUE,
      allow_par = TRUE,
      save_pred = TRUE,
      save_workflow = TRUE,
      parallel_over = "resamples"
    )
  )

svm_tune <- svm_wf %>%
  tune_grid(
    folds, 
    grid = 30,
    param_info = svm_param,
    control = control_grid(
      verbose = TRUE,
      allow_par = TRUE,
      save_pred = TRUE,
      save_workflow = TRUE,
      parallel_over = "resamples"
    )
  )

discrim_tune <- discrim_wf %>%
  tune_grid(
    folds,
    grid = 30,
    param_info = discrim_param,
    control = control_grid(
      verbose = TRUE,
      allow_par = TRUE,
      save_pred = TRUE,
      save_workflow = TRUE,
      parallel_over = "resamples"
    )
  )

nnet_tune <- nnet_wf %>%
  tune_grid(
    folds,
    grid = 30,
    param_info = nnet_param,
    control = control_grid(
      verbose = TRUE,
      allow_par = TRUE,
      save_pred = TRUE,
      save_workflow = TRUE,
      parallel_over = "resamples"
    )
  )

naive_tune <- naive_wf %>%
  tune_grid(
    folds,
    grid = 30,
    param_info = naive_param,
    control = control_grid(
      verbose = TRUE,
      allow_par = TRUE,
      save_pred = TRUE,
      save_workflow = TRUE,
      parallel_over = "resamples"
    )
  )


stopCluster(cl)

# Fits the Tuned Models---------------------------------------------------------

# retain the values of the hyper-parameters that optimize accuracy
# and pass them on to the workflow

# Final Random Forests Workflow
rf_best_accuracy <- select_best(rf_tune, metric = "accuracy")
rf_final_model <- finalize_model(
  rf_spec,
  rf_best_accuracy
)
rf_wf_final <- finalize_workflow(rf_wf, rf_best_accuracy)
rf_final_fit <- last_fit(rf_wf_final, data_split)


# Final KNN
knn_best_accuracy <- select_best(knn_tune, metric = "accuracy")
knn_final_model <- finalize_model(
  knn_spec,
  knn_best_accuracy
)
knn_wf_final <- finalize_workflow(knn_wf, knn_best_accuracy)
knn_final_fit <- last_fit(knn_wf_final, data_split) 


# glm
glm_best_accuracy <- select_best(glm_tune, metric = "accuracy")
glm_final_model <- finalize_model(
  glm_spec,
  glm_best_accuracy
)
glm_wf_final <- finalize_workflow(glm_wf, glm_best_accuracy)
glm_final_fit <- last_fit(glm_wf_final, data_split)


# Boosted Trees
boost_best_accuracy <- select_best(boost_tune, metric = "accuracy")
boost_final_model <- finalize_model(
  boost_spec,
  boost_best_accuracy
)
boost_wf_final <- finalize_workflow(boost_wf, boost_best_accuracy)
boost_final_fit <- last_fit(boost_wf_final, data_split)


# SVM
svm_best_accuracy <- select_best(svm_tune, metric = "accuracy")
svm_final_model <- finalize_model(
  svm_spec,
  svm_best_accuracy
)
svm_wf_final <- finalize_workflow(svm_wf, svm_best_accuracy)
svm_final_fit <- last_fit(svm_wf_final, data_split)


# Discrim
discrim_best_accuracy <- select_best(discrim_tune, metric = "accuracy")
discrim_final_model <- finalize_model(
  discrim_spec,
  discrim_best_accuracy
)
discrim_wf_final <- finalize_workflow(discrim_wf, discrim_best_accuracy)
discrim_final_fit <- last_fit(discrim_wf_final, data_split)

# Nnet
nnet_best_accuracy <- select_best(nnet_tune, metric = "accuracy")
nnet_final_model <- finalize_model(
  nnet_spec,
  nnet_best_accuracy
)
nnet_wf_final <- finalize_workflow(nnet_wf, nnet_best_accuracy)
nnet_final_fit <- last_fit(nnet_wf_final, data_split)

# Naive Bayes
naive_best_accuracy <- select_best(naive_tune, metric = "accuracy")
naive_final_model <- finalize_model(
  naive_spec,
  naive_best_accuracy
)
naive_wf_final <- finalize_workflow(naive_wf, naive_best_accuracy)
naive_final_fit <- last_fit(naive_wf_final, data_split)

# Model Stack ------------------------------------------------------------------

cl <- makePSOCKcluster(6)
registerDoParallel(cl)

model_stack <- stacks() %>% 
  add_candidates(rf_tune) %>% 
  add_candidates(knn_tune) %>%
  add_candidates(glm_tune) %>%
  add_candidates(boost_tune) %>% 
  add_candidates(discrim_tune) %>%
  add_candidates(nnet_tune) %>%
  add_candidates(svm_tune) %>%
  add_candidates(naive_tune) %>%
  blend_predictions(metric = metric_set(accuracy))

model_stack_fit <- model_stack %>% fit_members()

stack_pred_test <- testingdata %>% 
  bind_cols(., predict(model_stack_fit, new_data = ., type = "class"))

model_stack2 <- stacks() %>%
  add_candidates(nnet_tune) %>%
  add_candidates(svm_tune) %>%
  blend_predictions(metric = metric_set(accuracy))

# Visualization ----------------------------------------------------------------

# Plots the effects of Hyper-perameters on accuracy

autoplot(rf_tune, metric = "accuracy") # Random Forest
autoplot(knn_tune, metric = "accuracy") # K Nearest Neighbors
autoplot(glm_tune, metric = "accuracy") # Multinomial Logistic Regression
autoplot(boost_tune, metric = "accuracy") # Boosted Trees
autoplot(svm_tune, metric = "accuracy") # SVM 
autoplot(discrim_tune, metric = "accuracy") # Flexible discriminant analysis
autoplot(nnet_tune, metric = "accuracy") # Single Layer Neural Network
autoplot(naive_tune, metric = "accuracy") # Naive Bayes

# Plots Variable Importance

# Random Forests
rf_final_model %>%
  set_engine("ranger", importance = "permutation") %>%
  fit(fusil ~ .,
      data = juice(prep)) %>%
  vip(geom = "point")

# Boosted Trees
boost_final_model %>%
  set_engine("xgboost", importance = "permutation") %>%
  fit(fusil ~ .,
      data = juice(prep)) %>%
  vip(geom = "point")


# Model Stack
autoplot(model_stack, type = "members")
autoplot(model_stack, type = "weights")

# Results ----------------------------------------------------------------------

# Model Tuning Results Accuracy 
best_oos <- bind_rows(
  rf_final_fit %>% mutate(model = "Random Forest"), 
  knn_final_fit %>% mutate(model = "K-NN"), 
  glm_final_fit %>% mutate(model = "Glm LogReg"), 
  boost_final_fit %>% mutate(model = "Boosted Trees"),
  svm_final_fit %>% mutate(model = "SVM"),
  discrim_final_fit %>% mutate(model = "Flexible Discriminant Analysis"),
  nnet_final_fit %>% mutate(model = "Single Layer Nueral Network"),
  naive_final_fit %>% mutate(model = "Naive Bayes")
) %>% 
  select(model, .metrics) %>% 
  unnest(cols = .metrics) %>% 
  filter(.metric == "accuracy") %>% 
  arrange(desc(.estimate))

best_oos %>% knitr::kable()

# Model Tuning Results AUC 
best_AUC <- bind_rows(
  rf_final_fit %>% mutate(model = "Random Forest"), 
  knn_final_fit %>% mutate(model = "K-NN"), 
  glm_final_fit %>% mutate(model = "Glm LogReg"), 
  boost_final_fit %>% mutate(model = "Boosted Trees"),
  svm_final_fit %>% mutate(model = "SVM"),
  discrim_final_fit %>% mutate(model = "Flexible Discriminant Analysis"),
  nnet_final_fit %>% mutate(model = "Single Layer Nueral Network"),
  naive_final_fit %>% mutate(model = "Naive Bayes")
) %>% 
  select(model, .metrics) %>% 
  unnest(cols = .metrics) %>% 
  filter(.metric == "roc_auc") %>% 
  arrange(desc(.estimate))

best_AUC %>% knitr::kable()

# Model Tuning Results AUC 
best_spec <- bind_rows(
  rf_final_fit %>% mutate(model = "Random Forest"), 
  knn_final_fit %>% mutate(model = "K-NN"), 
  glm_final_fit %>% mutate(model = "Glm LogReg"), 
  boost_final_fit %>% mutate(model = "Boosted Trees"),
  svm_final_fit %>% mutate(model = "SVM"),
) %>% 
  select(model, .metrics) %>% 
  unnest(cols = .metrics) %>% 
  filter(.metric == "specificity") %>% 
  arrange(desc(.estimate)) 

best_spec %>% knitr::kable()

# Model Stack Results

# Accuracy
stack_pred_test %>% 
  accuracy(factor(fusil), .pred_class) %>% 
  knitr::kable()

# Specificity
stack_pred_test %>% 
  spec(factor(fusil), .pred_class) %>% 
  knitr::kable()

freq <- stack_pred_test %>% 
  group_by(.pred_class) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

stack_pred_test %>%
  roc_auc(factor(fusil), .pred_class)

# Confusion Matrices -----------------------------------------------------------

# RF
results_rf <- testingdata %>%
  bind_cols(predict(rf_wf_final %>%
                      fit(data = trainingdata), testingdata) %>%
              rename(.pred_rf = .pred_class)) %>%
  conf_mat(truth = fusil, estimate = .pred_rf)

results_rf[["table"]] %>% knitr::kable()

# Knn
results_knn <- testingdata %>%
  bind_cols(predict(knn_wf_final %>%
                      fit(data = trainingdata), testingdata) %>%
              rename(.pred_knn = .pred_class)) %>%
  conf_mat(truth = fusil, estimate = .pred_knn)

results_knn[["table"]] %>% knitr::kable()

# Logistic Regression
results_glm <- testingdata %>%
  bind_cols(predict(glm_wf_final %>%
                      fit(data = trainingdata), testingdata) %>%
              rename(.pred_glm = .pred_class)) %>%
  conf_mat(truth = fusil, estimate = .pred_glm)

results_glm[["table"]] %>% knitr::kable()

# Boosted Trees
results_boost <- testingdata %>%
  bind_cols(predict(boost_wf_final %>%
                      fit(data = trainingdata), testingdata) %>%
              rename(.pred_boost = .pred_class)) %>%
  conf_mat(truth = fusil, estimate = .pred_boost)

results_boost[["table"]] %>% knitr::kable()

# SVM
results_svm <- testingdata %>%
  bind_cols(predict(svm_wf_final %>%
                      fit(data = trainingdata), testingdata) %>%
              rename(.pred_svm = .pred_class)) %>%
  conf_mat(truth = fusil, estimate = .pred_avm)

results_svm[["table"]] %>% knitr::kable()

# Naive Bayes
results_naive <- testingdata %>%
  bind_cols(predict(naive_wf_final %>%
                      fit(data = trainingdata), testingdata) %>%
              rename(.pred_naive = .pred_class)) %>%
  conf_mat(truth = fusil, estimate = .pred_naive)

results_naive[["table"]] %>% knitr::kable()


# Visualization ----------------------------------------------------------------

# Plots the AUC of the min_n and mtry of the different models
rf_tune %>%
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

boost_tune %>%
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

rf_tune %>%
  collect_metrics() %>%
  filter(.metric == "roc_auc") %>%
  mutate(min_n = factor(min_n)) %>%
  ggplot(aes(mtry, mean, color = min_n)) +
  geom_line(alpha = 0.5, size = 1.5) +
  geom_point() +
  labs(y = "AUC")


