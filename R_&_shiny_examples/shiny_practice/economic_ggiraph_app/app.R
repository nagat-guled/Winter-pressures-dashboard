library(shiny)
library(ggplot2)
library(bslib)
library(ggiraph)
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

fg_colour <- "#925f94"
bg_colour <- "#f3f3f3"

ui <- fluidPage(
  theme = bs_theme(
    fg = fg_colour,
    bg = bg_colour
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
  # Introduce ggiraph for hover functionality
  girafeOutput("plot", width = "100%", height = "600px"),
)

server <- function(input, output, session) {
  # plot graph using two dynamic variables
  output$plot <- renderGirafe({
    data <- ggplot2::economics
    data$id <- seq_len(nrow(data))
    p <- ggplot(
      data,
      aes(
        x = .data[[input$x]],
        y = .data[[input$y]],
        color = date,
        tooltip = paste(
          "Date: ", date, "\n",
          names(x)[x == input$x], ": ", .data[[input$x]], "\n",
          names(y)[y == input$y], ": ", .data[[input$y]], "\n"
        ),
        data_id = id
      )
    ) +
      geom_point_interactive(
        size = 1.5,
        hover_css = "r:8pt;opacity:0.8;"
      ) +
      labs(
        x = xlabel[[input$x]],
        y = ylabel[[input$y]]
      ) +
      ggtitle("US Economic Time Series") +
      scale_y_continuous(
        labels = scales::comma
      ) +
      scale_x_continuous(
        labels = scales::comma
      ) +
      theme_minimal() +
      theme(
        plot.background = element_rect(
          fill = bg_colour,
          color = NA
        ),
        panel.background = element_rect(
          fill = bg_colour,
          color = NA
        ),
        plot.title = element_text(
          hjust = 0,
          size = 28,
          color = fg_colour,
          family = "Calibri"
        ),
        axis.title = element_text(
          size = 14,
          color = fg_colour,
          family = "Calibri"
        ),
        axis.text = element_text(
          color = "black",
          size = 14,
          family = "Calibri"
        )
      )
    girafe(
      ggobj = p,
      options = list(
        opts_hover(css = "cursor:pointer;"),
        opts_tooltip(
          opacity = 0.9,
          css = "background: white;"
        )
      )
    )
  })

}

shinyApp(ui, server)