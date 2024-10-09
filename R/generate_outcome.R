#' Generate Binary Outcome
#'
#' Generates a binary outcome variable based on logistic regression coefficients.

#' @import stats
#' @import MASS
#'
#'
#' @param covariate_data Data frame. The synthetic covariate data.
#' @param coefficients Named numeric vector. The logistic regression coefficients.
#' @return A numeric vector of binary outcomes (0 or 1).
#' @keywords internal
#'

generate_outcome <- function(covariate_data, coefficients) {
  # Ensure intercept is included
  if (!"(Intercept)" %in% names(coefficients)) {
    coefficients <- c("(Intercept)" = 0, coefficients)
  }

  # Build formula using variable names
  variable_names <- names(covariate_data)
  formula_vars <- paste0("`", variable_names, "`", collapse = " + ")
  formula <- as.formula(paste("~", formula_vars))

  # Create design matrix
  design_matrix <- model.matrix(formula, data = covariate_data)

  # Adjust coefficients and design matrix
  # Set coefficients for variables not in design matrix to zero
  design_matrix_cols <- colnames(design_matrix)
  coeff_names <- names(coefficients)

  # Add zero coefficients for variables in design matrix but not in coefficients
  missing_coeffs <- setdiff(design_matrix_cols, coeff_names)
  if (length(missing_coeffs) > 0) {
    coefficients <- c(coefficients, setNames(rep(0, length(missing_coeffs)), missing_coeffs))
  }

  # Add zero columns in design matrix for coefficients not in design matrix
  missing_cols <- setdiff(coeff_names, design_matrix_cols)
  if (length(missing_cols) > 0) {
    zero_cols <- matrix(0, nrow = nrow(design_matrix), ncol = length(missing_cols))
    colnames(zero_cols) <- missing_cols
    design_matrix <- cbind(design_matrix, zero_cols)
  }

  # Reorder columns to match coefficients
  design_matrix <- design_matrix[, names(coefficients), drop = FALSE]

  # Calculate linear predictor
  linear_predictor <- as.numeric(design_matrix %*% coefficients)

  # Calculate probabilities
  probabilities <- 1 / (1 + exp(-linear_predictor))

  # Generate binary outcomes
  outcomes <- rbinom(nrow(covariate_data), 1, probabilities)
  return(outcomes)
}

