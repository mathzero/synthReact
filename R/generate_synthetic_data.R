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
#'
generate_synthetic_data <- function(n_samples, seed = NULL) {
  # Set seed for reproducibility if provided
  if (!is.null(seed)) {
    set.seed(seed)
  }

  # Load exported parameters
  params <- exported_parameters

  # Extract parameters
  coefficients_bmi <- params$coefficients_bmi
  sd_resid_bmi <- params$sd_resid_bmi

  coefficients_imd <- params$coefficients_imd
  sd_resid_imd <- params$sd_resid_imd

  coefficients_comorb <- params$coefficients_comorb
  sd_resid_comorb <- params$sd_resid_comorb

  category_probabilities <- params$category_probabilities
  coefficients_pcr_test_result <- params$coefs_1
  coefficients_longcovid <- params$coefs_2
  levels_categorical <- params$levels_categorical

  # Initialize synthetic data frame with 'age'
  synthetic_data <- data.frame(age = round(runif(n_samples, min = 5, max = 100)))

  # Generate 'bmi' conditional on 'age'
  synthetic_data$bmi <- coefficients_bmi[1] + coefficients_bmi[2] * synthetic_data$age +
    rnorm(n_samples, mean = 0, sd = sd_resid_bmi)
  synthetic_data$bmi <- round(synthetic_data$bmi, 1)

  # Generate 'imd_decile' conditional on 'age'
  synthetic_data$imd_decile <- coefficients_imd[1] + coefficients_imd[2] * synthetic_data$age +
    rnorm(n_samples, mean = 0, sd = sd_resid_imd)
  synthetic_data$imd_decile <- round(synthetic_data$imd_decile)
  synthetic_data$imd_decile <- pmax(synthetic_data$imd_decile, 1)
  synthetic_data$imd_decile <- pmin(synthetic_data$imd_decile, 10)

  # Generate 'num_comorbidities' conditional on 'age'
  synthetic_data$num_comorbidities <- coefficients_comorb[1] + coefficients_comorb[2] * synthetic_data$age +
    rnorm(n_samples, mean = 0, sd = sd_resid_comorb)
  synthetic_data$num_comorbidities <- round(synthetic_data$num_comorbidities)
  synthetic_data$num_comorbidities <- pmax(synthetic_data$num_comorbidities, 0)
  synthetic_data$num_comorbidities <- pmin(synthetic_data$num_comorbidities, 17)

  # Generate categorical variables
  categorical_vars <- names(category_probabilities)
  for (var in categorical_vars) {
    probs_df <- category_probabilities[[var]]
    categories <- as.character(probs_df$Var1)
    probabilities <- probs_df$Freq
    synthetic_data[[var]] <- sample(
      categories,
      size = n_samples,
      replace = TRUE,
      prob = probabilities
    )
    # Ensure the variable is a factor with the original levels
    synthetic_data[[var]] <- factor(
      synthetic_data[[var]],
      levels = levels_categorical[[var]]
    )
  }

  # Generate outcomes
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
