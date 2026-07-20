plot_graph <- function(outcome_num, sub_selec, exp_selec, model_selec, prob_selec, time_selec) {
  df <- df %>%
    filter(
      analysis == names(sub_groups)[sub_groups == sub_selec] &
        outcome == paste0(outcome_raw[outcome_num], names(sub_groups)[sub_groups == sub_selec]) &
        model_type == names(probdists)[probdists == prob_selec] &
        model == names(models)[models == model_selec] &
        grepl("^exp_prop(_|$)", term)
    ) %>%
    mutate(
      exposure = if_else(exposure == "practice_region" | exposure == "practice_rurality",
      substring(term, nchar("exp_prop_") + 1), exposure
      ),
      lci = if_else(grepl("ref", term), 1, lci),
      uci = if_else(grepl("ref", term), 1, uci)
    ) %>%
    filter(
      exposure %in% names(exposure_labels)[match(exp_selec, exposure_labels)] &
        cohort %in% names(time_periods)[match(time_selec, time_periods)]
    )
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
  geom_errorbar(
    aes(
      xmax = uci,
      xmin = lci,
      alpha = 0.7
    ),
    linewidth = 1,
    width = 0.5,
    orientation = "y",
    position = position_dodge(width = 0.8),
    show.legend = FALSE
    ) +
  geom_vline(
    xintercept = 1.0,
    linetype = "dotted",
    color = "#b42323",
    linewidth = 1.3
  ) +
  labs(
    title = outcome_titles[outcome_num],
    x = "Incidence Rate Ratio (IRR)",
    y = "General Practice Characteristics"
  ) +
  scale_y_discrete(
    limits = names(exposure_labels)[match(exp_selec, exposure_labels)],
    breaks = names(exposure_labels)[match(exp_selec, exposure_labels)],
    labels = exposure_labels[exposure_labels %in% exp_selec]
  ) +
  theme_minimal() +
    theme(
      plot.title = element_text(
        size = 25,
        family = "Open sans",
        hjust = 0.4
      ),
      axis.title.y = if (outcome_num == 4) {
        element_text(size = 35, family = "Open Sans")
      } else {
        element_blank()
      },
      axis.title.x = if (outcome_num == 8) {
       element_text(
        size = 35,
        hjust = -1,
        family = "Open sans"
      )} else {
        element_blank()
      },
      axis.text.y = if (outcome_num %in% c(1, 4, 7)) {
        element_text(size = 16, family = "Open Sans")
      } else {
        element_blank()
      },
      axis.text.x = element_text(
        size = 14,
        family = "Open sans"
      ),
      legend.title = element_blank(),
      panel.border = element_blank(),
      axis.line.y = element_blank(),
      axis.line.x = element_line(),
      panel.grid = element_blank(),
      legend.position = if (outcome_num != 8) {
        "none"
      },
      legend.text = if (outcome_num == 8) {
        element_text(size = 25)
      } else {
        element_blank()
      }
    ) +
    scale_color_discrete(
      breaks = c("precovid", "postcovid1", "postcovid2", "postcovid3"),
      labels = unname(time_periods)
    )
}

server <- function(input, output) {
  output$plot <- renderGirafe({
    plots <- list()
    for (x in 1:8){
      p <- plot_graph(x,
      input$subgroup,
      input$selected_exposures,
      input$model,
      input$probdist,
      input$time)

      plots[[x]] <- p
    }
    bottom_row <- (plot_spacer() | plots[[7]] | plots[[8]] | plot_spacer()) +
      plot_layout(widths = c(0.5, 4, 4, 1))
    combined_plot <- (plots[[1]] | plots[[2]] | plots[[3]]) /
      (plots[[4]] | plots[[5]] | plots[[6]]) / bottom_row

    girafe(
      ggobj = combined_plot,
      width_svg = 36,
      height_svg = 40,
      options = list(
      opts_sizing(rescale = TRUE, width = 1),
      opts_hover(css = "cursor:pointer; stroke-width:3; size = 5;"),
      opts_hover_inv(css = "opacity: 0.7;"),
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
        position = "bottomright",
        hidden = c("lasso_select", "lasso_deselect")
      )
      )
    )
  })
}
