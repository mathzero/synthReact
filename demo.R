# Demo Script for synthReact Package

# -------------------------------------------------------
# Load Necessary Libraries
# -------------------------------------------------------

# Load the synthReact package
library(synthReact)

# Load additional libraries for data manipulation and visualization
library(ggplot2)
library(dplyr)
library(pROC)  # For ROC curve analysis
library(corrplot)  # For correlation matrix visualization

# -------------------------------------------------------
# Generate Synthetic Data
# -------------------------------------------------------

# Set seed for reproducibility
seed_value <- 123

# Generate synthetic data
n_samples <- 10000
synthetic_data <- generate_synthetic_data(n_samples = n_samples, seed = seed_value)

# View the first few rows of the data
head(synthetic_data)

# Summary statistics of the data
summary(synthetic_data)

# -------------------------------------------------------
# Simple Visualizations
# -------------------------------------------------------

# 1. Histogram of Age
ggplot(synthetic_data, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black") +
  labs(title = "Histogram of Age", x = "Age", y = "Count") +
  theme_minimal()

# 2. Boxplot of BMI by Gender
ggplot(synthetic_data, aes(x = gender, y = bmi)) +
  geom_boxplot(fill = "blue", color = "black") +
  labs(title = "BMI by Gender", x = "Gender", y = "BMI") +
  theme_minimal()

# 3. Bar Plot of Smoking Status
ggplot(synthetic_data, aes(x = smokeever_cat)) +
  geom_bar(fill = "blue", color = "black") +
  labs(title = "Smoking Status Distribution", x = "Smoking Status", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4. Scatter Plot of Age vs. BMI colored by PCR Test Result
ggplot(synthetic_data, aes(x = age, y = bmi, color = as.factor(pcr_test_result))) +
  geom_point(alpha = 0.7) +
  labs(title = "Age vs. BMI Colored by PCR Test Result", x = "Age", y = "BMI", color = "PCR Test Result") +
  theme_minimal()


# -------------------------------------------------------
# Correlation Matrix Visualization of Continuous Variables
# -------------------------------------------------------

# Select continuous variables
continuous_vars <- synthetic_data %>%
  select(age, bmi, imd_decile, num_comorbidities)

# Compute correlation matrix
cor_matrix <- cor(continuous_vars)

# Visualize the correlation matrix
corrplot(cor_matrix, method = "color", type = "upper",
         tl.col = "black", tl.srt = 45,
         addCoef.col = "black", number.cex = 0.7,
         title = "Correlation Matrix of Continuous Variables",
         mar = c(0, 0, 1, 0))

# -------------------------------------------------------
# Modeling Outcomes
# -------------------------------------------------------

# Convert outcomes to factors for modeling
synthetic_data$pcr_test_result <- factor(synthetic_data$pcr_test_result, levels = c(0, 1))
synthetic_data$longcovid <- factor(synthetic_data$longcovid, levels = c(0, 1))

# Logistic Regression Model for PCR Test Result
model_pcr_test_result <- glm(pcr_test_result ~ age + symptom_loss_smell+symptom_loss_taste+
                               symptom_cough + symptom_fever + covid_before+vaccinated,
                             data = synthetic_data, family = binomial)

# Summary of the model
summary(model_pcr_test_result)

# Odds ratios and confidence intervals
exp(cbind(OddsRatio = coef(model_pcr_test_result), confint(model_pcr_test_result)))

# Logistic Regression Model for Long COVID
model_longcovid <- glm(longcovid ~ age + gender + bmi + smokeever_cat + num_comorbidities + vaccinated,
                       data = synthetic_data, family = binomial)

# Summary of the model
summary(model_longcovid)

# Odds ratios and confidence intervals
exp(cbind(OddsRatio = coef(model_longcovid), confint(model_longcovid)))

# -------------------------------------------------------
# Additional Visualizations Based on Model Results
# -------------------------------------------------------

# Predicted probabilities for PCR Test Result
synthetic_data$predicted_prob_pcr <- predict(model_pcr_test_result, type = "response")

# Histogram of Predicted Probabilities for PCR Test Result
ggplot(synthetic_data, aes(x = predicted_prob_pcr)) +
  geom_histogram(binwidth = 0.05, fill = "blue", color = "black") +
  labs(title = "Predicted Probabilities for PCR Test Result", x = "Predicted Probability", y = "Count") +
  theme_minimal()

# ROC Curve for PCR Test Result
roc_pcr_test <- roc(as.numeric(synthetic_data$pcr_test_result), synthetic_data$predicted_prob_pcr)

# Plot ROC Curve
plot(roc_pcr_test, col = "red", main = "ROC Curve for PCR Test Result")


# AUC Value
auc_value_pcr <- auc(roc_pcr_test)
print(paste("AUC for PCR Test Result:", round(auc_value_pcr, 3)))

# -------------------------------------------------------
# Save the Synthetic Data (Optional)
# -------------------------------------------------------

# Write the synthetic data to a CSV file
# write.csv(synthetic_data, file = "synthetic_data.csv", row.names = FALSE)
