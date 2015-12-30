hitDetecUI <- pageWithSidebar(
    headerPanel("Hit Detection"),
    sidebarPanel(
        selectInput("sig.method","Select a hit detection method", choices = c("stable", "ksd", "kmsd")),
        uiOutput("hitUI"),
        numericInput("thPval", "p-value threshold", 0.05),
        selectInput("adjust.method", "P-value adjust method", choices = p.adjust.methods, selected = "fdr"),
        fileInput("highlightFile",
                  "Upload the file specifying barcode, well, label(gene) to be highlighted in the volcano plot (.csv)",
                  accept = c('text/csv', 'text/comma-separated-values,text/plain', '.csv')
                  ),
        actionButton("cellSig", "Hit Detection"),

        tags$hr(),

        numericInput("digits", "digits of threshold", 3),
        downloadButton("downloadReport", "Download Report")
        ),
    mainPanel(
        tabsetPanel(
            tabPanel(title = "Volcano Plot", value = "hitVizPanel",
                     verbatimTextOutput("table.hitNoStats"),
                     imageOutput("vc.plot")),
            tabPanel("QQ Plot (method stable)", imageOutput("qqplot"))
            ),
        fluidRow(column(width = 12,
                        includeMarkdown("panel/doc/panel-doc-hitdetection.md")))
        )
    )

