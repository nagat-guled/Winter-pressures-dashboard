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
  label
}