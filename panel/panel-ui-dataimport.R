importDataUI <- pageWithSidebar(
    headerPanel("Data Importing and Visualization"),
    sidebarPanel(
        uiOutput("cellNameUI"),
        uiOutput("posCtrlWellUI"),
        uiOutput("negCtrlWellUI"),
        uiOutput("excludeWellUI"),
        uiOutput("cellNumberUI"),
        actionButton("cellLoad", "Import Data"),
        tags$hr(),
        h3("View data"),
        uiOutput("viewRawDataUI"),
        downloadButton("downloadOriginData", "Download"),
        h5("Download the imported data table"),
        singleton(
            tags$head(tags$script('Shiny.addCustomMessageHandler("testmessage",
  function(message) {
    alert(message.content);
  }
);'))
            )
        ),
    mainPanel(
        h3(textOutput("cellnamecaption")),
        tabsetPanel(
            tabPanel("Heatmap", imageOutput("heatmap.raw")),
            tabPanel("Boxplot", imageOutput("boxplot.raw"))
            ),
        fluidRow(column(width = 12,
                        includeMarkdown("panel/doc/panel-doc-dataimport.md")))
        )
    )

