library(shiny)
library(bslib)
library(shinyBS)
library(patchwork)
library(ggplot2)
library(ggiraph)
library(shinyWidgets)
library(tidyverse)
library(stringr)
library(shinyjs)
library(ggtext)
library(gridtext)
library(ggh4x)
library(rsconnect)
library(shinycssloaders)

# current url:  https://h4e5yf-nagat0guled.shinyapps.io/winterpressuresdashboard/

# load model output file
#df <- read.csv("..\\Analysis\\Model_output_for_plots\\plot_model_output.csv")

df <- read.csv("data/dummy_model_output.csv")

uob_red <- "#a6192e"

# map columns in dataset to labels for dashboard

exposure_groups <- list(
  Region = c("Region",
             "East (ref)",
             "East Midlands",
             "London",
             "North East",
             "North West",
             "South East",
             "South West",
             "West Midlands",
             "Yorkshire and The Humber"),
  Rurality = c("Rurality",
               "Urban conurbation (ref)",
               "Urban town",
               "Rural"),
  "Practice list size" = "list_size",
  "Monthly consultation rate (per 1000 patients)" = "cons_mean",
  Age = c("Age",
  "age_0_4",
  "age_65_74",
  "age_75_79",
  "age_80"),
  "Sex: Female" = "sex_female",
  Ethnicity = c("Ethnicity",
  "ethnicity_white",
  "ethnicity_asian",
  "ethnicity_black",
  "ethnicity_mixed",
  "ethnicity_other"),
  Deprivation = c("Deprivation",
  "imd_1_most",
  "imd_5_least"),
  Smoking_Status = c("Smoking Status",
  "smoking_never",
  "smoking_ever",
  "smoking_current"),
  "Obesity" = "obesity",
  "Care home residence" = "carehome"
)

practice_characteristics <- c(
  "Region",
  "East (ref)",
  "East Midlands",
  "London",
  "North East",
  "North West",
  "South East",
  "South West",
  "West Midlands",
  "Yorkshire and The Humber",
  "Rurality",
  "Urban conurbation (ref)",
  "Urban town",
  "Rural",
  "list_size",
  "cons_mean"
)

case_mix <- c(
  "Age" = "Age",
  "age_0_4" = " in the proportion of patients aged under 5 years",
  "age_65_74" = " in the proportion of patients aged 65-74 years",
  "age_75_79" = " in the proportion of patients aged 75 to 79 years",
  "age_80" = " in the proportion of patients aged over 80 years",
  "sex_female" = " in the proportion of female patients",
  "Ethnicity" = "Ethnicity",
  "ethnicity_white" = " in the proportion of white patients",
  "ethnicity_asian" = " in the proportion of asian patients",
  "ethnicity_black" = " in the proportion of black patients",
  "ethnicity_mixed" = " in the proportion of mixed patients",
  "ethnicity_other" = " in the proportion of patients of other ethnicities",
  "Deprivation" = "Deprivation",
  "imd_1_most" = " in the proporton of most deprived patients",
  "imd_5_least" = " in the proportion of least deprived patients",
  "Smoking Status" = "Smoking Status",
  "smoking_never" = " in the proportion of patients who have never smoked",
  "smoking_ever" = " in the proportion of patients who have ever smoked",
  "smoking_current" = " in the proportion of patients who currently smoke",
  "obesity" = " in the proportion of obese patients",
  "carehome" = " in the proportion of patients who are care home residents"
)

exposures_input <- list(
  "Practice characteristics" = c(
    "Region",
    "Rurality",
    "Practice list size",
    "Monthly consultation rate"
  ),
  "Patient case-mix" = c(
    "Age: Under 5 years",
    "Age: 65-74 years",
    "Age: 75-79 years",
    "Age: 80-110 years",
    "Female",
    "Ethnicity: White",
    "Ethnicity: Asian",
    "Ethnicity: Black",
    "Ethnicity: Mixed",
    "Ethnicity: Other",
    "IMD 1 (most deprived)",
    "IMD 5 (least deprived)",
    "Never smoker",
    "Ever smoker",
    "Current smoker",
    "Obesity",
    "Care home residence"
  )
)

