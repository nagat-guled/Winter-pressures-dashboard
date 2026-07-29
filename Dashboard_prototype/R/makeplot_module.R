plot_graph <- function(outcome_num,
  sub_selec,
  exp_selec,
  model_selec,
  prob_selec,
  time_selec,
  page_num
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
    ) %>%
    mutate(
      # build interpretation sentence depending on characteristics of point
      interp = paste0("<b>Interpretation</b>: "),

      interp = ifelse(exposure %in% exposure_groups$Region,
      paste0(interp, "Compared with practices in the East region, practices in the ", exposure, " region had a "),
      interp),

      interp = ifelse(exposure %in% exposure_groups$Rurality,
      paste0(interp, "Compared with practices in urban conurbations, practices in ", str_to_lower(exposure), " areas had a "),
      interp),
      
      interp = ifelse((exposure %in% exposure_groups$Region | exposure %in% exposure_groups$Rurality)
       & irr > 1,
      paste0(interp, format(round((irr - 1) * 100, 2), nsmall = 2),
      "% higher ", outcome_interpretation[str_remove(outcome, analysis)],
      " ",
      cohort_interp[cohort]),
      interp),

      interp = ifelse((exposure %in% exposure_groups$Region | exposure %in% exposure_groups$Rurality)
       & irr < 1, paste0(interp, format(round((1 - irr) * 100, 2), nsmall = 2),
      "% lower ", outcome_interpretation[str_remove(outcome, analysis)], 
      " ",
      cohort_interp[cohort]),
       interp),

      interp = ifelse(exposure == "list_size",
      paste0(interp, "An increase in 4830 in practice list size was associated with a "),
      interp),

      interp = ifelse(exposure == "list_size"
      & irr > 1,
      paste0(interp, format(round((irr - 1) * 100, 2), nsmall = 2),
      " % increase in ",
      outcome_interpretation[str_remove(outcome, analysis)],
      " ",
      cohort_interp[cohort]),
      interp),

      interp = ifelse(exposure == "list_size"
      & irr < 1,
      paste0(interp, format(round((1 - irr) * 100, 2), nsmall = 2),
      " % decrease in ",
      outcome_interpretation[str_remove(outcome, analysis)],
      " ",
      cohort_interp[cohort]),
      interp),

      interp = ifelse(exposure == "cons_mean",
      paste0(interp, "An increase of 114 per 1000 patients in monthly consultations was associated with a "),
      interp),

      interp = ifelse(exposure == "cons_mean"
      & irr > 1,
      paste0(interp, format(round((irr - 1) * 100, 2), nsmall = 2),
      " % increase in ",
      outcome_interpretation[str_remove(outcome, analysis)],
      " ", cohort_interp[cohort]),
      interp),

      interp = ifelse(exposure == "cons_mean"
      & irr < 1,
      paste0(interp, format(round((1 - irr) * 100, 2), nsmall = 2),
      " % decrease in ",
      outcome_interpretation[str_remove(outcome, analysis)],
      " ",
      cohort_interp[cohort]),
      interp),
      
      interp = ifelse(exposure %in% names(case_mix),
      paste0(interp, "An increase of ", case_mix[exposure],
      " in the practice was associated with a "),
      interp),

      interp = ifelse(exposure %in% names(case_mix)
      & irr > 1,
      paste0(interp, format(round((irr - 1) * 100, 2), nsmall = 2),
      "% increase in ", outcome_interpretation[str_remove(outcome, analysis)],
      " ",
      cohort_interp[cohort]),
      interp),

      interp = ifelse(exposure %in% names(case_mix)
      & irr < 1,
      paste0(interp, format(round((1 - irr) * 100, 2), nsmall = 2),
      "% decrease in ",
      outcome_interpretation[str_remove(outcome, analysis)],
      " ",
      cohort_interp[cohort]),
      interp),

      interp = str_wrap(interp, width = 40),

      interp = ifelse(exposure == "East (ref)"
      | exposure == "Urban conurbation (ref)",
      paste0(""),
      interp)
    )
  # update error messages
  validate(
    need(exp_selec != "", "Please select at least one exposure"),
    need(time_selec != "", "Please select at least one time period")
  )
  # grab axis names in correct order
  order_exposures <- rev(names(exposure_labels)[
  names(exposure_labels) %in% unlist(exposure_groups[exp_selec], use.names = FALSE)])

  # y_title_position <- 0
  # if(length(order_exposures) < 10){
  #   y_title_position <- 2.5
  # } else if (length(order_exposures) < 20 & length(order_exposures) >= 10) {
  #   y_title_position <- 2
  # } esle{
  #   y_title_position <- 1.2
  # }

 p <- ggplot(
    df,
    aes(
      x = irr,
      y = exposure,
      colour = cohort,
      tooltip = paste(
        interp
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
      axis.title.y = if ((page_num != 3 && (outcome_num == 3 || outcome_num == 7))
      || page_num == 3 && outcome_num == 3) {
        element_text(
          size = 25,
          family = "Sora",
          hjust = 1.2
        )
      } else {
        element_blank()
      },
      axis.title.x = if (page_num != 3 && (outcome_num == 3 || outcome_num == 7)
      || (page_num == 3 && outcome_num == 4)) {
        element_text(
          size = 25,
          hjust = 1.2,
          family = "Sora"
        )
      } else {
        element_blank()
      },
      axis.text.y = if ((page_num != 3 && outcome_num %in% c(1, 3, 5, 7))
      || page_num == 3 && outcome_num %in% c(1:4)) {
        element_text(size = 16, family = "Open Sans",
        lineheight = 1)
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
      panel.grid.major = element_line(colour = "gray85", linewidth = 0.6),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_line(colour = "gray96", linewidth = 0.6),
      legend.position = if ((page_num != 3 && outcome_num != 2 && outcome_num != 6) 
      || page_num == 3 && outcome_num != 5) {
        "none"
      },
      legend.text = if ((page_num != 3 && outcome_num == 2 || outcome_num == 6)
      || page_num == 3 && outcome_num == 5) {
        element_text(size = 22)
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
    list(plot = p, order_exposures = order_exposures)
}
