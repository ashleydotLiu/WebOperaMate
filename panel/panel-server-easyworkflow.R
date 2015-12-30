## Data process and analysis pipeline panel

## File reading
dataPathE <- reactive ({
    inFile <- input$zipFileEasy
    if (is.null(inFile))
        return(NULL)
    # Directory to extract files
    dataPath <- file.path(dirname(inFile$datapath), "dataFolder")
    unzip(inFile$datapath, exdir = dataPath)
    dataPath
})

geneMapE <- reactive ({
    ## Import the mapping file of the gene information of each well
    inFile <- input$geneInfoFileEasy
    if (is.null(inFile))
        return(NULL)

    genemap <- read.csv(inFile$datapath, stringsAsFactors = FALSE)
    colnames(genemap) <- tolower(colnames(genemap))
    validate(
        need(all(c("barcode", "well", "genesymbol") %in% colnames(genemap)),
             "The first line of well-gene specification file should include the item: Barcode, Well, GeneSymbol.")
        )
    colnames(genemap)[colnames(genemap) == "barcode"] <- "Barcode"
    colnames(genemap)[colnames(genemap) == "well"] <- "Well"
    colnames(genemap)[colnames(genemap) == "genesymbol"] <- "GeneSymbol"
    genemap
})

parE <- reactive ({
    ## Import configuration file
    inFile <- input$configFileEasy
    if (is.null(inFile))
        return(NULL)

    op.par <- configParser(inFile$datapath)
    validate(
        need(!is.null(op.par[["cellnames"]]),
             "No item names provided to analyze!")
        )
    op.par
})
output$platemapUploadUI <- renderUI({
    if (!input$ifPlateMapFile.easy)
        return()
    fileInput("plateInfoFile.easy",
              "Upload the customized file table",
              accept = c('text/csv', 'text/comma-separated-values,text/plain', '.csv')
              )
})

## plateMapE <- reactive ({
##     if (is.null(dataPathE()) | is.null(parE()))
##         return(NULL)
##     lstFiles <- unlist(list.files(dataPathE(), recursive = TRUE, full.names = TRUE))
##     op.par <- parE()
##     platemap <- NULL
##     if (input$ifPlateMapFile.easy) {
##         inFile <- input$plateInfoFile.easy
##         if (is.null(inFile))
##             return(NULL)
##         platemap <- read.csv(inFile$datapath, stringsAsFactors = FALSE)
##         ID <- match(basename(lstFiles), platemap$FileName)
##         platemap <- platemap[ID, ]
##         platemap$Path <- lstFiles
##         platemap <- platemap[!is.na(ID),]
##         tmp <- sapply(split(platemap$RepID, platemap$PlateID), length)
##         platemap$RepNumber <- tmp[match(platemap$PlateID, names(tmp))]
##     } else {
##         if(is.null(op.par[["egFilename"]])) {
##             platemap <- NULL
##         } else {
##             size <- length(lstFiles)
##             platemap <- data.frame(FileName = basename(lstFiles),
##                                    Format = rep("-", size),
##                                    PlateID = rep("-", size),
##                                    RepID = rep("-", size),
##                                    RepNumber = rep("-", size),
##                                    Barcode = rep("-", size),
##                                    Path = lstFiles,
##                                    stringsAsFactors = FALSE)
##             platemap$Format <- rep(op.par[["format"]], size)
##             catchInfo <- try(tmp <- nameParser(lstFiles, op.par[["egFilename"]]))
##             if (class(catchInfo) != "try-error") {
##                 platemap$RepID <- tmp$RepID
##                 platemap$Barcode <- tmp$Barcode
##                 platemap$PlateID <- tmp$PlateID
##                 tmp <- sapply(split(platemap$RepID, platemap$PlateID), length)
##                 platemap$RepNumber <- tmp[match(platemap$PlateID, names(tmp))]
##             } else {
##                 platemap <- NULL
##             }
##         }
##     }
##     print(head(platemap))
##     platemap
## })

