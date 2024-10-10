

exported_parameters = list(
  category_probabilities = list(
    gender = structure(
      list(
        Var1 = structure(1:2, levels = c("1", "2"), class = "factor"),
        Freq = c(0.434019410316175, 0.565980589683825)
      ),
      class = "data.frame",
      row.names = c(NA, -2L)
    ),
    ethnic_new_char = structure(
      list(
        Var1 = structure(
          1:6,
          levels = c(
            "White",
            "Asian / Asian British",
            "Black / African / Caribbean / Black British",
            "Mixed",
            "Other",
            "NA"
          ),
          class = "factor"
        ),
        Freq = c(
          0.889003015578293,
          0.0547676424498611,
          0.0127865787013261,
          0.0157758200661057,
          0.00851999631283003,
          0.019146946891584
        )
      ),
      class = "data.frame",
      row.names = c(NA, -6L)
    ),
    smokeever_cat = structure(
      list(
        Var1 = structure(
          1:4,
          levels = c(
            "Current cigarette smoker",
            "Former cigarette smoker",
            "Never cigarette smoker",
            "Prefer not to say"
          ),
          class = "factor"
        ),
        Freq = c(
          0.0656974677043416,
          0.326814943573131,
          0.598282832273272,
          0.00920475644925532
        )
      ),
      class = "data.frame",
      row.names = c(NA, -4L)
    ),
    region = structure(
      list(
        Var1 = structure(
          1:9,
          levels = c(
            "South East",
            "North East",
            "North West",
            "Yorkshire and The Humber",
            "East Midlands",
            "West Midlands",
            "East of England",
            "London",
            "South West"
          ),
          class = "factor"
        ),
        Freq = c(
          0.171993310420206,
          0.0464846784919475,
          0.121531755751327,
          0.09885566046432,
          0.089242681626042,
          0.102555998893849,
          0.110931142100897,
          0.150607724621077,
          0.107797047630335
        )
      ),
      class = "data.frame",
      row.names = c(NA, -9L)
    ),
    work1_healthcare_or_carehome_worker = structure(
      list(
        Var1 = structure(1:2, levels = c("No", "Yes"), class = "factor"),
        Freq = c(0.915287270045695, 0.0847127299543054)
      ),
      class = "data.frame",
      row.names = c(NA, -2L)
    ),
    shielding = structure(
      list(
        Var1 = structure(1:2, levels = c("No", "Yes"), class = "factor"),
        Freq = c(0.776741858597032, 0.223258141402968)
      ),
      class = "data.frame",
      row.names = c(NA, -2L)
    ),
    covid_before = structure(
      list(
        Var1 = structure(1:2, levels = c("No", "Yes"), class = "factor"),
        Freq = c(0.628807332200845, 0.371192667799155)
      ),
      class = "data.frame",
      row.names = c(NA, -2L)
    ),
    vaccinated = structure(
      list(
        Var1 = structure(1:2, levels = c("No", "Yes"), class = "factor"),
        Freq = c(0.0395844032710465, 0.960415596728953)
      ),
      class = "data.frame",
      row.names = c(NA, -2L)
    ),
    symptom_loss_smell = structure(
      list(
        Var1 = structure(1:2, levels = c("0", "1"), class = "factor"),
        Freq = c(0.988122045325854, 0.0118779546741464)
      ),
      class = "data.frame",
      row.names = c(NA, -2L)
    ),
    symptom_loss_taste = structure(
      list(
        Var1 = structure(1:2, levels = c("0", "1"), class = "factor"),
        Freq = c(0.987345105940294, 0.0126548940597058)
      ),
      class = "data.frame",
      row.names = c(NA, -2L)
    ),
    symptom_cough = structure(
      list(
        Var1 = structure(1:2, levels = c("0", "1"), class = "factor"),
        Freq = c(0.958124283964761, 0.0418757160352388)
      ),
      class = "data.frame",
      row.names = c(NA, -2L)
    ),
    symptom_fever = structure(
      list(
        Var1 = structure(1:2, levels = c("0", "1"), class = "factor"),
        Freq = c(0.972886132290391, 0.027113867709609)
      ),
      class = "data.frame",
      row.names = c(NA, -2L)
    )
  ),
  levels_categorical = list(
    gender = c("1", "2"),
    ethnic_new_char = c(
      "White",
      "Asian / Asian British",
      "Black / African / Caribbean / Black British",
      "Mixed",
      "Other",
      "NA"
    ),
    smokeever_cat = c(
      "Current cigarette smoker",
      "Former cigarette smoker",
      "Never cigarette smoker",
      "Prefer not to say"
    ),
    region = c(
      "South East",
      "North East",
      "North West",
      "Yorkshire and The Humber",
      "East Midlands",
      "West Midlands",
      "East of England",
      "London",
      "South West"
    ),
    work1_healthcare_or_carehome_worker = c("No", "Yes"),
    shielding = c("No", "Yes"),
    covid_before = c("No", "Yes"),
    vaccinated = c("No", "Yes"),
    symptom_loss_smell = c("0", "1"),
    symptom_loss_taste = c("0", "1"),
    symptom_cough = c("0", "1"),
    symptom_fever = c("0", "1")
  ),
  coefficients_bmi = c(`(Intercept)` = 25.6864493232514, age = 0.0181305700264722),
  sd_resid_bmi = 5.43954820404603,
  coefficients_imd = c(`(Intercept)` = 4.87097325836338, age = 0.026562729768765),
  sd_resid_imd = 2.67173978044842,
  coefficients_comorb = c(`(Intercept)` = 0.223845355124387, age = 0.00921786992930663),
  sd_resid_comorb = 0.995983613139344,
  coefs_1 = c(
    `(Intercept)` = -4.0893183841048,
    age = 0.00372961104428701,
    gender2 = -0.0138180174672479,
    bmi = -0.00497661171502826,
    `ethnic_new_charAsian / Asian British` = 0.00496762326632009,
    `ethnic_new_charBlack / African / Caribbean / Black British` = -0.0127873994865558,
    ethnic_new_charMixed = -0.0955636456941487,
    ethnic_new_charOther = 0.0864593929662309,
    ethnic_new_charNA = -0.00533907444448902,
    imd_decile = 0.0175379159456027,
    `smokeever_catFormer cigarette smoker` = 0.0247786615330025,
    `smokeever_catNever cigarette smoker` = 0.0561585789014505,
    `smokeever_catPrefer not to say` = 0.226267465755139,
    `regionNorth East` = -0.199190286268388,
    `regionNorth West` = -0.0779791183962907,
    `regionYorkshire and The Humber` = -0.158479728565894,
    `regionEast Midlands` = -0.101460756650116,
    `regionWest Midlands` = -0.18682190356684,
    `regionEast of England` = 0.0286668319448777,
    regionLondon = -0.0954799014455479,
    `regionSouth West` = 0.215423559395443,
    num_comorbidities = -0.100246853843648,
    work1_healthcare_or_carehome_workerYes = -0.0894463625221439,
    shieldingYes = -0.0313255076563607,
    covid_beforeYes = 1.31126735799542,
    vaccinatedYes = 0.27301512078026,
    symptom_loss_smell1 = 0.455845683553724,
    symptom_loss_taste1 = 1.13849227143364,
    symptom_cough1 = 2.07433461663068,
    symptom_fever1 = 1.82415213504647
  ),
  coefs_2 = c(
    `(Intercept)` = -22.6989616926306,
    age = 0.00195741554316273,
    gender2 = 0.160426248642766,
    bmi = 0.0290991992158739,
    `ethnic_new_charAsian / Asian British` = -0.194993610612439,
    `ethnic_new_charBlack / African / Caribbean / Black British` = -0.599442143738714,
    ethnic_new_charMixed = 0.0321756799812457,
    ethnic_new_charOther = -0.114007595614606,
    ethnic_new_charNA = 0.180015794703082,
    imd_decile = -0.0139510739245894,
    `smokeever_catFormer cigarette smoker` = 0.0798998022608269,
    `smokeever_catNever cigarette smoker` = 0.0265341550239069,
    `smokeever_catPrefer not to say` = 0.271807617222575,
    `regionNorth East` = 0.296482323780186,
    `regionNorth West` = 0.0697516776983835,
    `regionYorkshire and The Humber` = 0.0768490038546267,
    `regionEast Midlands` = 0.0325816370002303,
    `regionWest Midlands` = 0.0572693657115019,
    `regionEast of England` = 0.14057931856499,
    regionLondon = -0.072826031072395,
    `regionSouth West` = -0.0108524131327488,
    num_comorbidities = 0.194727160246178,
    work1_healthcare_or_carehome_workerYes = 0.240914249620291,
    shieldingYes = 0.845664622873782,
    covid_beforeYes = 19.1395523032178,
    vaccinatedYes = -0.347313403511538,
    symptom_loss_smell1 = 0.851813421248775,
    symptom_loss_taste1 = 0.421969583713704,
    symptom_cough1 = -0.334694752494425,
    symptom_fever1 = -0.42686934513619
  )
)
