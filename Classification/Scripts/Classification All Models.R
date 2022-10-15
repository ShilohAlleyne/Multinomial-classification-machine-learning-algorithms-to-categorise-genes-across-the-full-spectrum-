
# Imports data -----------------------------------------------------------------

anno_test <- read.csv("output data/testdata_rpkm.csv", row.names=1)
anno_train <- read.csv("output data/trainingdata_rpkm.csv", row.names=1)

# Counts the fusil types -------------------------------------------------------
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
anno_train %>% 
  count(FUSIL, sort = TRUE)

# Creates a recipe  ------------------------------------------------------------

anno_recipe <- recipe(FUSIL ~ ., data = anno_train) %>% 
  themis::step_upsample(FUSIL)

# Builds Models ----------------------------------------------------------------

rf_spec <- rand_forest(mtry = tune(),
                       trees = 1000,
                       min_n = tune()) %>%
  set_engine("ranger") %>%
  set_mode("classification")

glm_spec <- multinom_reg(penalty = tune(),
                         mixture = 1) %>%
  set_engine("nnet")

sv_spec <- svm_poly() %>%
  set_engine("kernlab") %>%
  set_mode("classification")

# Creates Workflows ------------------------------------------------------------

wf_rf <- workflow() %>%
  add_recipe(anno_recipe) %>%
  add_model(rf_spec) 

wf_glm <- workflow() %>%
  add_recipe(anno_recipe) %>%
  add_model(glm_spec)

wf_sv <- workflow() %>%
  add_recipe(anno_recipe) %>%
  add_model(sv_spec)

# Bootstraps -------------------------------------------------------------------

anno_boot <- bootstraps(anno_train)

rf_boot <- wf_rf %>%
  fit_resamples(FUSIL ~ .,
                resamples = anno_boot,
                control = control_resamples(save_pred = TRUE)
  )

sv_boot <- wf_sv %>%
  fit_resamples(FUSIL ~ .,
                resamples = anno_boot,
                control = control_resamples(save_pred = TRUE)
  )

glimpse(rf_boot)

# Fits the workflow ------------------------------------------------------------

anno_rf <- fit(wf_rf, data = anno_train)

anno_glm <- fit(wf_glm, data = anno_train)

anno_sv <- fit(wf_sv, data = anno_train)

# Cross validation-------------------------------------------------------------- 

anno_folds <- vfold_cv(anno_train, v = 10)


sv_res <- wf_sv %>%
  fit_resamples(anno_folds,
                metrics = metric_set(roc_auc, 
                                     sensitivity, 
                                     specificity, 
                                     accuracy),
                control = control_resamples(save_pred = TRUE)
                )

final_rf_res <- final_rf_wf %>%
  fit_resamples(anno_folds,
                metrics = metric_set(roc_auc, 
                                     sensitivity, 
                                     specificity, 
                                     accuracy),
                control = control_resamples(save_pred = TRUE)
  )


# Evaluates results ------------------------------------------------------------

results <- anno_train %>%
  bind_cols(predict(anno_rf, anno_train) %>%
              rename(.pred_rf = .pred_class))

results.glm <- anno_train %>% 
  bind_cols(predict(anno_glm, anno_train) %>%
              rename(.pred_glm = .pred_class))

results.sv <- anno_train %>% 
  bind_cols(predict(anno_sv, anno_train) %>%
              rename(.pred_glm = .pred_class))

# Confusion matrix for models
results %>%
  conf_mat(truth = FUSIL, estimate = .pred_rf) # Random forest

results.glm %>%
  conf_mat(truth = FUSIL, estimate = .pred_glm) # Logistic Regression

results.sv %>%
  conf_mat(truth = FUSIL, estimate = .pred_glm) # Support vector


# Accuracy of the models
accuracy(results, truth = as.factor(FUSIL), estimate = .pred_rf)

accuracy(results.glm, truth = as.factor(FUSIL), estimate = .pred_glm)

accuracy(results.sv, truth = as.factor(FUSIL), estimate = .pred_glm)


# Resampled RF metrics
rf_res %>%
  collect_metrics()

rf_res %>%
  collect_predictions() %>%
  conf_mat(FUSIL, .pred_class)

glm_res %>%
  collect_metrics()

rf_boot %>% collect_metrics()

rf_boot %>%
  collect_predictions() %>%
  conf_mat(FUSIL, .pred_class)

sv_res %>%
  collect_metrics()

sv_boot %>%
  collect_predictions() %>%
  conf_mat(FUSIL, .pred_class)

sv_boot %>% collect_metrics()

final_rf_res %>%
  collect_predictions() %>%
  conf_mat(FUSIL, .pred_class)

final_rf_res %>% collect_metrics()


# Tuning RF Hyper-parameters ------------------------------------------------------

doParallel::registerDoParallel() # Grind for Parrel processing

# Trains 20 different models with different hyper perameters
rf_res <- tune_grid(
  wf_rf,
  resamples = anno_folds,
  grid = 20
)

# Selects models with good mtry and min_n AUC values
rf_grid <- grid_regular(
  mtry(range = c(0, 50)),
  min_n(range = c(0, 15)),
  levels = 5
)

# A more targeted tunning with selected hyper peramters
regular_res <- tune_grid(
  wf_rf,
  resamples = anno_folds,
  grid = rf_grid
)

# Chooses best model
best_auc <- select_best(regular_res, "roc_auc")

final_rf <- finalize_model(
  rf_spec,
  best_auc
)

final_rf_wf <- workflow() %>%
  add_recipe(anno_recipe) %>%
  add_model(final_rf)


anno_final_rf <- fit(final_rf_wf, data = anno_train)

results.frf <- anno_train %>%
  bind_cols(predict(anno_final_rf, anno_train) %>%
              rename(.pred_rf = .pred_class))

results.frf %>%
  conf_mat(truth = FUSIL, estimate = .pred_rf)

accuracy(results.frf, truth = as.factor(FUSIL), estimate = .pred_rf)
roc_auc(results.frf, truth = as.factor(FUSIL), estimate = .pred_rf)


# Tuning Logistic regression Hyper-parameters

glm_res <- tune_grid(
  wf_glm,
  resamples = anno_folds,
  grid = 20
)

best_glm <- glm_res %>%
  show_best("accuracy")

# Visualization ----------------------------------------------------------------

rf_res %>%
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

regular_res %>%
  collect_metrics() %>%
  filter(.metric == "roc_auc") %>%
  mutate(min_n = factor(min_n)) %>%
  ggplot(aes(mtry, mean, color = min_n)) +
  geom_line(alpha = 0.5, size = 1.5) +
  geom_point() +
  labs(y = "AUC")


