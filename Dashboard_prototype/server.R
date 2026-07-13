df <- df %>%
  filter(
    analysis == "main" &
      outcome == "apc_main" &
      model_type == "negbin" &
      model == "mdl_age_sex" &
      term == "exp_prop"
  )

plot_graph <- function(){
  ggplot(
    df,
    aes(
      x = irr,
      y = exposure,
      colour = cohort,
      tooltip = paste(
        time_periods[cohort], "\n",
        exposure_labels[exposure], "\n",
        "IRR: ", irr, "\n", " LCI: ", lci, "\n", " UCI: ", uci
      ),
      data_id = paste(cohort, exposure, sep = "_")
    )
  ) +
  geom_point_interactive(
    size = 4,
    position = position_dodge(width = 0.8)
  ) +
  geom_errorbarh(
    aes(
      xmin = lci,
      xmax = uci
    ),
    size = 1.5,
    width = 0,
    position = position_dodge(width = 0.8),
  ) +
  geom_vline(
    xintercept = c(1.0, 1.1),
    linetype = "dotted",
    color = "red",
    size = 1.3
  ) +
  geom_vline(
    xintercept = c(0.9, 1.2),
    linetype = "dotted",
    color = "black",
    size = 0.9
  ) +
  labs(
    x = "Incidence Rate Ratio (IRR)",
    y = "General Practice Characteristics"
  ) +
  scale_y_discrete(
    breaks = names(exposure_labels),
    labels = unname(exposure_labels)
  ) +
  theme_minimal() +
    theme(
      axis.title = element_text(
        size = 20,
        family = "Open sans"
      ),
      axis.text = element_text(
        size = 14,
        family = "Open sans"
      ),
      legend.title = element_blank(),
      panel.border = element_blank(),
      axis.line.y = element_blank(),
      axis.line.x = element_line(),
      panel.grid = element_blank(),
      legend.position = "bottom",
      legend.text = element_text(size = 15)
    ) +
    scale_color_discrete(
      breaks = c("precovid", "postcovid1", "postcovid2", "postcovid3"),
      labels = unname(time_periods)
    )
}

server <- function(input, output) {
  output$plot <- renderGirafe({
    p1 <- plot_graph()
    p2 <- plot_graph()
    combined_plot <- p1 + p2 + plot_layout(widths = c(6, 6))
    girafe(
      ggobj = combined_plot,
      width_svg = 30,
      height_svg = 12,
      options = list(
      opts_sizing(rescale = TRUE, width = 1),
      opts_hover(css = "cursor:pointer; opacity: 1; transition-delay:0.2s;"),
      #opts_hover_inv(css = 'opacity: 0.6;'),
      opts_tooltip(
          opacity = 0.9,
          css = "background: #fffffff7; 
          font-size: 10px;
          font-family: 'Open Sans'; 
          color: #333333;
          padding: 4px;
          border: 1px solid #A6192E;
          border-radius: 6px;
          box-shadow: 0 2px 8px #0000001f"
        ),
      opts_zoom(min = 1, max = 5),
      opts_toolbar(
        hidden = c("lasso_select", "lasso_deselect")
      )
      )
    )
  })
}
