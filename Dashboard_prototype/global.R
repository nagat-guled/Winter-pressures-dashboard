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
  "Urban conurbation (ref)" = "Rurality: Urban conurbation",
  "Urban town" = "Rurality: Urban Town",
  "Rural" = "Rurality: Rural",
  "practice_region" = "Practice region",
  "list_size" = "Practice list size",
  "cons_mean" = "Monthly consultation rate",
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
    "Monthly Consultation rate (per 100 patients)",
    "Practice Rurality: Urban conurbation (ref)",
    "Practice Rurality: Urban town",
    "Practice Rurality: Rural"
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
    "Rurality",
    "Smoking Status: Current smoker",
    "Smoking Status: Ever smoker",
    "Smoking Status: Never smoker",
    "Obesity",
    "Care home residence"
  )
)

outcome_raw <- c(
  "apc_main",
  "apc_plan_main",
  "apc_unpl_main",
  "apc_acsc_any_main",
  "apc_plan_acsc_any_main",
  "apc_unpl_acsc_any_main",
  "ec_main",
  "ec_acsc_any_main"
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
  "All",
  "Sub-group: Asthma",
  "Sub-group: Diabetes",
  "Sub-group: COPD",
  "Sub-group: Hypertension",
  "Sub-group: Severe mental health"
)

models <- c(
  "Crude",
  "Age-sex adjusted",
  "Fully-adjusted"
)

filters_button <- function(id) {
  dropdownButton(
    virtualSelectInput(
      "exposures",
      "Select Exposures: ",
      choices = exposures,
      selected = unlist(exposures, use.names = FALSE),
      multiple = TRUE,
      search = TRUE,
      dropboxWrapper = "body"
    ),
    selectInput(
      "subgroup",
      "Select Sub-groups of the Population",
      choices = sub_groups,
      selected = sub_groups[[1]]
    ),
    selectInput(
      "model",
      label = tagList("Select Model:",
        tooltip(
          icon("circle-info", style = "color: #a6192e"),
          "Choose between no adjustment, age/sex adjusted and fully adjusted values.",
          placement = "right"
        )
      ),
      choices = models,
      selected = models[[2]]
    ),
    tags$div(
      style = "display: flex;",
      tags$div(
        prettyRadioButtons(
          "probdist",
          label = "Select probability distribution:",
          choices = c("Negative binomial", "Poisson"),
          outline = TRUE,
          plain = TRUE,
          status = 'primary',
          icon = icon("check")
        )
      ),
    ),
    checkboxGroupButtons(
      "time",
      "Select Time Periods:",
      choices = time_periods,
      selected = time_periods
    ),
    circle = FALSE,
    status = "primary",
    icon = icon("filter"),
    width = "600px"
  )
}