library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  skin = "black",
  dashboardHeader(
    title = "Interactive Winter Pressures Dashboard",
    titleWidth = 400
  ),

  sidebar <- dashboardSidebar(
    width = 100,
    sidebarMenu(
        menuItem("Dashboard", tabName = "Dashboard"),
        menuItem("About", tabName = "About")
    )
  ),
  body <- dashboardBody(
    tags$head(tags$style(HTML('
    .main-header .logo {
    font-family: system-ui;
    }'))),
    tabItems(
      tabItem(tabName = "Dashboard",
      fluidRow(
        box(plotOutput("plot1", height = 250)),
        box(plotOutput("plot2", height = 250)),
        box(
            title = "Filters" # add widgets
          )
    )
      ),
      tabItem(tabName = "About",
      )
    )
  ),
  )

server <- function(input, output) {}

shinyApp(ui, server)