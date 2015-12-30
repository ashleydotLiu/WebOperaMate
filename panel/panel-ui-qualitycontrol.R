qcDataUI <- pageWithSidebar(
    headerPanel("Quality Control"),
    sidebarPanel(
        checkboxGroupInput("qc.method", "Quality control method: ", c("plateCorrelation", "wellSd", "zFactor", "cellNumber")),
        checkboxInput("replace.badPlateData", "Replace data of a bad plate by the mean of its replicates", value = TRUE),
        uiOutput("qualityControlUI"),
        actionButton("cellQC", "Quality Control"),
        tags$hr(),
        checkboxGroupInput("qc.downloadTerms", "Items to download:", c("Data after quality control", "Plate quality", "Plate correlation matrixes", "Z factors"), selected = "Data after quality control"),
        downloadButton("downloadQcData", "Download")
        ),
    mainPanel(
        tabsetPanel(
            tabPanel("PlateQC", imageOutput("qc.plate")),
            tabPanel("WellQC", imageOutput("qc.well"))
            ),
        fluidRow(column(width = 12,
                        includeMarkdown("panel/doc/panel-doc-qualitycontrol.md")))
        )
    )
