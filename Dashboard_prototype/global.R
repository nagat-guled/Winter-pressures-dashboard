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
  "rurality_urban_comb" = "Rurality: Urban conurbation",
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
     "Region: London", "Region: North East", "Region: South East",
     "Region: South West", "Region: West Midlands", "Region: Yorkshire and The Humber",
    "Practice list size",
    "Monthly Consultation rate (per 100 patients)",
    "Practice Rurality: Urban conurbation"
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

outcomes <- c(
  "Admitted patient care (all)",
  "Admitted patient care (ACSC admissions)",
  "Unplanned admitted patient care (all)",
  "Unplanned admitted patient care (ACSC admissions)",
  "Planned admitted patient care (all)",
  "Planned admitted patient care (ACSC admissions)",
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

filters_card <- function(id) {
  ns <- NS(id)
  card(
    height = "400px",
    selectInput(
      ns("outcome"),
      tagList(icon("chart-line"), "Select Outcome:"),
      choices = outcomes,
      selected = outcomes[[id]],
    ),
    virtualSelectInput(
      ns("exposures"),
      "Select Exposures: ",
      choices = exposures,
      selected = unlist(exposures, use.names = FALSE),
      multiple = TRUE,
      search = TRUE,
      dropboxWrapper = "body"
    ),
    selectInput(
      ns("subgroup"),
      "Select Sub-groups of the Population",
      choices = sub_groups,
      selected = sub_groups[[1]]
    ),
    selectInput(
      ns("model"),
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
        prettyToggle(
          ns("probdist"),
          label_on = "Poisson",
          label_off = "Negative Binomial",
          status_on = "primary",
          status_off = "default"
        )
      ),
      tags$span(
        tooltip(
          icon("circle-info",
            style = "color: #a6192e; margin-left: -150px;"
          ),
        "Select preferred probability distribution",
        placement = "right"
      )
    )
    ),
    checkboxGroupButtons(
      ns("time"),
      "Select Time Periods:",
      choices = time_periods,
      selected = time_periods
    )
  )
}