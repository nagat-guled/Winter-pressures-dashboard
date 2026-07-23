uob_red <- "#a6192e"

# pass all dynamic variables into function
plot_graph <- function(outcome_num,
  sub_selec,
  exp_selec,
  model_selec,
  prob_selec,
  time_selec
) {
  # filter dataset depending on user input and outcome
  df <- df %>%
    filter(
      analysis == names(sub_groups)[sub_groups == sub_selec] &
        outcome == paste0(outcome_raw[outcome_num],
          names(sub_groups)[sub_groups == sub_selec]
        ) &
        model_type == names(probdists)[probdists == prob_selec] &
        model == names(models)[models == model_selec] &
        grepl("^exp_prop(_|$)", term)
    ) %>%
    mutate(
      exposure = if_else(exposure == "practice_region" |
          exposure == "practice_rurality",
        substring(term, nchar("exp_prop_") + 1),
        exposure
      ),
      lci = if_else(grepl("ref", term), 1, lci),
      uci = if_else(grepl("ref", term), 1, uci)
    ) %>%
    filter(
      exposure %in% unlist(exposure_groups[exp_selec], use.names = FALSE) &
        cohort %in% names(time_periods)[match(time_selec, time_periods)]
    )
  # update error messages
  validate(
    need(exp_selec != "", "Please select at least one exposure"),
    need(time_selec != "", "Please select at least one time period")
  )
  # grab axis names in correct order
  order_exposures <- rev(names(exposure_labels)[
  names(exposure_labels) %in% unlist(exposure_groups[exp_selec], use.names = FALSE)])

  ggplot(
    df,
    aes(
      x = irr,
      y = exposure,
      colour = cohort,
      tooltip = paste(
        time_periods[cohort], "\n",
        exposure_labels[exposure], "\n",
        "IRR: ", format(round(irr, 2), nsmall = 2), "\n",
        " LCI: ", format(round(lci, 2), nsmall = 2), "\n",
        " UCI: ", format(round(uci, 2), nsmall = 2)
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
    width = 0.01,
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
    limits = order_exposures,
    breaks = order_exposures,
    labels = stringr::str_wrap(exposure_labels[order_exposures], width = 15)
  ) +
  xlim(0.6, 1.6) +
  theme_minimal() +
    theme(
      plot.title = element_text(
        size = 25,
        family = "Sora",
        hjust = 0,
        colour = uob_red,
        face = "bold"
      ),
      axis.title.y = if (outcome_num == 3 || outcome_num == 7) {
        element_text(
          size = 23,
          family = "Sora",
          hjust = 1.2
        )
      } else {
        element_blank()
      },
      axis.title.x = if (outcome_num == 3 || outcome_num == 7) {
        element_text(
          size = 23,
          hjust = 1.2,
          family = "Sora"
        )
      } else {
        element_blank()
      },
      axis.text.y = if (outcome_num %in% c(1, 3, 5, 7)) {
        element_text(size = 16, family = "Open Sans",
        lineheight = 0.7)
      } else {
        element_blank()
      },
      axis.text.x = element_text(
        size = 14,
        family = "Open Sans"
      ),
      legend.title = element_blank(),
      panel.border = element_rect(colour = "gray50", linewidth = 0.4),
      axis.line.y = element_blank(),
      axis.line.x = element_line(),
      panel.grid.major = element_line(colour = "gray50", linewidth = 0.6),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      #panel.grid = element_blank(),
      legend.position = if (outcome_num != 2 && outcome_num != 6) {
        "none"
      },
      legend.text = if (outcome_num == 2 || outcome_num == 6) {
        element_text(size = 18)
      } else {
        element_blank()
      }
    ) +
    scale_color_manual(
      values = c(
      "precovid" = "coral",
      "postcovid1" = "darkseagreen",
      "postcovid2" = "orchid",
      "postcovid3" = "deepskyblue"),
      breaks = c("precovid", "postcovid1", "postcovid2", "postcovid3"),
      labels = unname(time_periods)
    )
}

make_girafe <- function(comb_plot) {
   girafe(
      ggobj = comb_plot,
      width_svg = 26,
      height_svg = 38,
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

server <- function(id, input, output) {
  output$plot1 <- renderGirafe({
    plots <- list()
    for (x in 1:4){
      p1 <- plot_graph(
        x,
        input$subgroup1,
        input$selected_exposures1,
        input$model1,
        input$probdist1,
        input$time1
      )

      plots[[x]] <- p1
    }
    # design plot layout for all 8 outcomes
    combined_plot1 <- (plots[[1]] | plots[[2]]) /
      (plots[[3]] | plots[[4]])

    make_girafe(combined_plot1)

  })

  output$plot2 <- renderGirafe({
    plots2 <- list()
    for (x in 5:8){
      p2 <- plot_graph(
        x,
        input$subgroup2,
        input$selected_exposures2,
        input$model2,
        input$probdist2,
        input$time2
      )

      plots2[[x]] <- p2
    }
    # design plot layout for all 8 outcomes
    combined_plot2 <- (plots2[[5]] | plots2[[6]]) /
      (plots2[[7]] | plots2[[8]])

    make_girafe(combined_plot2)
  })

}
