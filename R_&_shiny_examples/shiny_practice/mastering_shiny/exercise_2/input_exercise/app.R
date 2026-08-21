library(shiny)

ui <- fluidPage(
  textInput("name", label = "What's your name?", placeholder = "name"),
  sliderInput("slide", label = "when should we deliver", value = as.Date("2023-12-31"), min = as.Date("2020-12-31"), max = as.Date("2026-12-31"))
)

server <- function(input, output, session) {

}

shinyApp(ui, server)