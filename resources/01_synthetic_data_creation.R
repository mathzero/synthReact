

#' First clear the environment of variables
rm(list=ls(all=TRUE))

#setwd("G:/Group/")
outpath <- paste0(getwd(),"/output/")
figpath <- paste0(getwd(),"/plots/")

func_path="G:/shared_working_folder/function_scripts/"

#' Source any functions from the local file
source(paste0(func_path,"load_packages.R"))
source(paste0(func_path,"create_subfolder.R"))

#' Pull in packages needed
package.list <- c("dplyr","MASS",
                  "ggplot2","gdata","ggsci", "RColorBrewer", "tidyverse", "lubridate",
                  "OverReact")
load_packages(package.list)

# load data
dfRes_master <- readRDS("G:/shared_working_folder/saved_objects/react1_r1_to_r19.rds")
dfRes_1 <- dfRes_master %>% filter(round==19)
dfRes_1 <- dfRes_1 %>% filter(!is.na(res))
dfRes_1 <- dfRes_1 %>% filter(!is.na(d_comb))
dfRes_1$bmi[dfRes_1$bmi>60] <- NA_real_
dfRes_1 <- dfRes_1 %>% filter(!is.na(bmi))

# get list of healthnames for comorbidity calculation
healthnames=setdiff(grep("healtha",names(dfRes_1),value=T),"healtha_5")


# engineer new covariates
dfRes_1 <- dfRes_1 %>%
  rowwise() %>%
  mutate(num_comorbidities=sum(c_across(healthnames),na.rm=T)) %>%
  ungroup()

# simple mutates
dfRes_1 <- dfRes_1  %>%
  mutate(num_comorbidities=case_when(healtha_18 == 1 ~ 0,
                                     is.na(num_comorbidities) ~ 0,
                                     T ~ num_comorbidities),
         symptom_loss_smell=case_when(symptnowaw_1==1 ~1,
                                      T ~ 0),
         symptom_loss_taste=case_when(symptnowaw_2==1 ~1,
                                      T ~ 0),
         symptom_cough=case_when(symptnowaw_3==1 ~1,
                                 T ~ 0),
         symptom_fever=case_when(symptnowaw_4==1 ~1,
                                 T ~ 0),
         covid_before=case_when(covida%in%1:3 ~ "Yes",
                                T ~ "No"),
         longcovid=case_when(longcoviddesc==1 ~ 1,
                             T ~ 0),
         pcr_test_result=estbinres,
         survey_date=d_comb,
         shielding=case_when(shield2==1 ~"Yes",
                             T ~"No"),
         vaccinated=case_when(vaccine3sym==1 ~ "Yes",
                              T ~ "No")
  )


# --------------------------------------------------------------------
# Define Covariate and Outcome Columns
# --------------------------------------------------------------------

# Covariate columns
covariate_cols <- c(
  "age", "gender", "bmi", "ethnic_new_char", "imd_decile", "smokeever_cat", "region", "num_comorbidities",
  "work1_healthcare_or_carehome_worker", "shielding", "covid_before", "vaccinated",
  "symptom_loss_smell", "symptom_loss_taste", "symptom_cough", "symptom_fever"
)

# Outcome columns
outcome_cols <- c("pcr_test_result", "longcovid")

# --------------------------------------------------------------------
# Prepare the Data
# --------------------------------------------------------------------

# Filter to just the covariate and outcome columns
dfRes_1 <- dfRes_1[, c(covariate_cols, outcome_cols)]

# Keep complete cases only
dfRes_1 <- dfRes_1[complete.cases(dfRes_1), ]

# Identify continuous and categorical variables
cont_vars <- c("age", "bmi", "imd_decile", "num_comorbidities")
cat_vars <- setdiff(covariate_cols, cont_vars)

# --------------------------------------------------------------------
# Generate Category Probabilities for Categorical Variables
# --------------------------------------------------------------------

category_probabilities <- list()
for (var in cat_vars) {
  dfRes_1[[var]] <- as.factor(dfRes_1[[var]])
  probs <- prop.table(table(dfRes_1[[var]]))
  category_probabilities[[var]] <- as.data.frame(probs)
}

# Save levels of categorical variables
levels_categorical <- lapply(dfRes_1[, cat_vars], levels)

# --------------------------------------------------------------------
# Models to Generate Continuous Variables Conditional on Age
# --------------------------------------------------------------------

# Fit regression models for continuous variables conditional on age

# 1. BMI Model
model_bmi <- lm(bmi ~ age, data = dfRes_1)
coefficients_bmi <- coef(model_bmi)
sd_resid_bmi <- sd(residuals(model_bmi))

# 2. IMD Decile Model
model_imd <- lm(imd_decile ~ age, data = dfRes_1)
coefficients_imd <- coef(model_imd)
sd_resid_imd <- sd(residuals(model_imd))

# 3. Number of Comorbidities Model
model_comorb <- lm(num_comorbidities ~ age, data = dfRes_1)
coefficients_comorb <- coef(model_comorb)
sd_resid_comorb <- sd(residuals(model_comorb))

# --------------------------------------------------------------------
# Models to Generate Outcomes
# --------------------------------------------------------------------

# Fit logistic regression models for the outcomes

# Model for PCR Test Result
mod_1 <- glm(
  pcr_test_result ~ .,
  data = dfRes_1[c(covariate_cols, "pcr_test_result")],
  family = "binomial"
)
coefs_1 <- coef(mod_1)

# Model for Long COVID
mod_2 <- glm(
  longcovid ~ .,
  data = dfRes_1[c(covariate_cols, "longcovid")],
  family = "binomial"
)
coefs_2 <- coef(mod_2)

# --------------------------------------------------------------------
# Export Parameters
# --------------------------------------------------------------------

export_params <- list(
  # Category probabilities for categorical variables
  category_probabilities = category_probabilities,

  # Levels of categorical variables
  levels_categorical = levels_categorical,

  # Coefficients for continuous variable models
  coefficients_bmi = coefficients_bmi,
  sd_resid_bmi = sd_resid_bmi,

  coefficients_imd = coefficients_imd,
  sd_resid_imd = sd_resid_imd,

  coefficients_comorb = coefficients_comorb,
  sd_resid_comorb = sd_resid_comorb,

  # Coefficients for outcome models
  coefs_1 = coefs_1,
  coefs_2 = coefs_2
)

# --------------------------------------------------------------------
# Save Exported Parameters to RDS File
# --------------------------------------------------------------------

saveRDS(export_params, file = "exported_parameters.rds")
