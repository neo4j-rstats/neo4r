send_data_frame <- function(obj, con, port = 2811){
  stop_if_not(class(obj), ~ .x %in% c("data.frame", "matrix"),
              "Please use a data.frame or a matrix")
  tmpfile <- tempfile(fileext = ".csv")
  write.csv(obj, tmpfile)
  on.exit(unlink(tmpfile))
  ui <- miniPage(
    gadgetTitleBar("Send to Neo4j"),
    miniTabstripPanel(
      miniTabPanel("Browse file", icon = icon("sliders"),
                   miniContentPanel(
                     h3(glue("Sending {deparse(substitute(obj))}")),
                     textInput("as", "AS"),
                     textAreaInput("code", "Neo4J Code"),
                     actionButton("send", "Send")
                   )
      )
    )

  )

  server <- function(input, output, session) {
    res <- reactiveValues()

    observeEvent(input$send, {
      withProgress({
        r <- plumb(system.file("plumber.R", package = "neo4r"))
        r$run(host = "0.0.0.0", port = 2811)
        code <- glue("LOAD CSV WITH HEADERS FROM http://127.0.0.1:2811/{tmpfile} AS {input$as} {input$code}")
      }, message = "Sending")

    })

    output$users <- renderDT({
      req(res$tweets)
      res$tweets %>%
        count(screen_name) %>%
        top_n(as.numeric(input$howmuch)) %>%
        arrange(n) %>%
        datatable()
    })
  }

  runGadget(ui, server)
}

