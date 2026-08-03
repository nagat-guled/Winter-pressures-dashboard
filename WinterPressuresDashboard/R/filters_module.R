# create panel containing widgets for user selection
filters <- function(id) {
  card(
    virtualSelectInput(
      paste0("selected_exposures", id),
      "Select exposures:",
      choices = exposures_input,
      selected = if (id == 3) {
        unlist(exposures_input, use.names = FALSE)
      } else {
        exposures_input[["Patient case-mix"]]
      },
      multiple = TRUE,
      search = TRUE,
      dropboxWrapper = "body"
    ),
    selectInput(
      paste0("subgroup", id),
      "Select population sub-group:",
      choices = unname(sub_groups),
      selected = sub_groups[[1]]
    ),
    selectInput(
      paste0("model", id),
      label = tagList("Select adjustment model:",
        tooltip(
          icon("circle-info", style = "color: #a6192e"),
          "Choose between no adjustment and age- and sex-adjusted.",
          placement = "right"
        )
      ),
      choices = if(id != 3) {
        unname(models[1:2])
      } else{
        unname(models)
      },
      selected = if(id != 3) {
        models[[2]]
      } else {
        models[[3]]
      }
    ),
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
          icon = icon("check")
        )
      ),
    ),
    checkboxGroupButtons(
      paste0("time", id),
      "Select time periods:",
      choices = unname(time_periods),
      selected = unname(time_periods[c(1, 4)]),
      size = "sm"
    ),
    fill = TRUE,
  )
}