## Output panels
## Panel Progress
output$progress.start.easy <- renderText({
    if(is.null(dataPathE()) | is.null(parE()))
        return()
    paste(
        paste("[",format(Sys.time(), "%m-%d-%Y %T"),"]"),
        paste(" WebOperaMate Data Processing & Analysis"),
        paste("********************************************************"), sep = "\n")
})
output$progress.end.easy <- renderText({
    if(is.null(lstCellsE()) | is.null(generalReportE())|
       is.null(detailReportE())|is.null(cellFunE()))
        return()
    paste("Done.")
})
output$blank1 <- renderText({
    paste("\n\n\n\n\n\n")
})
output$blank2 <- renderText({
    paste("\n\n\n\n\n\n")
})
output$blank3 <- renderText({
    paste("\n\n\n\n\n\n")
})
output$blank4 <- renderText({
    paste("\n\n\n\n\n\n")
})
output$blank5 <- renderText({
    paste("\n\n\n\n\n\n")
})
output$blank6 <- renderText({
    paste("\n\n\n\n\n\n")
})
## Panel 1: Well-Gene Mapping Table
output$table.genemap.easy <- renderDataTable({
    geneMapE()
}, options = list(pageLength = 15))
## Panel 2: Configuration
output$config.file.content <- renderText({
    config <- file(input$configFileEasy$datapath, open = "r")
    lines <- readLines(config)
    ID <- grep("^#", lines)
    lines <- gsub(" *", "", lines[-ID])
    close(config)
    paste(lines, collapse = "\n")
})
## Panel 3: File information
## output$table.platemap.easy <- renderDataTable({
##     platemap <- plateMapE()
##     if(!is.null(platemap)){
##         platemap <- subset(platemap, select = -Path)
##     }
##     platemap
## }, options = list(pageLength = 15))


## Run functions
lstCellsE <- eventReactive(input$easyProcs, {
    flag <- !is.null(dataPathE()) & !is.null(parE())
    validate(
        need(flag,
             "Please upload data and configuration file."),
        need(!is.null(geneMapE()),
             "Functional profiling cannot perform without well-gene specification file.")
        )
    if(!flag) return(NULL)

    isolate({ operaMate(dataPathE(), geneMapE(), parE(), platemap = NULL)})
})

generalReportE <- reactive({
    if (is.null(lstCellsE()))
        return(NULL)
    report <- generateReport(lstCellsE(), geneMapE(), verbose = FALSE,
                             file = NULL, plot = FALSE)
    report
})

detailReportE <- reactive({
    if (is.null(lstCellsE()))
        return(NULL)

    isolate({
        lapply(lstCellsE(), function(cell) {
            generateReport(list(cell), geneMapE(), verbose = TRUE,
                           file = NULL, plot = FALSE)
        })
    })
})

cellFunE <- reactive({
    genemap <- geneMapE()
    lstCells <- lstCellsE()
    op.par <- parE()
    validate(
        need(!is.null(genemap),
             "Functional profiling cannot perform without well-gene specification file.")
        )

    if(is.null(genemap) | is.null(lstCells))
        return(NULL)
    isolate({
        lapply(lstCells,function(cell){
            chart <- cellSigAnalysis(cell, genemap, op.par[["organism"]],
                                     file = NULL)
            chart
        })
    })
})

## Render Checkbox UI
output$selectCellUI <- renderUI({
    lstCells <- lstCellsE()
    if (is.null(lstCells)) {
        return()
    }
    cellnames <- sapply(lstCells, function(obj) obj["name"])
    selectInput("cellShowE", "Select an item to show", choices = cellnames, selected = parE()[["cellnames"]][1])
})

## Panel 4: General report
output$table.generalReport.easy <- renderDataTable({
    generalReportE()
}, options = list(pageLength = 15, scrollX = TRUE))

