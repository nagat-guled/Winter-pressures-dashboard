library(shiny)
library(bslib)
library(shinyBS)
library(patchwork)
library(ggplot2)
library(ggiraph)
library(shinyWidgets)

time_periods <- c(
  "Pre-Covid",
  "Post-Lockdown 1",
  "Post-Lockdown 2",
  "Post-Lockdown 3"
)
exposures <- list(
  "Practice characteristics" = c(
    "Practice region",
    "Practice list size",
    "Monthly Consultation rate",
    "Practice Rurality"
  ),
  "Patient case-mix" = c(
    "Age",
    "Sex",
    "Ethnicity",
    "Deprivation",
    "Rurality",
    "Smoking",
    "Obesity",
    "Comorbidities",
    "Vaccinations"
  )
)

filters_card <- function(id) {
  ns <- NS(id)
  card(
    height = "400px",
    selectInput(
      ns("outcome"),
      tagList(icon("chart-line"), "Select Outcome:"),
      choices = NULL
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
      "Select Sub-groups",
      choices = NULL
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
      choices = NULL
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