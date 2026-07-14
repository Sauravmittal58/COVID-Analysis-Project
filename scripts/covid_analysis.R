# ============================================
# COVID-19 Mortality in England: Socio-Demographic Drivers
# Data Analysis Workflow
# ============================================
# This script explores which socio-economic, demographic, ethnic,
# health and travel-behaviour variables are associated with
# COVID-19 death rates across English Local Authorities.
#
# Input : data/COVID_Data.csv  (produced via sql/data_preparation.sql)
# Output: results/analysis_summary.txt, results/best_fit_model.rds,
#         results/pca_results.rds, results/pca_component_scores.csv

# ----------------------------
# 0. Project paths
# ----------------------------
# Assumes the script is run from the project root (or via an RStudio
# Project / .Rproj file placed at the repo root), so paths are relative.
data_path    <- "data/COVID_Data.csv"
results_dir  <- "results"
if (!dir.exists(results_dir)) dir.create(results_dir)

# ----------------------------
# 1. Load Necessary Libraries
# ----------------------------
required_packages <- c("ggplot2", "corrplot", "psych", "car", "MASS")
new_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]
if (length(new_packages)) install.packages(new_packages)

library(ggplot2)     # For plotting
library(corrplot)    # For correlation matrix visualization
library(psych)       # For KMO test and PCA
library(car)         # For regression diagnostics
library(MASS)        # For stepwise regression

# ----------------------------
# 2. Read Data
# ----------------------------
data <- read.csv(data_path, header = TRUE)

# Check data structure
str(data)
head(data)
summary(data)

# Check for missing values
sum(is.na(data))
colSums(is.na(data))

# ----------------------------
# 3. Check Dependent Variable Normality
# ----------------------------
dependent_var <- "Covid_Deaths"

# Histogram with density curve
ggplot(data, aes(x = .data[[dependent_var]])) +
  geom_histogram(aes(y = ..density..),
                 bins = 30,
                 fill = "lightblue",
                 color = "black") +
  geom_density(alpha = 0.2, fill = "red") +
  ggtitle("Distribution of Covid Deaths") +
  xlab("Covid Deaths") +
  ylab("Density")

# Q-Q plot for normality check
qqnorm(data[[dependent_var]], main = "Q-Q Plot for Covid Deaths")
qqline(data[[dependent_var]], col = "red")

# Shapiro-Wilk test for normality
shapiro_test <- shapiro.test(data[[dependent_var]])
print(paste("Shapiro-Wilk test p-value:", shapiro_test$p.value))

if (shapiro_test$p.value < 0.05) {
  print("Warning: Dependent variable may not be normally distributed")
} else {
  print("Dependent variable appears normally distributed")
}

# ----------------------------
# 4. Explore Dependent Variable vs Independent Variables
# ----------------------------
exclude_cols <- c("LA_Name", "LA_Code", dependent_var)
independent_vars <- setdiff(names(data), exclude_cols)

par(mfrow = c(2, 3))
for (i in 1:min(6, length(independent_vars))) {
  var <- independent_vars[i]
  plot(data[[var]], data[[dependent_var]],
       main = paste(dependent_var, "vs", var),
       xlab = var, ylab = dependent_var,
       pch = 19, col = "blue", cex = 0.6)
  abline(lm(data[[dependent_var]] ~ data[[var]]), col = "red")
}
par(mfrow = c(1, 1))

# ----------------------------
# 5. Correlation Analysis
# ----------------------------
numeric_data <- data[, sapply(data, is.numeric)]
cor_matrix <- cor(numeric_data, use = "complete.obs")

corrplot(cor_matrix, method = "color", type = "upper",
         tl.col = "black", tl.cex = 0.7,
         title = "Correlation Matrix", mar = c(0, 0, 2, 0))

cor_with_dependent <- cor_matrix[dependent_var, ]
sorted_cor <- sort(cor_with_dependent, decreasing = TRUE)
print("Top 10 variables correlated with Covid_Deaths:")
print(head(sorted_cor, 10))

# ----------------------------
# 6. Kaiser-Meyer-Olkin (KMO) Test
# ----------------------------
kmo_data <- data[, sapply(data, is.numeric)]

kmo_result <- KMO(kmo_data)
print(paste("Overall KMO (MSA):", round(kmo_result$MSA, 3)))

kmo_msa <- kmo_result$MSAi
print("KMO Measure of Sampling Adequacy for each variable:")
print(sort(kmo_msa))

if (kmo_result$MSA > 0.6) {
  print("Data is suitable for factor analysis (MSA > 0.6)")
} else {
  print("Warning: Data may not be suitable for factor analysis (MSA <= 0.6)")
}

