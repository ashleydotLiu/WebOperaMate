## Data Normalization Panel

cellStatus <- reactive({
    stats <- (-1)
    onecell <- oneCell$obj
    ifelse(!is.null(onecell),
           stats <- 0,
           return(stats))
    ifelse(length(onecell["origin.data"])!=0,
           stats <- 1,
           return(stats))
    ifelse(length(onecell["norm.data"])!=0,
           stats <- 2,
           return(stats))
    ifelse(length(onecell["qc.data"])!=0,
           stats <- 3,
           return(stats))
    ifelse(length(onecell["Sig"])!=0,
           stats <- 4,
           return(stats))
    stats
})


observe({
    if(cellStatus() > 0 & !is.null(input$norm.method) & input$norm.method != "") {
        onecell <- cellNorm(oneCell$obj, norm.method = input$norm.method)
        oneCell$obj <- onecell
    }
})

## Download the normalized data table
output$downloadNormData <- downloadHandler(
    filename = function(){paste0(input$cellname,"-normData.csv")},
    content = function(file) {
        norm.data <- oneCell$obj["norm.data"]

        write.csv(norm.data, quote = FALSE, file)
    },
    contentType = "text/csv"
    )
output$viewNormDataUI <- renderUI({
    onecell <- oneCell$obj
    if (is.null(onecell))
        return()
    len <- ncol(onecell["norm.data"])
    fluidPage(
        sliderInput("normDataVizID", "Please select the plate ID in the visualization",
                    step = 1,
                    min = 1, max = len, value = c(1,len)),
        selectizeInput("normDataVizName",
                       "Or select the plate names in the visualization",
                       choices = as.character(colnames(onecell["norm.data"])),
                       multiple = TRUE
                       )
        )
})

imageRangeNorm <- reactive({
    onecell <- oneCell$obj
    if (is.null(onecell))
        return(NULL)
    tmp1 <- input$normDataVizID
    tmp2 <- input$normDataVizName
    if (!is.null(tmp2)){
        plateID <- tmp2
    } else if (!is.null(tmp1)) {
        plateID <- tmp1[1]:tmp1[2]
    } else {
        plateID <- NULL
    }
    plateID
})

output$heatmap.norm <- renderImage({
    onecell <- oneCell$obj
    if(cellStatus()<2)
        return(list(src = ""))
    plateID <- imageRangeNorm()
    cellViz(onecell, data.type = "norm", plot = "heatmap",
            multiplot = TRUE, ctr.excluded = TRUE, plateID = plateID)
    if (length(plateID) != 1) {
        outfile <- file.path(getOption("opm.outpath"), paste("heatmap.norm", onecell["name"],"png",sep="."))
    } else{
        outfile <- file.path(getOption("opm.outpath"), paste(onecell["name"], "-", plateID, ".Visualization.png",sep=""))
    }
    list(src = outfile,contentType="image/png")
}, deleteFile = TRUE)

output$boxplot.norm <- renderImage({
    onecell <- oneCell$obj
    if(cellStatus()<2)
        return(list(src = ""))
    plateID <- imageRangeNorm()
    cellViz(onecell, data.type = "norm", plot = "boxplot",
            multiplot = TRUE, ctr.excluded = TRUE, width = 960, plateID = plateID)
    outfile <- file.path(getOption("opm.outpath"), paste("boxplot.norm", onecell["name"],"png",sep = "."))
    list(src = outfile, contentType="image/png")
}, deleteFile = TRUE)
