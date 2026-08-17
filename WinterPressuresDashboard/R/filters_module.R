# create panel containing widgets for user selection
filters <- function(id) {
  card(
    class = "filters-card",
    if (id != 3){
      pickerInput(
        paste0("selected_exposures", id),
        "Select practice-level characteristics:",
        choices = exposures_input,
        selected = c("Practice list size",
          "Monthly consultation rate",
          "Female", "Obesity"
        ),
        multiple = TRUE,
        width = "95%",
        options = list(size = 10, `tick-icon` = "", `actions-box` = TRUE)
      )
    },
    selectInput(
      paste0("subgroup", id),
      "Select population sub-group:",
      choices = unname(sub_groups),
      selected = sub_groups[[1]],
      width = "90%"
    ),
    if (id != 3){
      selectInput(
        paste0("model", id),
        label = tagList("Select adjustment model:",
          tooltip(
            icon("circle-info", style = "color: #a6192e"),
            "Choose between no adjustment and age- and sex-adjusted.",
            placement = "right"
          )
        ),
        choices = unname(models[1:2]),
        selected = models[[2]],
        width = "90%"
      )
    },
    tags$div(
      style = "display: flex;",
      tags$div(
        prettyRadioButtons(
          paste0("probdist", id),
          label = "Select probability distribution:",
          choices = unname(probdists),
          outline = TRUE,
          plain = TRUE,
          status = 'primary',
          icon = icon("check"),
          width = "100%"
        )
      ),
    ),
    checkboxGroupButtons(
      paste0("time", id),
      "Select time periods:",
      choices = unname(time_periods),
      selected = unname(time_periods[c(1, 4)]),
      size = "sm",
      width = "90%"
    ),
    height = ifelse(
      id == 3,
      "350px",
      "520px"
    )
  )
}