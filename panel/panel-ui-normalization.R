normDataUI <- pageWithSidebar(
    headerPanel("Normalization"),
    sidebarPanel(
        selectInput("norm.method","Select a normalization method", choices = c("","MP", "PMed", "Z", "Ctr", "None")),
        h3("View data"),
        uiOutput("viewNormDataUI"),
        downloadButton("downloadNormData", "Download"),
        h5("Download the normalized data table")
        ),
    mainPanel(
#        h3(textOutput("cellnamecaption")),
        tabsetPanel(
            tabPanel("Heatmap", imageOutput("heatmap.norm")),
            tabPanel("Boxplot", imageOutput("boxplot.norm"))
            ),
        fluidRow(column(width = 12,
                        includeMarkdown("panel/doc/panel-doc-normalization.md")))
        )
 )