# ----------------------------
# 7. Principal Component Analysis (PCA)
# ----------------------------
pca_data <- scale(kmo_data)
pca_result <- prcomp(pca_data, center = TRUE, scale. = TRUE)
summary(pca_result)

screeplot(pca_result, type = "lines", main = "Scree Plot")
abline(h = 1, col = "red", lty = 2)  # Kaiser criterion (eigenvalue > 1)

var_explained <- pca_result$sdev^2 / sum(pca_result$sdev^2)
cum_var_explained <- cumsum(var_explained)

print("Variance explained by each component:")
print(data.frame(
  PC = 1:length(var_explained),
  Variance = round(var_explained, 4),
  Cumulative = round(cum_var_explained, 4)
))

# ----------------------------
# 8. Varimax Rotated PCA
# ----------------------------
n_components <- which(cum_var_explained >= 0.7)[1]
print(paste("Number of components for ~70% variance:", n_components))

pca_psych <- principal(kmo_data, nfactors = n_components, rotate = "varimax")

print("Rotated Component Matrix:")
print(round(pca_psych$loadings, 3))

fa.diagram(pca_psych, main = "Factor Analysis Diagram")

component_scores <- as.data.frame(pca_psych$scores)
names(component_scores) <- paste0("PC", 1:n_components)

# ----------------------------
# 9. Multiple Regression & Best-Fit Model
# ----------------------------
# Option A: Top correlated original variables
top_vars <- names(sorted_cor[2:11])  # Top 10 excluding self-correlation

formula_str <- paste(dependent_var, "~", paste(top_vars, collapse = " + "))
full_model <- lm(as.formula(formula_str), data = data)
summary(full_model)

# Option B: PCA components as predictors
data_with_pc <- cbind(data, component_scores)
pca_formula <- paste(dependent_var, "~",
                      paste(names(component_scores), collapse = " + "))
pca_model <- lm(as.formula(pca_formula), data = data_with_pc)
summary(pca_model)

# ----------------------------
# 10. Stepwise Regression for Best-Fit Model
# ----------------------------
null_model <- lm(as.formula(paste(dependent_var, "~ 1")), data = data)
full_formula <- as.formula(paste(dependent_var, "~",
                                  paste(independent_vars, collapse = " + ")))

stepwise_model <- stepAIC(null_model,
                           scope = list(lower = null_model, upper = full_formula),
                           direction = "both",
                           trace = FALSE)

print("======================")
print("BEST-FIT MODEL SUMMARY")
print("======================")
summary(stepwise_model)

par(mfrow = c(2, 2))
plot(stepwise_model)
par(mfrow = c(1, 1))

if (length(coefficients(stepwise_model)) > 1) {
  vif_values <- vif(stepwise_model)
  print("Variance Inflation Factors (VIF):")
  print(vif_values)

  if (any(vif_values > 5)) {
    print("Warning: Some variables show high multicollinearity (VIF > 5)")
  }
}

r_squared <- summary(stepwise_model)$r.squared
adj_r_squared <- summary(stepwise_model)$adj.r.squared
aic <- AIC(stepwise_model)

print(paste("R-squared:", round(r_squared, 4)))
print(paste("Adjusted R-squared:", round(adj_r_squared, 4)))
print(paste("AIC:", round(aic, 2)))

# ----------------------------
# 11. Save Results
# ----------------------------
saveRDS(stepwise_model, file.path(results_dir, "best_fit_model.rds"))
saveRDS(pca_result, file.path(results_dir, "pca_results.rds"))
write.csv(component_scores, file.path(results_dir, "pca_component_scores.csv"), row.names = FALSE)

sink(file.path(results_dir, "analysis_summary.txt"))
print("DATA ANALYSIS SUMMARY")
print("=====================")
print(paste("Date:", Sys.Date()))
print(paste("Dependent variable:", dependent_var))
print(paste("Shapiro-Wilk p-value:", round(shapiro_test$p.value, 4)))
print(paste("KMO MSA:", round(kmo_result$MSA, 3)))
print(paste("PCA components for 70% variance:", n_components))
print("")
print("BEST MODEL COEFFICIENTS:")
print(summary(stepwise_model)$coefficients)
print("")
print(paste("Model R-squared:", round(r_squared, 4)))
print(paste("Model Adjusted R-squared:", round(adj_r_squared, 4)))
print(paste("Model AIC:", round(aic, 2)))
sink()

print("Analysis complete! Check 'results/analysis_summary.txt' for results.")
