library(shiny)
ui <- fluidPage(
    numericInput("age", "How old are you?", value = NA),
    textInput("name", "What's your name?"),
    textOutput("greeting")

)
server <- function(input, output, session) {
    output$greeting <- renderText({
        paste0("Hello ", input$name)
    })
    output$histogram <- renderPlot({
        hist(rnorm(1000))
    }, res = 96)

}
shinyApp(ui, server)