uob_red <- "#a6192e"

ui <- page_navbar(
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
      width = "120px",
      height = "34px"
    ),
    h1("Interactive Winter Pressures Dashboard")
  ),
  # create navigation bar containing tabs
  nav_panel(
    h2("About")
  ),
  nav_panel(
    h2("Dashboard"),
    card(
      girafeOutput(
        "plot"
      )
    ),
    filters()
  ),
)
