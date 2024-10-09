

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



# covariates
covariate_cols <- c("age","gender","bmi","ethnic_new_char","imd_decile","smokeever_cat","region","num_comorbidities",
                    "work1_healthcare_or_carehome_worker","shielding","covid_before","vaccinated",
                    "symptom_loss_smell","symptom_loss_taste","symptom_cough","symptom_fever")

outcome_cols <- c("pcr_test_result","longcovid")

# filter to just these vars
dfRes_1 <- dfRes_1[,c(covariate_cols,outcome_cols)]

# complete cases only
dfRes_1 <- dfRes_1[complete.cases(dfRes_1),]

# continuous / categorical
cont_vars=c("age","bmi","imd_decile","num_comorbidities")
cat_vars=setdiff(covariate_cols,cont_vars)

# get means
means_cont=colMeans(dfRes_1[,cont_vars])
cov_matrix=cov(dfRes_1[,cont_vars])

# cat probabilities
category_probabilities <- list()
for(var in cat_vars){
  dfRes_1[[var]] <- as.factor(dfRes_1[[var]])
  probs <- prop.table(table(dfRes_1[[var]]))
  category_probabilities[[var]] <- as.data.frame(probs)
}

dfRes_1$pcr_test_result

# Models to generate outcomes ---------------------------------------------

# fit models
mod_1 <- glm(as.formula("pcr_test_result ~ ."),data=dfRes_1[c(covariate_cols,"pcr_test_result")], family="binomial")
mod_2 <- glm(as.formula("longcovid ~ ."),data=dfRes_1[c(covariate_cols,"longcovid")], family="binomial")

# get coefs
coefs_1=coef(mod_1)
coefs_2=coef(mod_2)

export_params=list(means_continuous=means_cont,
                   cov_matrix=cov_matrix,
                   category_probabilities=category_probabilities,
                   coefs_1=coefs_1,
                   coefs_2=coefs_2,
                   levels_categorical=lapply(dfRes_1[,cat_vars],levels))


saveRDS(export_params,file = "exported_parameters.rds")
