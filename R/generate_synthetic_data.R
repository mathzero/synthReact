#' Generate Synthetic Data
#'
#' @description
#' This function generates synthetic data using parameters sourced from the `exported_parameters` object.
#' #'
#'
#' @import stats
#' @import MASS
#'
#' @param n_samples Integer. Number of samples to generate.
#' @return A data frame containing the synthetic dataset.
#' @examples
#' synthetic_data <- generate_synthetic_data(n_samples = 1000)
#' @export

generate_synthetic_data <- function(n_samples, seed = NULL) {
  # Load necessary libraries
  library(MASS)

  # Set seed for reproducibility if provided
  if (!is.null(seed)) {
    set.seed(seed)
  }

  # Access parameters from exported_parameters
  params <- exported_parameters

  # Extract parameters
  means_continuous <- params$means_continuous
  cov_matrix <- params$cov_matrix
  category_probabilities <- params$category_probabilities
  coefficients_pcr_test_result <- params$coefs_1
  coefficients_longcovid <- params$coefs_2
  levels_categorical <- params$levels_categorical

  # Identify variable names
  continuous_vars <- names(means_continuous)
  categorical_vars <- names(category_probabilities)

  # Generate continuous variables
  synthetic_continuous <- mvrnorm(
    n = n_samples,
    mu = means_continuous,
    Sigma = cov_matrix
  )
  synthetic_continuous <- as.data.frame(synthetic_continuous)
  colnames(synthetic_continuous) <- continuous_vars

  # Adjust continuous variables as per your requirements

  # 1. Age: integer between 5 and 100
  synthetic_continuous$age <- round(synthetic_continuous$age)
  synthetic_continuous$age <- pmax(synthetic_continuous$age, 5)
  synthetic_continuous$age <- pmin(synthetic_continuous$age, 100)

  # 2. BMI: rounded to one decimal place
  synthetic_continuous$bmi <- round(synthetic_continuous$bmi, 1)

  # 3. IMD decile: integer between 1 and 10
  synthetic_continuous$imd_decile <- round(synthetic_continuous$imd_decile)
  synthetic_continuous$imd_decile <- pmax(synthetic_continuous$imd_decile, 1)
  synthetic_continuous$imd_decile <- pmin(synthetic_continuous$imd_decile, 10)

  # 4. Num comorbidities: integer between 0 and 17
  synthetic_continuous$num_comorbidities <- round(synthetic_continuous$num_comorbidities)
  synthetic_continuous$num_comorbidities <- pmax(synthetic_continuous$num_comorbidities, 0)
  synthetic_continuous$num_comorbidities <- pmin(synthetic_continuous$num_comorbidities, 17)

  # Generate categorical variables
  synthetic_categorical <- data.frame(matrix(
    nrow = n_samples,
    ncol = length(categorical_vars)
  ))
  colnames(synthetic_categorical) <- categorical_vars

  for (var in categorical_vars) {
    probs_df <- category_probabilities[[var]]
    categories <- as.character(probs_df$Var1)
    probabilities <- probs_df$Freq
    synthetic_categorical[[var]] <- sample(
      categories,
      size = n_samples,
      replace = TRUE,
      prob = probabilities
    )
    # Ensure the variable is a factor with the original levels
    synthetic_categorical[[var]] <- factor(
      synthetic_categorical[[var]],
      levels = levels_categorical[[var]]
    )
  }

  # Combine variables
  synthetic_data <- cbind(synthetic_continuous, synthetic_categorical)

  # Ensure factors have correct levels and reference levels
  # Example: Set 'gender' factor levels and reference level
  if ("gender" %in% names(synthetic_data)) {
    synthetic_data$gender <- factor(
      synthetic_data$gender,
      levels = levels_categorical$gender
    )
    synthetic_data$gender <- relevel(synthetic_data$gender, ref = "1")
  }

  # Repeat for other categorical variables as needed

  # Generate outcomes with new names
  synthetic_data$pcr_test_result <- generate_outcome(
    synthetic_data,
    coefficients_pcr_test_result
  )

  synthetic_data$longcovid <- generate_outcome(
    synthetic_data,
    coefficients_longcovid
  )

  return(synthetic_data)
}
