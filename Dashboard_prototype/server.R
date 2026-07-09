plot_graph <- function(){
  ggplot() +
    theme(
      panel.background = element_rect(
        fill = "white"
      ),
    )
}

server <- function(input, output) {
  output$plot <- renderGirafe({
    p1 <- plot_graph()
    p2 <- plot_graph()
    combined_plot <- p1 + p2 + plot_layout(ncol = 2)
    girafe(
      ggobj = combined_plot
    )
  })
}
