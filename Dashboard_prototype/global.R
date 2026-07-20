library(shiny)
library(bslib)
library(shinyBS)
library(patchwork)
library(ggplot2)
library(ggiraph)
library(shinyWidgets)
library(tidyverse)

# load model output file
df <- read.csv("..\\Analysis\\Model_output_for_plots\\plot_model_output.csv")

# map columns in dataset to labels for dashboard

exposure_labels <- c(
  "East (ref)" = "Region: East (ref)",
  "East Midlands" = "Region: East Midlands",
  "South East" = "Region: South East",
  "London" = "Region: London",
  "North East" = "Region: North East",
  "North West" = "Region: North West",
  "South West" = "Region: South West",
  "West Midlands" = "Region: West Midlands",
  "Yorkshire and The Humber" = "Region: Yorkshire and The Humber",
  "Urban conurbation (ref)" = "Rurality: Urban conurbation (ref)",
  "Urban town" = "Rurality: Urban town",
  "Rural" = "Rurality: Rural",
  "list_size" = "Practice list size",
  "cons_mean" = "Monthly consultation rate (per 1000 patients)",
  "imd_5_least" = "Deprivation: IMD 5 (least deprived)",
  "imd_1_most" = "Deprivation: IMD 1 (most deprived)",
  "obesity" = "Obesity",
  "smoking_never" = "Smoking Status: Never smoker",
  "smoking_ever" = "Smoking Status: Ever smoker",
  "smoking_current" = "Smoking Status: Current smoker",
  "sex_female" = "Sex: Female",
  "ethnicity_white" = "Ethnicity: White",
  "ethnicity_other" = "Ethnicity: Other",
  "ethnicity_mixed" = "Ethnicity: Mixed",
  "ethnicity_black" = "Ethnicity: Black",
  "ethnicity_asian" = "Ethnicity: Asian",
  "carehome" = "Care home residence",
  "age_80" = "Age: 80-110 years",
  "age_75_79" = "Age: 75-79 years",
  "age_65_74" = "Age: 65-74 years",
  "age_0_4" = "Age: Under 5 years"
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

outcome_titles <- c(
  "Admitted patient care (all)",
  "Planned admitted patient care (all)",
  "Unplanned admitted patient care (all)",
  "Admitted patient care (ACSC admissions)",
  "Planned admitted patient care (ACSC admissions)",
  "Unplanned admitted patient care (ACSC admissions)",
  "Emergency care (all)",
  "Emergency care (ACSC attendances)"
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
  "mdl_age_sex" = "Age-sex adjusted",
  "mdl_max_adj" = "Fully adjusted"
)

probdists <- c(
  "negbin" = "Negative binomial",
  "poisson" = "Poisson"
)

# create panel containing widgets for user selection

filters <- function() {
  absolutePanel(
    id = "panel",
    virtualSelectInput(
      "selected_exposures",
      "Select exposures:",
      choices = exposures,
      selected = exposures[["Patient case-mix"]],
      multiple = TRUE,
      search = TRUE,
      dropboxWrapper = "body"
    ),
    selectInput(
      "subgroup",
      "Select population sub-group:",
      choices = unname(sub_groups),
      selected = sub_groups[[1]]
    ),
    selectInput(
      "model",
      label = tagList("Select model:",
        tooltip(
          icon("circle-info", style = "color: #a6192e"),
          "Choose between no adjustment, age/sex adjusted and fully adjusted results.",
          placement = "right"
        )
      ),
      choices = unname(models),
      selected = models[[2]]
    ),
    tags$div(
      style = "display: flex;",
      tags$div(
        prettyRadioButtons(
          "probdist",
          label = "Select probability distribution:",
          choices = unname(probdists),
          outline = TRUE,
          plain = TRUE,
          status = 'primary',
          icon = icon("check")
        )
      ),
    ),
    checkboxGroupButtons(
      "time",
      "Select time periods:",
      choices = time_periods,
      selected = time_periods
    ),
    draggable = TRUE,
    width = "550px",
    height = "400px",
    style = "background-color: white;",
    left = "30%"
  )
}