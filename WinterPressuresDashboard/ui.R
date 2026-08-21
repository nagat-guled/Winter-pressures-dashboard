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
  make_tab("All-cause hospital use", 1, "plot1"),
  make_tab("ACSC-related hospital use", 2, "plot2"),
  make_tab("Hospital use estimator", 3, "plot3"),
  footer = make_footer()
)