synthReact Package Demo
================
Matthew Whitaker
October 10, 2024

- [Overview](#overview)
- [Installation](#installation)
- [Loading the Package](#loading-the-package)
- [Generating Synthetic Data](#generating-synthetic-data)
- [Synthetic Data Structure](#synthetic-data-structure)
- [Data Exploration and
  Visualization](#data-exploration-and-visualization)
  - [Histogram of Age](#histogram-of-age)
  - [Boxplot of BMI by Gender](#boxplot-of-bmi-by-gender)
  - [Bar Plot of Smoking Status](#bar-plot-of-smoking-status)
  - [Scatter Plot of Age vs. BMI Colored by PCR Test
    Result](#scatter-plot-of-age-vs-bmi-colored-by-pcr-test-result)
  - [Correlation Matrix of Continuous
    Variables](#correlation-matrix-of-continuous-variables)
- [Modeling Outcomes](#modeling-outcomes)
  - [Logistic Regression Model for PCR Test
    Result](#logistic-regression-model-for-pcr-test-result)
  - [Odds Ratios and Confidence
    Intervals](#odds-ratios-and-confidence-intervals)
  - [Logistic Regression Model for Long
    COVID](#logistic-regression-model-for-long-covid)
  - [Odds Ratios and Confidence
    Intervals](#odds-ratios-and-confidence-intervals-1)
- [ROC Curve Analysis](#roc-curve-analysis)
  - [Predicted Probabilities and ROC Curve for PCR Test
    Result](#predicted-probabilities-and-roc-curve-for-pcr-test-result)
  - [AUC Value](#auc-value)
- [Saving the Synthetic Data
  (Optional)](#saving-the-synthetic-data-optional)
- [Conclusion](#conclusion)
- [Additional Notes](#additional-notes)
- [References](#references)

# Overview

This document demonstrates the usage of the `synthReact` R package,
which generates synthetic datasets based on the REACT-1 study
parameters. The package allows users to create realistic synthetic data
for analysis and modeling while preserving data privacy.

# Installation

``` r
# Install devtools if not already installed
install.packages("devtools")

# Install synthReact from GitHub
devtools::install_github("mathzero/synthReact")
```

# Loading the Package

``` r
# Load the synthReact package
library(synthReact)
```

# Generating Synthetic Data

Generate a synthetic dataset with 1,000 samples:

``` r
# Set seed for reproducibility
seed_value <- 123

# Generate synthetic data
n_samples <- 1000
synthetic_data <- generate_synthetic_data(n_samples = n_samples, seed = seed_value)

# View the first few rows
head(synthetic_data)
```

# Synthetic Data Structure

The synthetic dataset includes:

- **Continuous Variables**:
  - `age`: Integer between 5 and 100.
  - `bmi`: Numeric, rounded to one decimal place.
  - `imd_decile`: Integer between 1 and 10.
  - `num_comorbidities`: Integer between 0 and 17.
- **Categorical Variables**: Factors with levels reflecting the original
  data.
- **Outcome Variables**:
  - `pcr_test_result`: Binary variable indicating the result of a PCR
    test.
  - `longcovid`: Binary variable indicating the presence of Long COVID.

# Data Exploration and Visualization

## Histogram of Age

``` r
library(ggplot2)

ggplot(synthetic_data, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black") +
  labs(title = "Histogram of Age", x = "Age", y = "Count") +
  theme_minimal()
```

<figure>
<img src="plots/histogram_age.png" alt="Histogram of Age" />
<figcaption aria-hidden="true">Histogram of Age</figcaption>
</figure>

## Boxplot of BMI by Gender

``` r
ggplot(synthetic_data, aes(x = gender, y = bmi)) +
  geom_boxplot(fill = "orange", color = "black") +
  labs(title = "BMI by Gender", x = "Gender", y = "BMI") +
  theme_minimal()
```

<figure>
<img src="plots/boxplot_bmi_gender.png" alt="BMI by Gender" />
<figcaption aria-hidden="true">BMI by Gender</figcaption>
</figure>

## Bar Plot of Smoking Status

``` r
ggplot(synthetic_data, aes(x = smokeever_cat)) +
  geom_bar(fill = "green", color = "black") +
  labs(title = "Smoking Status Distribution", x = "Smoking Status", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

<figure>
<img src="plots/barplot_smoking_status.png"
alt="Smoking Status Distribution" />
<figcaption aria-hidden="true">Smoking Status Distribution</figcaption>
</figure>

## Scatter Plot of Age vs. BMI Colored by PCR Test Result

``` r
ggplot(synthetic_data, aes(x = age, y = bmi, color = as.factor(pcr_test_result))) +
  geom_point(alpha = 0.7) +
  labs(title = "Age vs. BMI Colored by PCR Test Result", x = "Age", y = "BMI", color = "PCR Test Result") +
  theme_minimal()
```

<figure>
<img src="plots/scatter_age_bmi_pcr.png"
alt="Age vs. BMI Colored by PCR Test Result" />
<figcaption aria-hidden="true">Age vs. BMI Colored by PCR Test
Result</figcaption>
</figure>

## Correlation Matrix of Continuous Variables

``` r
library(corrplot)
library(dplyr)

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
```

<figure>
<img src="plots/correlation_matrix.png"
alt="Correlation Matrix of Continuous Variables" />
<figcaption aria-hidden="true">Correlation Matrix of Continuous
Variables</figcaption>
</figure>

# Modeling Outcomes

## Logistic Regression Model for PCR Test Result

``` r
# Convert outcome to factor
synthetic_data$pcr_test_result <- factor(synthetic_data$pcr_test_result, levels = c(0, 1))

# Fit the model
model_pcr_test_result <- glm(pcr_test_result ~ age + gender + bmi + smokeever_cat + num_comorbidities,
                             data = synthetic_data, family = binomial)

# Summary of the model
summary(model_pcr_test_result)
```

<details>
<summary>
Click to expand the model summary
</summary>

``` r
# Output of the summary(model_pcr_test_result)
```

</details>

## Odds Ratios and Confidence Intervals

``` r
# Odds ratios and confidence intervals
exp(cbind(OddsRatio = coef(model_pcr_test_result), confint(model_pcr_test_result)))
```

<details>
<summary>
Click to expand the odds ratios and confidence intervals
</summary>

``` r
# Output of the exp(cbind(...))
```

</details>

## Logistic Regression Model for Long COVID

``` r
# Convert outcome to factor
synthetic_data$longcovid <- factor(synthetic_data$longcovid, levels = c(0, 1))

# Fit the model
model_longcovid <- glm(longcovid ~ age + gender + bmi + smokeever_cat + num_comorbidities,
                       data = synthetic_data, family = binomial)

# Summary of the model
summary(model_longcovid)
```

<details>
<summary>
Click to expand the model summary
</summary>

``` r
# Output of the summary(model_longcovid)
```

</details>

## Odds Ratios and Confidence Intervals

``` r
# Odds ratios and confidence intervals
exp(cbind(OddsRatio = coef(model_longcovid), confint(model_longcovid)))
```

<details>
<summary>
Click to expand the odds ratios and confidence intervals
</summary>

``` r
# Output of the exp(cbind(...))
```

</details>

# ROC Curve Analysis

## Predicted Probabilities and ROC Curve for PCR Test Result

``` r
library(pROC)

# Predicted probabilities for PCR Test Result
synthetic_data$predicted_prob_pcr <- predict(model_pcr_test_result, type = "response")

# ROC Curve for PCR Test Result
roc_pcr_test <- roc(as.numeric(synthetic_data$pcr_test_result), synthetic_data$predicted_prob_pcr)

# Plot ROC Curve
plot(roc_pcr_test, col = "red", main = "ROC Curve for PCR Test Result")
abline(a = 0, b = 1, lty = 2, col = "gray")
```

<figure>
<img src="plots/roc_curve_pcr.png"
alt="ROC Curve for PCR Test Result" />
<figcaption aria-hidden="true">ROC Curve for PCR Test
Result</figcaption>
</figure>

## AUC Value

``` r
# AUC Value
auc_value_pcr <- auc(roc_pcr_test)
print(paste("AUC for PCR Test Result:", round(auc_value_pcr, 3)))
```

**Output:**

    [1] "AUC for PCR Test Result: 0.624"

# Saving the Synthetic Data (Optional)

You can save the generated synthetic data to a CSV file for future use:

``` r
# Write the synthetic data to a CSV file
write.csv(synthetic_data, file = "synthetic_data.csv", row.names = FALSE)
```

# Conclusion

This demo showcases how to generate and analyze synthetic data using the
`synthReact` package. The synthetic data preserves the statistical
properties of the original REACT-1 study data, allowing for meaningful
analysis while ensuring data privacy.

------------------------------------------------------------------------

# Additional Notes

- **Plots**: The images included in this document (e.g., histograms,
  scatter plots) are generated when you knit the R Markdown file. Ensure
  that you have the necessary packages installed.

- **Package Dependencies**: Make sure to install all required packages
  before running the script:

  ``` r
  install.packages(c("ggplot2", "dplyr", "pROC", "corrplot"))
  ```

- **Data Privacy**: The synthetic data generated does not contain any
  real participant information from the REACT-1 study, maintaining
  confidentiality.

# References

- **synthReact GitHub Repository**: [Link to your
  repository](https://github.com/mathzero/synthReact)
- **REACT-1 Study**: [Official
  Website](https://www.imperial.ac.uk/medicine/research-and-impact/groups/react-study/studies/the-react-1-programme/)

------------------------------------------------------------------------
