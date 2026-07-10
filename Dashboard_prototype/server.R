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
      data_id = cohort,
    ) 
  ) +
  geom_point_interactive(
    size = 4
  ) +
  geom_errorbar(
    aes(
      xmin = lci,
      xmax = uci
    ),
    size = 1.5,
    width = 0
  ) +
  labs(
    x = "IRR",
    y = "General Practice Characteristics"
  ) +
  scale_x_continuous(expand = expansion(mult = 0.05)) +
#   scale_y_discrete(labels = scales::label_wrap(20)) +
  theme_minimal() +
    theme(
      panel.background = element_rect(
        fill = "white"
      ),
      axis.title = element_text(
        size = 20,
        family = "Open sans"
      ),
      axis.text = element_text(
        size = 14,
        family = "Open sans"
      ),
    legend.key.width = unit(22, "pt"),
    legend.key.height = unit(18, "pt"),
    legend.spacing.x = unit(4, "pt"),
    legend.spacing.y = unit(2, "pt"),
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 9)
    )
}

server <- function(input, output) {
  output$plot <- renderGirafe({
    p1 <- plot_graph()
    p2 <- plot_graph()
    combined_plot <- p1 + plot_spacer() + p2 + plot_layout(widths = c(6, 1, 6))
    girafe(
      ggobj = combined_plot,
      width_svg = 28,
      height_svg = 10,
      options = list(
      opts_sizing(rescale = TRUE, width = 1)
      )
    )
  })
}
