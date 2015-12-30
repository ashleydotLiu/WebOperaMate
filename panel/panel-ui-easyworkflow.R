easyProcsUI <- pageWithSidebar(
    headerPanel("Cellular Protein Reorganization Analysis"),
    sidebarPanel(
        fileInput("zipFileEasy",
                  "Upload compressed file (.zip)",
                  accept = ".zip"),
        fileInput("geneInfoFileEasy",
                  "Upload well-gene specification file (.csv)",
                  accept = c('text/csv', 'text/comma-separated-values,text/plain', '.csv')
                  ),
        fileInput("configFileEasy",
                  "Upload configuration file (.txt)",
                  accept = c('text/txt', '.txt')
                  ),
        uiOutput("selectCellUI"),
        actionButton("easyProcs", "Start analyzing!"),
        checkboxInput("ifPlateMapFile.easy",
                      "Need a customized file information table?", value = FALSE),
        uiOutput("platemapUploadUI"),
        downloadButton("downloadEasy", "Download")
        ),
    mainPanel(
        tags$head(
            tags$style(HTML("
               .shiny-output-error-validation {
                         color: red;
                }
             "))
            ),
        tabsetPanel(
            tabPanel("Progress", verbatimTextOutput("progress.start.easy"),
                     verbatimTextOutput("progress.end.easy")),
            tabPanel("Well-Gene Mapping Table", dataTableOutput("table.genemap.easy")),
            tabPanel("Configuration", verbatimTextOutput("config.file.content")),
##            tabPanel("File information", dataTableOutput("tabLe.platemap.easy")),
            tabPanel("General report",
                     imageOutput("image.statistics.easy"),
                     verbatimTextOutput("blank1"),
                      dataTableOutput("table.generalReport.easy")                  ),
             tabPanel("Detailed report",
                      imageOutput("image.vcplot.easy"),
                     verbatimTextOutput("blank2"),
                      dataTableOutput("table.detailReport.easy")),
             tabPanel("Functional profiling",
                      imageOutput("image.function.easy"),
                      verbatimTextOutput("blank3"),
                      dataTableOutput("table.function.easy")),
             tabPanel("Data visualization",
                      h4("Heatmap of raw data"),
                      imageOutput("image.rawdata.heatmap.easy"),
                      h4("Heatmap of normalized data"),
                      imageOutput("image.normdata.heatmap.easy"),
                      h4("Boxplot"),
                      imageOutput("image.boxplot.easy"),
                      verbatimTextOutput("blank4")
                      ),
            tabPanel("Quality control",
                     h4("Pearson correlation of replicated plates"),
                     imageOutput("image.plateqc.easy"),
                     verbatimTextOutput("blank5"),
                     h4("Boxplot of standard deviation of replicated wells based on mean values"),
                     imageOutput("image.wellqc.easy"),
                     verbatimTextOutput("blank6")
                     )
            ),
        fluidRow(column(width = 12,
                        includeMarkdown("panel/doc/panel-doc-easyworkflow.md")))
        )
    )


