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
        outcome == outcome_raw[outcome_num] &
        model_type == names(probdists)[probdists == prob_selec] &
        model == names(models)[models == model_selec] &
        grepl("^exp_prop(_|$)", term)
    )
    df <- df %>%
    { if (page_num != 3) {
    mutate(
      .,
      exposure = if_else(exposure == "practice_region" |
          exposure == "practice_rurality",
        substring(term, nchar("exp_prop_") + 1),
        exposure
      ) ) } else {
        mutate(
          .,
          exposure = substring(term, nchar("exp_prop_") + 1)
        ) }} %>%
      mutate (
      lci = if_else(grepl("ref", term), 1, lci),
      uci = if_else(grepl("ref", term), 1, uci),

      exposure_type = ifelse(exposure %in% practice_characteristics,
        "Practice Characteristics",
        "Patient Case-mix"
      )

    ) %>%
    filter(
      exposure %in% c(
     if ("Region" %in% exp_selec) exposure_groups$Region else NULL,
     if ("Rurality" %in% exp_selec) exposure_groups$Rurality else NULL,
     unname(exposure_lookup[intersect(exp_selec, names(exposure_lookup))])
     )  &
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
      "% higher ", outcome_interpretation[outcome],
      " ",
      cohort_interp[cohort]),
      interp),

      interp = ifelse((exposure %in% exposure_groups$Region | exposure %in% exposure_groups$Rurality)
       & irr < 1, paste0(interp, format(round((1 - irr) * 100, 2), nsmall = 2),
      "% lower ", outcome_interpretation[outcome], 
      " ",
      cohort_interp[cohort]),
       interp),

      interp = ifelse(exposure == "list_size",
      paste0(interp, "An increase in ", mad, " in practice list size was associated with a "),
      interp),

      interp = ifelse(exposure == "list_size"
      & irr > 1,
      paste0(interp, format(round((irr - 1) * 100, 2), nsmall = 2),
      " % increase in ",
      outcome_interpretation[outcome],
      " ",
      cohort_interp[cohort]),
      interp),

      interp = ifelse(exposure == "list_size"
      & irr < 1,
      paste0(interp, format(round((1 - irr) * 100, 2), nsmall = 2),
      " % decrease in ",
      outcome_interpretation[outcome],
      " ",
      cohort_interp[cohort]),
      interp),

      interp = ifelse(exposure == "cons_mean",
      paste0(interp, "An increase of ", mad, " per 1000 patients in monthly consultations was associated with a "),
      interp),

      interp = ifelse(exposure == "cons_mean"
      & irr > 1,
      paste0(interp, format(round((irr - 1) * 100, 2), nsmall = 2),
      " % increase in ",
      outcome_interpretation[outcome],
      " ", cohort_interp[cohort]),
      interp),

      interp = ifelse(exposure == "cons_mean"
      & irr < 1,
      paste0(interp, format(round((1 - irr) * 100, 2), nsmall = 2),
      " % decrease in ",
      outcome_interpretation[outcome],
      " ",
      cohort_interp[cohort]),
      interp),
      
      interp = ifelse(exposure %in% names(case_mix),
      paste0(interp, "An increase of ", mad, case_mix[exposure],
      " in the practice was associated with a "),
      interp),

      interp = ifelse(exposure %in% names(case_mix)
      & irr > 1,
      paste0(interp, format(round((irr - 1) * 100, 2), nsmall = 2),
      "% increase in ", outcome_interpretation[outcome],
      " ",
      cohort_interp[cohort]),
      interp),

      interp = ifelse(exposure %in% names(case_mix)
      & irr < 1,
      paste0(interp, format(round((1 - irr) * 100, 2), nsmall = 2),
      "% decrease in ",
      outcome_interpretation[outcome],
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


  if(any(exposure_groups$Region %in% df$exposure)) {
    df <- df %>%
    add_row(exposure = "Region", exposure_type = "Practice Characteristics")
  }

  if(any(exposure_groups$Rurality %in% df$exposure)) {
    df <- df %>%
    add_row(exposure = "Rurality", exposure_type = "Practice Characteristics")
  }

  if(any(exposure_groups$Age %in% df$exposure)) {
    df <- df %>%
    add_row(exposure = "Age", exposure_type = "Patient Case-mix")
  }

  if(any(exposure_groups$Ethnicity %in% df$exposure)) {
    df <- df %>%
    add_row(exposure = "Ethnicity", exposure_type = "Patient Case-mix")
  }

  if(any(exposure_groups$Deprivation %in% df$exposure)) {
    df <- df %>%
    add_row(exposure = "Deprivation", exposure_type = "Patient Case-mix")
  }

  if(any(exposure_groups$Smoking_Status %in% df$exposure)) {
    df <- df %>%
    add_row(exposure = "Smoking Status", exposure_type = "Patient Case-mix")
  }

  order_exposures <- rev(names(exposure_labels)[names(exposure_labels) %in% df$exposure])


  len_pc <- length(order_exposures[order_exposures %in% practice_characteristics])
  len_cm <- length(order_exposures[order_exposures %in% names(case_mix)])

  rows_order <- c()
  facet_labels <- c()
  if (len_pc == 0) {
    df <- df %>%
    add_row(exposure_type = "Practice Characteristics", exposure = "")
    facet_labels <- c("Practice Characteristics" = "Practice Characteristics (none selected)")
  } 
  if (len_cm == 0) {
    df <- df %>%
    add_row(exposure_type = "Patient Case-mix", exposure = "")
    facet_labels <- c(facet_labels, "Patient Case-mix" = "Patient Case-mix (none selected)")
  } 

  df$exposure_type <- factor(
    df$exposure_type,
    levels = c("Practice Characteristics", "Patient Case-mix")
  )

  rows_order <- c(len_pc, len_cm)

 make_labels <- function(label) {
  headings <- c("Region", "Rurality", "Age", "Ethnicity", "Deprivation", "Smoking Status",
   "Practice list size")
  pct_headings <- c("Sex: Female", "Obesity", "Care home residence")
   
  if (label %in% headings) {
      return(bquote(bold(.(label))))
    }
  if (label %in% pct_headings) {
    return(bquote(bold(.(label)) ~ "(%)"))
  }
  if (label == "Monthly consultation rate (per 1000 patients)") {
    return(bquote(atop(bold("Monthly consultation rate"), "(per 1000 patients)")))
  }
  return(label)
}

df$exposure <- factor(
  df$exposure,
  levels = order_exposures
)


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
    breaks = order_exposures,
    labels = sapply(exposure_labels[order_exposures], make_labels)
  ) +
  xlim(0.6, 1.6) +
  facet_wrap2(
    exposure_type ~ .,
    ncol = 1,
    scales = "free_y",
    strip.position = "top",
    labeller = labeller(exposure_type = facet_labels)
  ) +
  force_panelsizes(rows = rows_order) +
  theme_minimal() +
    theme(
      plot.title = element_text(
        size = 25,
        family = "Sora",
        hjust = 0,
        colour = uob_red,
        face = "bold"
      ),
      # axis.title.y = if ((page_num != 3 && (outcome_num == 3 || outcome_num == 7))
      # || page_num == 3 && outcome_num == 3) {
      #   element_text(
      #     size = 25,
      #     family = "Sora",
      #     hjust = 1.2
      #   )
      # } else {
      #   element_blank()
      # },
      axis.title.y = element_blank(),
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
        ggtext::element_markdown(size = 16, lineheight = 1, hjust = 1)
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
      },
      strip.text = element_text(
        face = "bold",
        family = "Sora",
        size = 16,
        color = "white",
        hjust = 0
      ),
      strip.background = element_rect(fill = uob_red)
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