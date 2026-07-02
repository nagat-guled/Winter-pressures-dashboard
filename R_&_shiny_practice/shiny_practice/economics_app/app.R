library(shiny)
library(ggplot2)
library(bslib)

y <- c("pce", "psavert", "uempmed")
x <- c("pop", "unemploy") 

ui <- fluidPage(
    theme = bs_theme(
        fg = "#DFB793", bg = "#904122"
    ),
    selectInput("x", label = "x-axis", choices = x, selected = "pce"),
    selectInput("y", label = "y-axis", choices = y, selected = "pop"),
    plotOutput("plot")
)

server <- function(input, output, session){
    bs_themer()
    output$plot <- renderPlot({
        ggplot(economics, aes(x = .data[[input$x]], y= .data[[input$y]])) +
        geom_point() +
        labs(title = "US Economic Time Series", x = input$x, y = input$y) +
        theme_minimal() +
        theme(
            plot.background = element_rect(fill = "#904122", color = NA),
            panel.background = element_rect(fill = "#af5f40", color = NA),
            plot.title = element_text(face = "bold", size = 36, color = "#DFB793", family = "mono"),
            axis.title = element_text(face = "bold", size = 18, color = "#DFB793"),
            axis.text = element_text(color = "#DFB793", size = 10)
        )
    })
}

shinyApp(ui, server)