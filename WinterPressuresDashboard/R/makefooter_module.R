make_footer <- function(){
  logo_list <- lapply(logos, function(logo) {
    make_logos(logo[["href"]], logo[["title"]], logo[["src"]], logo[["alt"]])
  })
  footer_tag <- tagList(
    tags$footer(
      tags$div(
        class = "footer-link",
        tags$div(
          class = "footer-text",
          style = "text-align: left",
          "Please note:
          The current visualisations use simulated data. The real study outputs are undergoing NHS England review and will be incorporated into the dashboard once this process is complete.",
          tags$br(),
          "Acknowledgements:
          We are very grateful for the support received from the TPP Technical Operations team throughout this work, and for the generous assistance from the information governance and database teams at NHS England and the NHS England Transformation Directorate."
        ),
        tags$div(
          class = "footer-logos-wrapper",
          tags$div(
            id = "footer-logos",
            class = "footer-logos",
            logo_list,
            #duplication for smooth scroll
            logo_list)
        )
      )
    ),
    tags$style(HTML("
      .footer-link {
        display: flex;
        gap: 20px;
        align-items: center;
        flex-wrap: nowrap;
        padding: 8px !important;
        background-color: #f0b099 !important;
        text-align: center;
        font-family: 'Sora';
        font-weight: 600;
        font-size: clamp(10px, 0.8vw, 18px) !important;
        color: black;
      }
      .footer-text {
        max-width: 50%;
      }
      .footer-logos-wrapper{
        max-width: 50%;
        overflow: hidden;
      }
      .footer-logos {
        display: flex;
        gap: 20px;
        width: 750px;
        flex-wrap: nowrap !important;
        max-width: max-content;
        animation: scroll 20s linear infinite;
      }
      .footer-logos a {
        display: inline-flex;
        flex: 0 0 auto;
      }
      .footer-link img {
        height: 50px;
        width: auto;
      }
      @keyframes scroll {
        from{
          transform: translateX(0);
        }
        to {
         transform: translateX(-840px);
        }
      }
     "))
  )
}