hitFunUI <- pageWithSidebar(
    headerPanel("Hits functional profiling"),
    sidebarPanel(
        selectInput("organism", "Organism",
                    choices = c("Homo sapiens", "Mus musculus", "Saccharomyces cerevisiae",
                        "Rattus norvegicus", "Drosophila melanogaster", "Caenorhabditis elegans",
                        "Danio rerio", "Arabidopsis thaliana"), selected = NULL),
        selectInput("hit.type", "Hit Type", choices = c("All", "High", "Low"), selected = "All"),
        selectInput("bar.color", "Barplot Color", choices = colors(), selected = "steelblue"),
        uiOutput("funTypeUI"),
        downloadButton("downloadEnrich", "Download Profile")
        ),
    mainPanel(
        imageOutput("function.plot"),
        fluidRow(column(width = 12,
                        includeMarkdown("panel/doc/panel-doc-hitfunction.md")))
        )
    )
