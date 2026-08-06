ui <- page_navbar(
  useShinyjs(),
  fillable = FALSE,
  # create custom UOB style theme
  tags$head(

    
    tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = "styles.css"
    )
  ),
  theme = bs_theme(
    bg = "white",
    fg = "black",
    base_font  = font_google("Open Sans"),
    heading_font = font_google("Sora"),
    primary = uob_red
  ),
  title = div(
    style = "display: flex; align-items: flex-end; gap: 12px;",
    img(
      src = "UoB_RGB_24.jpg",
      #width = "106px",
      #height = "30px"
    ),
    h1("Interactive Winter Pressures Dashboard")
  ),
  # create navigation bar containing tabs
  nav_panel(
    "About",
    card(

    )
  ),
  nav_panel(
    "All-cause hospital use",
    fluidRow(
      column(
        3,
        filters(1)
      ),
      column(
        9,
        card(
          withSpinner(
          girafeOutput(
            "plot1",
            width = "100%"
          )
          )
        ),
      )
    )
  ),
  nav_panel(
    "ACSC-related hospital use",
    fluidRow(
      column(
        3,
        filters(2)
      ),
      column(
        9,
        card(
          withSpinner(
          girafeOutput(
            "plot2",
            width = "100%"
          )
          )
        ),
      )
    )
  ),
   nav_panel(
    "Hospital use estimator",
    fluidRow(
      column(
        3,
        filters(3)
      ),
      column(
        9,
        card(
          withSpinner(
          girafeOutput(
            "plot3",
            width = "100%"
          )
          )
        ),
      )
    )
  ),
  tags$footer(
    tags$div(
      class = "footer-link",
      tags$a(
      href = "https://www.bristol.ac.uk/population-health-sciences/centres/ehr/",
      title = "UOB Electronic Health Records Group",
      target = "_blank",
      tags$img(src = "favicon.png", alt = "UOB logo")
      ),
      tags$a(
      href = "https://www.hdruk.ac.uk/",
      title = "Health Data Research UK",
      target = "_blank",
      tags$img(src = "hdr-uk-logo.jpg", alt = "HDR UK logo")
      )
    )
  ),
  tags$style(HTML("
  .footer-link {
      padding: 8px !important;
      background-color: #610512 !important;
      border-color: var(--UOB_red) !important;
      text-align: center;
      font-family: 'Sora';
      font-weight: 600;
      font-size: 28;
      color: white;
     }
  .footer-link img {
    height: 50px;
    width: auto;
    }
     ")),
)
