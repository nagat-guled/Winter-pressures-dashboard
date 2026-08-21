make_girafe <- function(comb_plot, id, list_exposures) {
  floor_height <- 1

  facet1_height <- sum(list_exposures %in% practice_characteristics) + floor_height
  facet2_height <- sum(list_exposures %in% names(case_mix)) + floor_height

  min_height <- 1
  strip_height <- 1

  if(id == 3){
    row_height = 4
  } else {
    row_height = 2
  }

  total_height = (max(facet1_height, min_height) + max(facet2_height, min_height)) * row_height + strip_height

   girafe(
    ggobj = comb_plot,
    width_svg = 26,
    height_svg = total_height,
    options = list(
      opts_sizing(rescale = TRUE, width = 1),
      opts_hover(css = "cursor:pointer; stroke-width:3px; r:5pt;"),
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
        box-shadow: 0 2px 8px #0000001f;
        max-width: 200px"
      ),
      opts_zoom(min = 1, max = 5),
      opts_toolbar(
        position = "topright",
        hidden = c("lasso_select", "lasso_deselect")
      )
    )
  )
}