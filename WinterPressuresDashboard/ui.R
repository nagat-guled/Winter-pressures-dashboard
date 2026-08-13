ui <- page_navbar(
  fillable = FALSE,
  useShinyjs(),
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
      make_about()
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
  footer = tagList(
    tags$footer(
    tags$div(
      class = "footer-link",
      tags$div(
        class = "footer-text",
        style = "text-align: left",
        "Please note:
        The current visualisations use simulated data. The real study outputs are undergoing NHS England review and will be incorporated into the dashboard once this process is complete.",
        tags$br(),
"Acknowledgements:
We are very grateful for the support received from the TPP Technical Operations team throughout this work, and for the generous assistance from the information governance and database teams at NHS England and the NHS England Transformation Directorate."
      ),
      tags$div(
        class = "footer-logos-wrapper",
      tags$div(
        id = "footer-logos",
        class = "footer-logos",
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
      ),
      tags$a(
      href = "https://www.opensafely.org/",
      title = "OpenSAFELY",
      target = "_blank",
      tags$img(src = "os-logo.png", alt = "OpenSAFELY logo")
      ),
      tags$a(
      href = "https://tpp-uk.com/",
      title = "TPP",
      target = "_blank",
      tags$img(src = "tpp-logo.png", alt = "TPP logo")
      ),
      tags$a(
      href = "https://www.nihr.ac.uk/",
      title = "National Institute for Health Research",
      target = "_blank",
      tags$img(src = "nihr-logo.png", alt = "NIHR logo")
      ),
      tags$a(
      href = "https://www.bennett.ox.ac.uk/",
      title = "Bennet Institute for Applied Data Science",
      target = "_blank",
      tags$img(src = "bennett-logo.png", alt = "Bennett Institute logo")
      ),
      tags$a(
      href = "https://www.ox.ac.uk/",
      title = "University of Oxford",
      target = "_blank",
      tags$img(src = "uox-logo.jpg", alt = "University of Oxford logo")
      ),
      tags$a(
      href = "https://www.lshtm.ac.uk/",
      title = "London School of Hygiene and Tropical Medicine",
      target = "_blank",
      tags$img(src = "lsh-logo.jpe", alt = "London School of Hygiene logo")
      ),
      #duplication for smooth scroll
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
      ),
      tags$a(
      href = "https://www.opensafely.org/",
      title = "OpenSAFELY",
      target = "_blank",
      tags$img(src = "os-logo.png", alt = "OpenSAFELY logo")
      ),
      tags$a(
      href = "https://tpp-uk.com/",
      title = "TPP",
      target = "_blank",
      tags$img(src = "tpp-logo.png", alt = "TPP logo")
      ),
      tags$a(
      href = "https://www.nihr.ac.uk/",
      title = "National Institute for Health Research",
      target = "_blank",
      tags$img(src = "nihr-logo.png", alt = "NIHR logo")
      ),
      tags$a(
      href = "https://www.bennett.ox.ac.uk/",
      title = "Bennet Institute for Applied Data Science",
      target = "_blank",
      tags$img(src = "bennett-logo.png", alt = "Bennett Institute logo")
      ),
      tags$a(
      href = "https://www.ox.ac.uk/",
      title = "University of Oxford",
      target = "_blank",
      tags$img(src = "uox-logo.jpg", alt = "University of Oxford logo")
      ),
      tags$a(
      href = "https://www.lshtm.ac.uk/",
      title = "London School of Hygiene and Tropical Medicine",
      target = "_blank",
      tags$img(src = "lsh-logo.jpe", alt = "London School of Hygiene logo")
      )
      )
    )
    )
  ),
  tags$style(HTML("
  .footer-link {
      display: flex;
      gap: 20px;
      align-items: center;
      flex-wrap: nowrap;
      padding: 8px !important;
      background-color: #610512 !important;
      border-color: var(--UOB_red) !important;
      text-align: center;
      font-family: 'Sora';
      font-weight: 600;
      font-size: clamp(10px, 0.8vw, 18px) !important;
      color: white;
     }
     .footer-text {
     max-width: 50%;
     }
     .footer-logos-wrapper{
     max-width: 50%;
     overflow: hidden;
     }
     .footer-logos {
     display: flex;
     gap: 20px;
     width: 750px;
     flex-wrap: nowrap !important;
     max-width: max-content;
     animation: scroll 20s linear infinite;
     }
     .footer-logos a {
     display: inline-flex;
     flex: 0 0 auto;
     }
  .footer-link img {
    height: 50px;
    width: auto;
    }
    @keyframes scroll {
    from{
    transform: translateX(0);
    }
    to {
    transform: translateX(-830px);
    }
    }
     "))
  ),
  )
