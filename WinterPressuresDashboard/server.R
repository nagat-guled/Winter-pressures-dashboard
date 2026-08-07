server <- function(id, input, output) {

  output$plot1 <- renderGirafe({
    plots <- list()
    for (x in c(1, 7, 2, 3)){
      p1 <- plot_graph(
        x,
        input$subgroup1,
        input$selected_exposures1,
        input$model1,
        input$probdist1,
        input$time1,
        1
      )

      plots[[x]] <- p1$plot
      order_exposures <- p1$order_exposures
    }
    # design plot layout for all 8 outcomes
   

    row1 <- (plots[[1]] | plot_spacer() | plots[[7]]) +
    plot_layout(widths = c(4, 0.4, 4))

    row3 <- (plots[[2]] | plot_spacer() | plots[[3]]) +
    plot_layout(widths = c(4, 0.4, 4))

    combined_plot1 <- row1 / plot_spacer() / row3 +
    plot_layout(heights = unit(c(1, 2, 1), c("null", "cm", "null")))

    make_girafe(combined_plot1, 1, order_exposures)

  })

  output$plot2 <- renderGirafe({
    plots2 <- list()
    for (x in c(4, 8, 5, 6)){
      p2 <- plot_graph(
        x,
        input$subgroup2,
        input$selected_exposures2,
        input$model2,
        input$probdist2,
        input$time2,
        2
      )

      plots2[[x]] <- p2$plot
      order_exposures <- p2$order_exposures
    }
    # design plot layout for all 8 outcomes
  row1 <- (plots2[[4]] | plot_spacer() | plots2[[8]]) +
  plot_layout(widths = c(4, 0.4, 4))

  row3 <- (plots2[[5]] | plot_spacer() | plots2[[6]]) +
  plot_layout(widths = c(4, 0.4, 4))

  combined_plot2 <- row1 / plot_spacer() / row3 +
  plot_layout(heights = unit(c(1, 2, 1), c("null", "cm", "null")))

    make_girafe(combined_plot2, 2, order_exposures)
  })

  output$plot3 <- renderGirafe({
    plots3 <- list()
    for (x in 1:8){
      p3 <- plot_graph(
        x,
        input$subgroup3,
        unlist(exposures_input),
        models[3],
        input$probdist3,
        input$time3,
        3
      )

      plots3[[x]] <- p3$plot
      order_exposures <- p3$order_exposures
    }
    # design plot layout for all 8 outcomes

        row1 <- (plots3[[1]] | plot_spacer() | plots3[[4]]) +
  plot_layout(widths = c(4, 0.4, 4))

  row3 <- (plots3[[2]] | plot_spacer() | plots3[[5]]) +
  plot_layout(widths = c(4, 0.4, 4))

  row5 <- (plots3[[3]] | plot_spacer() | plots3[[6]]) +
  plot_layout(widths = c(4, 0.4, 4))

  row7 <- (plots3[[7]] | plot_spacer() | plots3[[8]]) +
  plot_layout(widths = c(4, 0.4, 4))

  combined_plot3 <- row1 / plot_spacer() /
  row3 / plot_spacer() /
  row5 / plot_spacer() / row7 +
  plot_layout(heights = unit(c(1, 2, 1, 2, 1, 2, 1),
                              c("null", "cm", "null", "cm", "null", "cm", "null")))
      
    make_girafe(combined_plot3, 3, order_exposures)
  })

  options(error = function() {
  print(sys.calls())
})

}
