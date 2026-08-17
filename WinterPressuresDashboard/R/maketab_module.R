make_tab <- function(title, id, plotname){
  filter_width <- 3
  plot_width <- 9
  nav_panel(
    title,
    fluidRow(
      column(
        filter_width,
        filters(id)
      ),
      column(
        plot_width,
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