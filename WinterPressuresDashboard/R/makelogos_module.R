make_logos <- function(href, title, img, alt){
tags$a(
    href = href, title = title, target = "_blank",
    tags$img(src = img, alt = alt)
)
}