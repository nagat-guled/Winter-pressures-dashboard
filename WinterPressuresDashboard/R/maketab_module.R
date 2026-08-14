make_tab <- function(title, id, plotname){
      nav_panel(
    title,
    fluidRow(
      column(
        3,
        filters(id)
      ),
      column(
        9,
        card(
          withSpinner(
          girafeOutput(
            plotname,
            width = "100%"
          )
          )
        ),
      )
    )
  )
}