exposure_input_lookup <- c(
  "Region" = "Region",
  "Rurality" = "Rurality",
  "Practice list size" = "Practice list size",
  "Monthly consultation rate" = "Monthly consultation rate (per 1000 patients)",
  "Age: Under 5 years" = "Age: Under 5 years",
  "Age: 65-74 years" = "Age: 65-74 years",
  "Age: 75-79 years" = "Age: 75-79 years",
  "Age: 80-110 years" = "Age: 80-110 years",
  "Female" = "Sex: Female",
   "Ethnicity: Mixed" = "Ethnicity: Mixed",
    "Ethnicity: Black" = "Ethnicity: Black",
    "Ethnicity: White" = "Ethnicity: White",
    "Ethnicity: Asian" = "Ethnicity: Asian",
    "Ethnicity: Other" = "Ethnicity: Other",
    "IMD 5 (least deprived)" = "Deprivation: IMD 5 (least deprived)",
    "IMD 1 (most deprived)" = "Deprivation: IMD 1 (most deprived)",
    "Current smoker" = "Smoking Status: Current smoker",
    "Ever smoker" = "Smoking Status: Ever smoker",
    "Never smoker" = "Smoking Status: Never smoker",
    "Obesity" = "Obesity",
    "Care home residence" = "Care home residence"
)

exposure_lookup <- c(
      "Age: Under 5 years" = "age_0_4",
      "Age: 65-74 years" = "age_65_74",
      "Age: 75-79 years" = "age_75_79",
      "Age: 80-110 years" = "age_80",
      "Sex: Female" = "sex_female",
      "Ethnicity: White" = "ethnicity_white",
      "Ethnicity: Asian" = "ethnicity_asian",
      "Ethnicity: Black" = "ethnicity_black",
      "Ethnicity: Mixed" = "ethnicity_mixed",
      "Ethnicity: Other" = "ethnicity_other",
      "Deprivation: IMD 1 (most deprived)" = "imd_1_most",
      "Deprivation: IMD 5 (least deprived)" = "imd_5_least",
      "Smoking Status: Never smoker" = "smoking_never",
      "Smoking Status: Ever smoker" = "smoking_ever",
      "Smoking Status: Current smoker" = "smoking_current",
      "Obesity" = "obesity",
      "Care home residence" = "carehome",
      "Practice list size" = "list_size",
      "Monthly consultation rate (per 1000 patients)" = "cons_mean"
      )

exposure_labels <- c(
  "Region" = "Region",
  "East (ref)" = "East (ref)",
  "East Midlands" = "East Midlands",
  "London" = "London",
  "North East" = "North East",
  "North West" = "North West",
  "South East" = "South East",
  "South West" = "South West",
  "West Midlands" = "West Midlands",
  "Yorkshire and The Humber" = "Yorkshire and The Humber",
  "Rurality" = "Rurality",
  "Urban conurbation (ref)" = "Urban conurbation (ref)",
  "Urban town" = "Urban town",
  "Rural" = "Rural",
  "list_size" = "Practice list size",
  "cons_mean" = "Monthly consultation rate (per 1000 patients)",
  "Age" = "Age",
  "age_0_4" = "Under 5 years (%)",
  "age_65_74" = "65-74 years (%)",
  "age_75_79" = "75-79 years (%)",
  "age_80" = "80-110 years (%)",
  "sex_female" = "Sex: Female",
  "Ethnicity" = "Ethnicity",
  "ethnicity_white" = "White (%)",
  "ethnicity_asian" = "Asian (%)",
  "ethnicity_black" = "Black (%)",
  "ethnicity_mixed" = "Mixed (%)",
  "ethnicity_other" = "Other (%)",
  "Deprivation" = "Deprivation",
  "imd_1_most" = "IMD 1 (most deprived) (%)",
  "imd_5_least" = "IMD 5 (least deprived) (%)",
  "Smoking Status" = "Smoking Status",
  "smoking_never" = "Never smoker (%)",
  "smoking_ever" = "Ever smoker (%)",
  "smoking_current" = "Current smoker (%)",
  "obesity" = "Obesity",
  "carehome" = "Care home residence"
)

