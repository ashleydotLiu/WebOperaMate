loadDataUI <- pageWithSidebar(
    headerPanel("Data Uploading"),
    sidebarPanel(
        fileInput("zipFile",
                  "Upload compressed file (.zip)",
                  accept = ".zip"),
        fileInput("geneInfoFile",
                  "Upload well-gene specification file (.csv)",
                  accept = c('text/csv', 'text/comma-separated-values,text/plain', '.csv')
                  ),
        numericInput("geneMapSkip",
                     "Number of lines before column names",
                     value = 0),

        tags$hr(),

        checkboxInput("ifPlateMapFile",
                      "Upload a customized file information table", value = FALSE),
        textInput("egFilename",
                  "An example of data file name"),
        textInput("sep",
                  "Seperator"),
        textInput("plateID",
                  "Plate ID"),
        textInput("repID",
                  "Replication ID"),
        textInput("barcodeID",
                  "Barcode in the specification file"),

        tags$hr(),

        radioButtons("format",
                     "File format",
                     choices = list("Matrix" = "Matrix",
                         "Table" = "Tab"),
                     selected = character(0)
                     ),
        fileInput("plateInfoFile",
                  "Upload customized file information table",
                  accept = c('text/csv', 'text/comma-separated-values,text/plain', '.csv')
                  ),
        downloadButton("downloadPlateMap", "Download"),
        h5("Download the table displays in 'uploaded file' panel"),

        br(),

        actionButton("loadAll", "Start analyzing!")
          ),
    mainPanel(
        tabsetPanel(id = "tabs1",
                    tabPanel(title="Uploaded File",value="uploadFilePanel",
                             verbatimTextOutput("table.plateNoStats"),
                             dataTableOutput("table.plateMap")),
                    tabPanel(title="Well-Gene Mapping Table",
                             value = "geneMapPanel",
                             dataTableOutput("table.geneMap"))
                    ),
        fluidRow(column(width = 12,
                        includeMarkdown("panel/doc/panel-doc-dataload.md")))
        )
    )


