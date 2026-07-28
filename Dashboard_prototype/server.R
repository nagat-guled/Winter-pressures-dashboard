server <- function(id, input, output) {

  output$plot1 <- renderGirafe({
    plots <- list()
    for (x in 1:4){
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
    combined_plot1 <- (plots[[1]] | plots[[2]]) /
      (plots[[3]] | plots[[4]])

    make_girafe(combined_plot1, 1, order_exposures)

  })

  output$plot2 <- renderGirafe({
    plots2 <- list()
    for (x in 5:8){
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
    combined_plot2 <- (plots2[[5]] | plots2[[6]]) /
      (plots2[[7]] | plots2[[8]])

    make_girafe(combined_plot2, 2, order_exposures)
  })

  output$plot3 <- renderGirafe({
    plots3 <- list()
    for (x in 1:8){
      p3 <- plot_graph(
        x,
        input$subgroup3,
        input$selected_exposures3,
        input$model3,
        input$probdist3,
        input$time3,
        3
      )

      plots3[[x]] <- p3$plot
      order_exposures <- p3$order_exposures
    }
    # design plot layout for all 8 outcomes
    combined_plot3 <- (plots3[[1]] | plots3[[5]]) /
      (plots3[[2]] | plots3[[6]]) / (plots3[[3]] | plots3[[7]]) /
      (plots3[[4]] | plots3[[8]])
      
    make_girafe(combined_plot3, 3, order_exposures)
  })

}
