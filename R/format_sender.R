# # Widget 2
#
# library(shiny)
# library(miniUI)
# library(DT)
#
# ui <- miniPage(
#   gadgetTitleBar("Send to Neo4j"),
#   miniTabstripPanel(
#     miniTabPanel("Browse file", icon = icon("sliders"),
#                  miniContentPanel(
#                    h3("Browse"),
#                    fileInput("file", label = "Select File"),
#                    selectInput("pkgread", "Read with", choices = c("base::read.csv")),
#                    actionButton("open", "Open"),
#                    DTOutput("preview")
#                  )
#     ),
#     miniTabPanel("Query", icon = icon("address-card"),
#                  miniContentPanel(
#                    h3("Write Neo4J Query"),
#                    hr(),
#                    checkboxInput("withheader", "With header?"),
#                    textAreaInput("code", "How Much", 3),
#                    DTOutput("users")
#                  )
#     )
#     )
#
# )
#
# server <- function(input, output, session) {
#   res <- reactiveValues()
#
#   observeEvent(input$send, {
#     withProgress({
#       res$tweets <- search_tweets(input$query)
#     }, message = "Searching for tweets")
#
#   })
#
#   output$users <- renderDT({
#     req(res$tweets)
#     res$tweets %>%
#       count(screen_name) %>%
#       top_n(as.numeric(input$howmuch)) %>%
#       arrange(n) %>%
#       datatable()
#   })
#
#   output$sentiment <- renderDT({
#     req(res$tweets)
#     res$tweets %>%
#       unnest_tokens(output = word, input = text) %>%
#       # Dataset of stopwords from tidytext
#       anti_join(stop_words) %>%
#       # Filter on custom stopwords
#       filter(! word %in% c("rt","amp","https", "t.co", "rstats") ) %>%
#       inner_join(get_sentiments("nrc"))  %>%
#       count(sentiment) %>%
#       arrange(n) %>%
#       datatable()
#   })
#   observeEvent(input$done, {
#     stopApp()
#   } )
# }
#
# runGadget(ui, server, viewer = dialogViewer("Search twitter"))
#
