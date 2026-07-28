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

# load model output file
df <- read.csv("..\\Analysis\\Model_output_for_plots\\plot_model_output.csv")

uob_red <- "#a6192e"

# map columns in dataset to labels for dashboard

exposure_groups <- list(
  Region = c("East (ref)",
             "East Midlands",
             "London",
             "North East",
             "North West",
             "South East",
             "South West",
             "West Midlands",
             "Yorkshire and The Humber"),
  Rurality = c("Urban conurbation (ref)",
               "Urban town",
               "Rural"),
  "Practice list size" = "list_size",
  "Monthly consultation rate (per 1000 patients)" = "cons_mean",
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
  "Care home residence" = "carehome"
)

case_mix <- c(
  "age_0_4" = "1.1% in the proportion of patients aged under 5 years",
  "age_65_74" = "3.4% in the proportion of patients aged 65-74 years",
  "age_75_79" = "1.7% in the proportion of patients aged 75 to 79 years",
  "age_80" = "2.2% in the proportion of patients aged over 80 years",
  "sex_female" = "1.2% in the proportion of female patients",
  "ethnicity_white" = "10.9% in the proportion of white patients",
  "ethnicity_asian" = "3% in the proportion of asian patients",
  "ethnicity_black" = "1.4% in the proportion of black patients",
  "ethnicity_mixed" = "1.1% in the proportion of mixed patients",
  "ethnicity_other" = "1.1% in the proportion of patients of other ethnicities",
  "imd_1_most" = "15.1% in the proporton of most deprived patients",
  "imd_5_least" = "11.3% in the proportion of least deprived patients", 
  "smoking_never" = "5.6% in the proportion of patients who have never smoked",
  "smoking_ever" = "5% in the proportion of patients who have ever smoked",
  "smoking_current" = "4% in the proportion of patients who currently smoke",
  "obesity" = "4.2% in the proportion of obese patients",
  "carehome" = "0.4% in the proportion of patients who are care home residents"
)

exposures_input <- list(
  "Practice characteristics" = c(
    "Region",
    "Rurality",
    "Practice list size",
    "Monthly consultation rate (per 1000 patients)"
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

exposure_labels <- c(
  "East (ref)" = "Region: East (ref)",
  "East Midlands" = "Region: East Midlands",
  "London" = "Region: London",
  "North East" = "Region: North East",
  "North West" = "Region: North West",
  "South East" = "Region: South East",
  "South West" = "Region: South West",
  "West Midlands" = "Region: West Midlands",
  "Yorkshire and The Humber" = "Region: Yorkshire and The Humber",
  "Urban conurbation (ref)" = "Rurality: Urban conurbation (ref)",
  "Urban town" = "Rurality: Urban town",
  "Rural" = "Rurality: Rural",
  "list_size" = "Practice list size",
  "cons_mean" = "Monthly consultation rate (per 1000 patients)",
  "age_0_4" = "Age: Under 5 years (%)",
  "age_65_74" = "Age: 65-74 years (%)",
  "age_75_79" = "Age: 75-79 years (%)",
  "age_80" = "Age: 80-110 years (%)",
  "sex_female" = "Sex: Female (%)",
  "ethnicity_white" = "Ethnicity: White (%)",
  "ethnicity_asian" = "Ethnicity: Asian (%)",
  "ethnicity_black" = "Ethnicity: Black (%)",
  "ethnicity_mixed" = "Ethnicity: Mixed (%)",
  "ethnicity_other" = "Ethnicity: Other (%)",
  "imd_1_most" = "Deprivation: IMD 1 (most deprived) (%)",
  "imd_5_least" = "Deprivation: IMD 5 (least deprived) (%)",
  "smoking_never" = "Smoking Status: Never smoker (%)",
  "smoking_ever" = "Smoking Status: Ever smoker (%)",
  "smoking_current" = "Smoking Status: Current smoker (%)",
  "obesity" = "Obesity (%)",
  "carehome" = "Care home residence (%)"
)

time_periods <- c(
  "precovid" = "Pre-Covid",
  "postcovid1" = "Post-Lockdown 1",
  "postcovid2" = "Post-Lockdown 2",
  "postcovid3" = "Post-Lockdown 3"
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
  "apc_",
  "apc_plan_",
  "apc_unpl_",
  "apc_acsc_any_",
  "apc_plan_acsc_any_",
  "apc_unpl_acsc_any_",
  "ec_",
  "ec_acsc_any_"
)

outcome_interpretation <- c(
  "apc_" = "weekly admitted patient care",
  "apc_plan_" = "weekly planned admitted patient care",
  "apc_unpl_" = "weekly unplanned admitted patient care",
  "apc_acsc_any_" = "weekly ACSC-related admitted patient care",
  "apc_plan_acsc_any_" = "weekly ACSC-related planned admitted patient care",
  "apc_unpl_acsc_any_" = "weekly ACSC-related unplanned admitted patient care",
  "ec_" = "weekly A&E attendances",
  "ec_acsc_any_" = "weekly ACSC-related admitted patient care"
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
  "mdl_max_adj" = "Fully adjusted"
)

probdists <- c(
  "negbin" = "Negative binomial",
  "poisson" = "Poisson"
)

cohort_interp <- c(
  "precovid" = "before COVID-19",
  "postcovid1" = "post-lockdown 1",
  "postcovid2" = "post-lockdown 2",
  "postcovid3" = "post-lockdown 3"
)
