# synthReact

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Overview

`synthReact` is an R package designed to generate synthetic datasets that mimic the structure and relationships of data in round 19 of REACT-1. 
The package uses statistical parameters derived from the REACT data to create realistic synthetic data.

## About the REACT-1 Study

The synthetic data generated by `synthReact` is based on parameters derived from the REACT-1 (Real-time Assessment of Community Transmission) study. 
REACT-1 is a large-scale epidemiological study conducted in England by Imperial College London, in partnership with Ipsos MORI. The study aimed to track the prevalence and spread of SARS-CoV-2, the virus causing COVID-19, within the general population.

Key aspects of the REACT-1 study:

- **Regular Testing**: Randomly selected individuals across England were tested regularly to monitor infection rates.
- **Comprehensive Data Collection**: The study collected a range of data, including demographic information, health status, PCR test results, and more.
- **Public Health Insights**: Findings from REACT-1 provided insights into COVID-19 transmission dynamics and informed public health interventions.

For more details about the REACT-1 study, please visit the [official website](https://www.imperial.ac.uk/medicine/research-and-impact/groups/react-study/studies/the-react-1-programme/).

## Features

- **Generate Synthetic Data**: Create synthetic datasets with specified sample sizes.
- **Reproducibility**: Set a seed for random number generation to ensure reproducibility.
- **Realistic Variable Distributions**: Continuous variables are generated based on real data parameters, and categorical variables reflect actual category probabilities.
- **Outcome Variables**: Simulate outcome variables (`pcr_test_result` and `longcovid`) based on logistic regression models.
- **Data Visualization**: Includes functions and examples for visualizing the generated data.
- **Modeling Examples**: Demonstrates how to fit logistic regression models to the synthetic data.

## Installation

You can install the `synthReact` package from GitHub using the `devtools` package:

```R
# Install devtools if not already installed
install.packages("devtools")

# Install synthReact from GitHub
devtools::install_github("mathzero/synthReact")
```



**Note**: Replace `"your_username"` with your actual GitHub username if the package is hosted on GitHub.

## Usage

### Loading the Package

```R
# Load the synthReact package
library(synthReact)
```

### Generating Synthetic Data

Generate a synthetic dataset with 1,000 samples:

```R
# Set seed for reproducibility
seed_value <- 123

# Generate synthetic data
n_samples <- 1000
synthetic_data <- generate_synthetic_data(n_samples = n_samples, seed = seed_value)

# View the first few rows
head(synthetic_data)
```

### Synthetic Data Structure

The synthetic dataset includes:

- **Continuous Variables**:
  - `age`: Integer between 5 and 100.
  - `bmi`: Numeric, rounded to one decimal place.
  - `imd_decile`: Integer between 1 (most deprived) and 10 (least deprived).
  - `num_comorbidities`: Integer between 0 and 17.
- **Categorical Variables**: Factors with levels reflecting the original data.
- **Outcome Variables**:
  - `pcr_test_result`: Binary variable indicating the result of a PCR test.
  - `longcovid`: Binary variable indicating self-reported Long COVID (defined as symptoms for 4+ weeks).

### Example: Data Exploration and Visualization

#### Histogram of Age

```R
library(ggplot2)

ggplot(synthetic_data, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black") +
  labs(title = "Histogram of Age", x = "Age", y = "Count") +
  theme_minimal()
```

#### Boxplot of BMI by Gender

```R
ggplot(synthetic_data, aes(x = gender, y = bmi)) +
  geom_boxplot(fill = "orange", color = "black") +
  labs(title = "BMI by Gender", x = "Gender", y = "BMI") +
  theme_minimal()
```

#### Bar Plot of Smoking Status

```R
ggplot(synthetic_data, aes(x = smokeever_cat)) +
  geom_bar(fill = "green", color = "black") +
  labs(title = "Smoking Status Distribution", x = "Smoking Status", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

#### Scatter Plot of Age vs. BMI Colored by PCR Test Result

```R
ggplot(synthetic_data, aes(x = age, y = bmi, color = as.factor(pcr_test_result))) +
  geom_point(alpha = 0.7) +
  labs(title = "Age vs. BMI Colored by PCR Test Result", x = "Age", y = "BMI", color = "PCR Test Result") +
  theme_minimal()
```

#### Correlation Matrix of Continuous Variables

```R
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

### Example: Modeling Outcomes

#### Logistic Regression Model for PCR Test Result

```R
# Convert outcome to factor
synthetic_data$pcr_test_result <- factor(synthetic_data$pcr_test_result, levels = c(0, 1))

# Fit the model
model_pcr_test_result <- glm(pcr_test_result ~ age + gender + bmi + smokeever_cat + num_comorbidities,
                             data = synthetic_data, family = binomial)

# Summary of the model
summary(model_pcr_test_result)

# Odds ratios and confidence intervals
exp(cbind(OddsRatio = coef(model_pcr_test_result), confint(model_pcr_test_result)))
```

#### Logistic Regression Model for Long COVID

```R
# Convert outcome to factor
synthetic_data$longcovid <- factor(synthetic_data$longcovid, levels = c(0, 1))

# Fit the model
model_longcovid <- glm(longcovid ~ age + gender + bmi + smokeever_cat + num_comorbidities,
                       data = synthetic_data, family = binomial)

# Summary of the model
summary(model_longcovid)

# Odds ratios and confidence intervals
exp(cbind(OddsRatio = coef(model_longcovid), confint(model_longcovid)))
```

### Example: ROC Curve Analysis

```R
library(pROC)

# Predicted probabilities for PCR Test Result
synthetic_data$predicted_prob_pcr <- predict(model_pcr_test_result, type = "response")

# ROC Curve for PCR Test Result
roc_pcr_test <- roc(as.numeric(synthetic_data$pcr_test_result), synthetic_data$predicted_prob_pcr)

# Plot ROC Curve
plot(roc_pcr_test, col = "red", main = "ROC Curve for PCR Test Result")
abline(a = 0, b = 1, lty = 2, col = "gray")

# AUC Value
auc_value_pcr <- auc(roc_pcr_test)
print(paste("AUC for PCR Test Result:", round(auc_value_pcr, 3)))
```

## Function Reference

### `generate_synthetic_data()`

Generates a synthetic dataset based on parameters from real data.

#### Usage

```R
generate_synthetic_data(n_samples, seed = NULL)
```

#### Arguments

- `n_samples`: Integer. Number of samples to generate.
- `seed`: Integer or `NULL`. Seed for random number generation to ensure reproducibility. Default is `NULL`.

#### Value

A data frame containing the synthetic dataset with variables:

- **Continuous variables**: `age`, `bmi`, `imd_decile`, `num_comorbidities`.
- **Categorical variables**: Various factors reflecting original data categories.
- **Outcome variables**: `pcr_test_result`, `longcovid`.

#### Example

```R
# Generate synthetic data with 500 samples and a specific seed
synthetic_data <- generate_synthetic_data(n_samples = 500, seed = 42)
```

## Package Details

### Dependencies

The package depends on the following R packages:

- `MASS`: For multivariate normal distribution functions.
- `ggplot2`: For data visualization.
- `dplyr`: For data manipulation.
- `pROC`: For ROC curve analysis.
- `corrplot`: For correlation matrix visualization.

### Installation of Dependencies

Install the dependencies using:

```R
install.packages(c("MASS", "ggplot2", "dplyr", "pROC", "corrplot"))
```

## Contributing

Contributions to `synthReact` are welcome. If you have suggestions for improvements or encounter any issues, please open an issue or submit a pull request on GitHub.



---
