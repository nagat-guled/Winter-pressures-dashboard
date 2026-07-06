library(shiny)
library(ggplot2)
library(bslib)

# create vectors to access all strings needed

x <- c(
       "Personal Consumption Expenditures" = "pce",
       "Personal Savings Rate" = "psavert",
       "Median Duration of Unemployment" = "uempmed")

xlabel <- c(
            pce = "Personal Consumption Expenditures, in billions of dollars",
            psavert = "Personal Savings Rate",
            uempmed = "Median Duration of Unemployment, in weeks")

y <- c(
       "Total Population" = "pop",
       "Number of Unemployed" = "unemploy")

ylabel <- c(
            pop = "Total Population, in thousands",
            unemploy = "Number of Unemployed, in thousands")


ui <- fluidPage(
  theme = bs_theme(
    fg = "#925f94",
    bg = "#f3f3f3"
  ),
  selectInput(
    "x",
    label = "Select x-axis",
    choices = x,
    selected = "Personal Consumption Expenditures"
  ),
  selectInput("y",
    label = "Select y-axis",
    choices = y,
    selected = "Total Population"
  ),
  # create hover functionality

  plotOutput("plot",
    hover = hoverOpts("plot_hover",
      delay = 30,
      delayType = "debounce"
    )
  ),
  uiOutput("hover_box")
)

server <- function(input, output, session) {
  # plot graph using two dynamic variables
  output$plot <- renderPlot({
    ggplot(
      economics,
      aes(
        x = .data[[input$x]],
        y = .data[[input$y]],
        color = date
      )
    ) +
      geom_point(
        size = 2
      ) +
      labs(
        title = "US Economic Time Series",
        x = xlabel[[input$x]],
        y = ylabel[[input$y]]
      ) +
      scale_y_continuous(
        labels = scales::comma
      ) +
      scale_x_continuous(
        labels = scales::comma
      ) +
      theme_minimal() +
      theme(
        plot.background = element_rect(
          fill = "#f3f3f3",
          color = NA
        ),
        panel.background = element_rect(
          fill = "#f3f3f3",
          color = NA
        ),
        plot.title = element_text(
          size = 36,
          color = "#925f94",
          family = "Calibri"
        ),
        axis.title = element_text(
          size = 18,
          color = "#925f94",
          family = "Calibri"
        ),
        axis.text = element_text(
          color = "black",
          size = 14,
          family = "Calibri"
        )
      )
  })
  # create box that appears when hovering
  output$hover_box <- renderUI({
    if (is.null(input$plot_hover)) {
      return(NULL)
    }
    # set location of box
    point <- nearPoints(
      economics,
      input$plot_hover,
      xvar = input$x,
      yvar = input$y,
      maxpoints = 1
    )
    if (nrow(point) == 0) {
      return(NULL)
    }
    dynamic_x <- input$x
    x_value <- point[[dynamic_x]]
    dynamic_y <- input$y
    y_value <- point[[dynamic_y]]

    left_px <- input$plot_hover$coords_css$x + 10
    top_px <- input$plot_hover$coords_css$y + 10

    # set content and style of hover box
    absolutePanel(
      left = left_px,
      top = top_px,
      style =
        "background: #f3f3f3;
        font-size: 16px;
        height: 80px;",
      tags$pre(
        paste0(
          "Date: ", as.character(point$date), "\n",
          names(x)[x == input$x], ": ", x_value, "\n",
          names(y)[y == input$y], ": ", y_value, "\n"
        )
      )
    )
  })
}

shinyApp(ui, server)