output$image.statistics.easy <- renderImage({
    lstCells <- lstCellsE()
    if(is.null(lstCells))
        return(list(src = ""))
    cellnames <- sapply(lstCells, function(obj) obj["name"])
    stats <- unlist(lapply(lstCells, function(obj) {
        st <- obj["Sig"]$stats[c("Low","High")]
        return(st)
    }))
    summaryBarPlot(stats, cellnames, getOption("opm.outpath"))
    outfile <- file.path(getOption("opm.outpath"), "Statistics.png")
    list(src = outfile, contentType="image/png")
}, deleteFile = FALSE)
## Panel 5: Detailed report
output$table.detailReport.easy <- renderDataTable({
    detailReportE()[[input$cellShowE]]
}, options = list(pageLength = 15, scrollX = TRUE))
output$image.vcplot.easy <- renderImage({
    lstCells <- lstCellsE()
    cellname <- input$cellShowE
    cell <- lstCells[[input$cellShowE]]
    if(is.null(cell))
        return(list(src = ""))
    cellSigPlot(cell, outpath = getOption("opm.outpath"), heigth = 240)
    outfile <- file.path(getOption("opm.outpath"), paste(cell["name"], "volcanoPlot.png", sep = "."))
    list(src = outfile, contentType="image/png")
}, deleteFile = FALSE)

## Panel 6: Functional profiling Panel
output$table.function.easy <- renderDataTable({
    cellFunE()[[input$cellShowE]]
}, options = list(pageLength = 15, scrollX = TRUE))
output$image.function.easy <- renderImage({
    chart <- cellFunE()[[input$cellShowE]]
    if(is.null(chart))
        return(list(src = ""))
    cellSigAnalysisPlot(chart, prefix = input$cellShowE)
    outfile <- file.path(getOption("opm.outpath"), paste(input$cellShowE, "HitFunctions.png", sep = "."))
    list(src = outfile, contentType="image/png")
}, deleteFile = FALSE)
## Panel 7: Data visualization
output$image.rawdata.heatmap.easy <- renderImage({
    outfile <- file.path(getOption("opm.outpath"), paste("heatmap.raw", input$cellShowE, "png", sep = "."))
    if(!file.exists(outfile)) {
        return(list(src = ""))
    }
    list(src = outfile, contentType="image/png")
}, deleteFile = FALSE)
output$image.normdata.heatmap.easy <- renderImage({
    outfile <- file.path(getOption("opm.outpath"), paste("heatmap.norm", input$cellShowE, "png", sep = "."))
    if(!file.exists(outfile)) {
        return(list(src = ""))
    }
    list(src = outfile, contentType="image/png")
}, deleteFile = FALSE)
output$image.boxplot.easy <- renderImage({
    outfile <- file.path(getOption("opm.outpath"), paste("boxplot.raw&norm", input$cellShowE, "png", sep = "."))
    if(!file.exists(outfile)) {
        return(list(src = ""))
    }
    list(src = outfile, contentType="image/png")
}, deleteFile = FALSE)
## Panel 8: Quality control
output$image.plateqc.easy <- renderImage({
    outfile <- file.path(getOption("opm.outpath"), paste(input$cellShowE,"plateQualityControl.png", sep = "."))
    if(!file.exists(outfile)) {
        return(list(src = ""))
    }
    list(src = outfile, contentType="image/png")
}, deleteFile = FALSE)
output$image.wellqc.easy <- renderImage({
    outfile <- file.path(getOption("opm.outpath"), paste(input$cellShowE, "wellQualityControl.png", sep = "."))
    if(!file.exists(outfile)) {
        return(list(src = ""))
    }
    list(src = outfile, contentType="image/png")
}, deleteFile = FALSE)

output$downloadEasy <- downloadHandler(
    filename = function(){paste0("operaMateReport.zip")},
    content = function(file) {

        write.table(generalReportE, row.names = FALSE, sep = "\t",
                    quote = FALSE, file = file.path(getOption("opm.outpath"), "Summary.txt"))
        lapply(names(detailReportE), function(cellname) {
            write.table(detailReportE[[cellname]], row.names = FALSE, sep = "\t",
                        quote = FALSE, file = file.path(getOption("opm.outpath"),
                                           paste(cellname, "Data.txt", sep = ".")))
        })
        lapply(names(cellFunE), function(cellname) {
            write.table(cellFunE[[cellname]], row.names = FALSE, sep = "\t",
                        quote = FALSE, file = file.path(getOption("opm.outpath"),
                                           paste(cellname, "Functions.txt", sep = ".")))
        })
        zip(zipfile = file,  files = list.files(getOption("opm.outpath")))
    },
    contentType = "zip"
    )

