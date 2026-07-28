make_girafe <- function(comb_plot, id, list_exposures) {
  if (id == 3) {
      shinyjs::hide("model3")
      shinyjs::hide("selected_exposures3")
  }
  if(length(list_exposures) < 8){
    min_length <- 8
  } else {
    min_length <- length(list_exposures)
  }
   girafe(
      ggobj = comb_plot,
      width_svg = 26,
      height_svg = if (id == 3){
       min_length * 4
      } else {
      min_length * 2
      },
      options = list(
        opts_sizing(rescale = TRUE, width = 1),
        opts_hover(css = "cursor:pointer; stroke-width:3; size = 5;"),
        opts_hover_inv(css = "opacity: 0.7;"),
        opts_tooltip(
          opacity = 0.9,
          css = "background-color: #f8f8ff; 
          font-size: 12px;
          font-family: 'Sora'; 
          color: #696969;
          padding: 4px;
          border: 1px solid #A6192E;
          border-radius: 6px;
          box-shadow: 0 2px 8px #0000001f"
        ),
        opts_zoom(min = 1, max = 5),
        opts_toolbar(
          position = "topright",
          hidden = c("lasso_select", "lasso_deselect")
        )
      )
    )
}