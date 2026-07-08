library(shiny)
library(bslib)
library(patchwork)
library(ggplot2)
library(ggiraph)
library(shinyWidgets)

time_periods <- c("Pre-Covid", "Post-Lockdown 1", "Post-Lockdown 2", "Post-Lockdown 3" )
exposures <- list(
 "Practice characteristics" = c("Practice region", "Practice list size", "Monthly Consultation rate", "Practice Rurality"),
 "Patient case-mix" = c("Age", "Sex", "Ethnicity", "Deprivation", "Rurality", "Smoking", "Obesity", "Comorbidities", "Vaccinations")
)

ui <- page_navbar(
  # create custom UOB style theme
  tags$style(HTML("
    body{
      font-family: 'Open Sans';
      font-size: 14px;
    }
    h1 {
    font-family: 'Sora';
     font-weight: 600;
     color: #a6192e;
     font-size: 26px;
     position: relative;
     top: 12px;
     }
     h2{
     font-family: 'Open Sans';
     margin-top: 25px;
     font-size: 20px;
     }
     h3{
     font-family: 'Open Sans';
     font-size: 18px;
     color: black;
     }
     .navbar-brand {
     display: flex;
     align-items: flex-start;
     }
     .navbar {
     padding-top: 10px;
     padding-bottom: 0;
     }
     .nav-link {
     display: flex;
     align-items: center;
     }
     .nav-link:hover{
     color: #a6192e !important;
     }
     .nav-link.active{
     color: #a6192e !important;
     font-weight: 600 !important;
     }"
  )),
  theme = bs_theme(
    bg = "white",
    fg = "black",
    base_font  = font_google("Open Sans"),
    heading_font = font_google("Sora"),
    primary = "#a6192e"
  ),
  title = div(
    style = "display: flex; align-items: flex-end; gap: 12px;",
    img(
      src = "UoB_RGB_24.jpg",
      width = "120px", height = "34px"
     ),
     h1("Interactive Winter Pressures Dashboard")
  ),
  nav_panel(
    h2("About")
  ),
  nav_panel(
    h2("Dashboard"),
    card(
      girafeOutput("plot", height = "400px"),
      height = "1300px"
    ),
    layout_columns(
      col_widths = c(6, 6),
    card(
      height = "800px",
      selectInput("outcome1", "Select Outcome:", choices = NULL),
      virtualSelectInput("exposures1", "Select exposures:", choices = exposures, selected = unlist(exposures, use.name = FALSE), multiple = TRUE, search = TRUE, dropboxWrapper = "body"),
      selectInput("subgroup1", "Select sub-groups:", choices = NULL),
      selectInput("model1", "Select model:", choices = NULL),
      prettyToggle("probdist1", label_on = "Poisson", label_off = "Negative Binomial"),
      checkboxGroupButtons("time1","Select time periods:", choices = time_periods, selected = time_periods)
    ),
    card(
      selectInput("outcome2", "Select Outcome:", choices = NULL),
      virtualSelectInput("exposures2", "Select exposures:", choices = exposures, selected = unlist(exposures, use.name = FALSE), multiple = TRUE, search = TRUE, dropboxWrapper = "body"),
      selectInput("subgroup2", "Select sub-groups:", choices = NULL),
      selectInput("model2", "Select model:", choices = NULL),
      prettyToggle("probdist2", label_on = "Poisson", label_off = "Negative Binomial"),
      checkboxGroupButtons("time2","Select time periods:", choices = time_periods, selected = time_periods)
    )
  )
  )
)

server <- function(input, output) {
  output$plot <- renderGirafe({
    p1 <- ggplot() + 
      theme( 
        panel.background = element_rect(
        fill = "white"
      ),)
    p2 <- ggplot() + 
      theme( 
        panel.background = element_rect(
        fill = "white"
      ),)
  combined_plot <- p1 + p2 + plot_layout(ncol = 2)
  girafe(
    ggobj = combined_plot
  )
  })
}


shinyApp(ui, server)