time_periods <- c(
  "precovid" = "Pre-Covid",
  "postcovid1" = "2022-2023",
  "postcovid2" = "2023-2024",
  "postcovid3" = "2024-2025"
)
exposures <- list(
  "Practice characteristics" = c(
    "Region: East (ref)", "Region: East Midlands",
    "Region: London", "Region: South East",
    "Region: North East", "Region: North West",
    "Region: South West", "Region: West Midlands",
    "Region: Yorkshire and The Humber",
    "Practice list size",
    "Monthly consultation rate (per 1000 patients)",
    "Rurality: Urban conurbation (ref)",
    "Rurality: Urban town",
    "Rurality: Rural"
  ),
  "Patient case-mix" = c(
    "Age: Under 5 years",
    "Age: 65-74 years",
    "Age: 75-79 years",
    "Age: 80-110 years",
    "Sex: Female",
    "Ethnicity: Mixed",
    "Ethnicity: Black",
    "Ethnicity: White",
    "Ethnicity: Asian",
    "Ethnicity: Other",
    "Deprivation: IMD 5 (least deprived)",
    "Deprivation: IMD 1 (most deprived)",
    "Smoking Status: Current smoker",
    "Smoking Status: Ever smoker",
    "Smoking Status: Never smoker",
    "Obesity",
    "Care home residence"
  )
)

outcome_raw <- c(
  "apc",
  "apc_plan",
  "apc_unpl",
  "apc_acsc_any",
  "apc_plan_acsc_any",
  "apc_unpl_acsc_any",
  "ec",
  "ec_acsc_any"
)

outcome_interpretation <- c(
  "apc" = "weekly admitted patient care",
  "apc_plan" = "weekly planned admitted patient care",
  "apc_unpl" = "weekly unplanned admitted patient care",
  "apc_acsc_any" = "weekly ACSC-related admitted patient care",
  "apc_plan_acsc_any" = "weekly ACSC-related planned admitted patient care",
  "apc_unpl_acsc_any" = "weekly ACSC-related unplanned admitted patient care",
  "ec" = "weekly A&E attendances",
  "ec_acsc_any" = "weekly ACSC-related admitted patient care"
)


outcome_titles <- c(
  "Weekly hospital admissions",
  "Weekly A&E attendances",
  "Weekly planned hospital admissions",
  "Weekly unplanned hospital admissions",
  "Weekly ACSC-related hospital admissions",
  "Weekly ACSC-related A&E attendences",
  "Weekly ACSC-related planned hospital admissions",
  "Weekly ACSC-related unplanned hospital admissions"
)

sub_groups <- c(
  "main" = "All",
  "sub_asth" = "Sub-group: Asthma",
  "sub_diab" = "Sub-group: Diabetes",
  "sub_copd" = "Sub-group: COPD",
  "sub_htn" = "Sub-group: Hypertension",
  "sub_sevmh" = "Sub-group: Severe mental health"
)

models <- c(
  "mdl_crude" = "Crude",
  "mdl_age_sex" = "Age- and sex-adjusted",
  "mdl_mut_adj" = "Fully adjusted"
)

probdists <- c(
  "negbin" = "Negative binomial",
  "poisson" = "Poisson"
)

cohort_interp <- c(
  "precovid" = "before COVID-19",
  "postcovid1" = "in 2022-2023",
  "postcovid2" = "in 2023-2024",
  "postcovid3" = "in 2024-2025"
)