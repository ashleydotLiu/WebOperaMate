## Hit detection panel

observe({
    if(cellStatus() > 2 & input$cellSig) {
        onecell <- try(cellSig(oneCell$obj,
                               method = input$sig.method,
                               th = hitThresholds(),
                               thPval = input$thPval,
                               digits = input$digits,
                               adjust.method = input$adjust.method))
        if (class(onecell[1]) == "try-error") {
            warning("Hit detection failed.")
            return()
        }
        oneCell$obj <- onecell
    }
})

hitThresholds <- reactive({
    thLow <- input$thLow
    thHigh <- input$thHigh
    if (input$sig.method == "stable") {
        thLow <- ifelse(thLow > 1, 0.05, thLow)
        thHigh <- ifelse(thHigh > 1, 0.05, thHigh)
    }
    c(thLow, thHigh)
})
output$hitUI <- renderUI({
    fluidPage(
        numericInput("thLow", "low threshold", ifelse(input$sig.method == "stable", 0.05, 3), min = 0),
        numericInput("thHigh", "high threshold", ifelse(input$sig.method == "stable", 0.05, 3), min = 0)
        )
})
output$vc.plot <- renderImage({
    if(cellStatus() < 4 )
        return(list(src = ""))
    highlight.label <- highlightLabels()
    trySig <- try(cellSigPlot(oneCell$obj, highlight.label =  highlight.label))
    if (class(trySig[1]) == "try-error") {
        warning("Visualization failed.")
        return(list(src = ""))
    }
    outfile <- file.path(getOption("opm.outpath"), paste(oneCell$obj["name"],".vocalnoPlot.png", sep = ""))
    list(src = outfile, contentType = "image/png")
}, deleteFile = TRUE)

output$qqplot <- renderImage({
    if(cellStatus() < 4 | input$sig.method != "stable")
        return(list(src = ""))

    outfile <- file.path(getOption("opm.outpath"), paste(oneCell$obj["name"],".dataFitting.png", sep = ""))
    list(src = outfile, contentType = "image/png")
}, deleteFile = TRUE)

output$table.hitNoStats <- renderText({
    statMat <- statMat()
    if (!is.null(statMat))
        paste(paste(statMat[1,]), paste(statMat[2,]), sep = "\n")
})
statMat <- reactive({
    if (cellStatus() < 4)
        return(NULL)
    threshold <- oneCell$obj["Sig"]$threshold[c("Low", "High")]
    stats <- oneCell$obj["Sig"]$stats[c("Low","High")]
    statMat <- cbind(c("threshold", "number"), rbind(threshold, stats))
    statMat
})
## Download the normalized data table
output$downloadReport <- downloadHandler(
    filename = function(){paste0(input$cellname,"-report.txt")},
    content = function(file) {
        report <- generateReport(list(oneCell$obj), geneMap(), verbose = TRUE,
                                 file = NULL, plot = FALSE)

        write("Analysis Report", file = file)
        suppressWarnings(write.table(statMat(), row.names = FALSE, sep = "\t",
                                     file = file, quote = FALSE, append = TRUE))
        cat("\n",file = file, append = TRUE)
        suppressWarnings(write.table(report, file = file,
                                     append = TRUE,  sep = "\t", quote = FALSE,
                                     row.names = FALSE, col.names = TRUE))
    },
    contentType = "text/txt"
    )

highlightLabels <- reactive({
    inFile <- input$highlightFile
    if (is.null(inFile))
        return(NULL)

    highlighttable <- read.csv(inFile$datapath, stringsAsFactors = FALSE,
                               header = FALSE)

    labels <- highlighttable[,3]
    names(labels) <- paste(highlighttable[,1], highlighttable[,2], sep = ":")

    labels
})



