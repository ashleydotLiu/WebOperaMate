## Data Importing Panel
## Reorganize each type of data
## Row names: the well ID; column names: the plate ID

cellNameList <- reactive({
    lstPlates <- lstPlates()
    if(is.null(lstPlates))
        return(NULL)
    names(lstPlates[[1]]["data"])
})

output$cellNameUI <- renderUI({
    cellnames <- cellNameList()
    if(is.null(cellnames))
        return()
    selectizeInput("cellname", "Analyze item",
                   choices = cellnames,
                   options = list(
                       placeholder = "Please select an item to analyze",
                       onInitialize = I('function() { this.setValue("");}')
                       )
                   )
})

output$cellNumberUI <- renderUI({
    cellnames <- cellNameList()
    if(is.null(cellnames))
        return()
    selectizeInput("cellnumber",
                   "The cell number item",
                   choices = cellnames,
                   options = list(
                       placeholder = "Please select an cell number data",
                       onInitialize = I('function() { this.setValue("");}')
                       )
                   )
})

wellList <- reactive({
    lstPlates <- lstPlates()
    if(is.null(lstPlates))
        return(NULL)
    unique(unlist(lapply(lstPlates,function(x) x["wellID"])))
})
output$posCtrlWellUI <- renderUI({
    well.list <- wellList()
    if(is.null(well.list))
        return()

    selectizeInput("posCtrlWell",
                   "Please select the positive control well",
                   choices = wellList(),
                   multiple = TRUE
                   )
})
output$negCtrlWellUI <- renderUI({
    well.list <- wellList()
    if(is.null(well.list))
        return()

    selectizeInput("negCtrlWell",
                   "Please select the negative control well",
                   choices = wellList(),
                   multiple = TRUE
                   )
})
output$excludeWellUI <- renderUI({
    well.list <- wellList()
    if(is.null(well.list))
        return()

   negWells <- selectizeInput("excludeWell",
                        "Wells not considered in the analysis",
                        choices = wellList(),
                        multiple = TRUE,
                        options = list(create = TRUE)
                        )
    if (length(negWells) == 0) negWells <- NULL
    negWells
})
cellNumber <- reactive({
    if(!input$cellLoad | is.null(input$cellnumber) | input$cellnumber == "") {
        return (NULL)
    }
    cellnum <- cellData(input$cellnumber)
    cellnum <- cellLoad(cellnum, lstPlates(),
                        positive.ctr = reactive(input$posCtrlWell)(),
                        negative.ctr = reactive(input$negCtrlWell)(),
                        neglect.well = reactive(input$excludeWell)())
    cellnum
})
oneCell <<- reactiveValues()
observe({
    if(reactive(input$cellLoad)()){
        onecell <- cellData(input$cellname)
        onecell <- cellLoad(onecell, lstPlates(),
                                positive.ctr = reactive(input$posCtrlWell)(),
                                negative.ctr = reactive(input$negCtrlWell)(),
                                neglect.well = reactive(input$excludeWell)())
        if(!is.null(cellNumber())) {
            onecell <- cellNumLoad(onecell, cellNumber())
        }
        oneCell$obj <- onecell
    }
})
output$viewRawDataUI <- renderUI({
    onecell <- oneCell$obj
    if (is.null(onecell))
        return()
    len <- ncol(onecell["origin.data"])
    fluidPage(
        sliderInput("rawDataVizID", "Please select the plate ID in the visualization",
                    step = 1,
                    min = 1, max = len, value = c(1,len)),
        selectizeInput("rawDataVizName",
                       "Or select the plate names in the visualization",
                       choices = as.character(colnames(onecell["origin.data"])),
                       multiple = TRUE
                       )
        )
})
## Download the original data table
output$downloadOriginData <- downloadHandler(
    filename = function(){paste0(input$cellname,"-originData.csv")},
    content = function(file) {
        origin.data <- NULL
        if(!input$cellLoad){
            session$sendCustomMessage(type = 'testmessage', message = list(content = "Please press 'Import Data' button first"))
        }else{
            onecell <- oneCell$obj
            if(!is.null(onecell))
                origin.data <- onecell["origin.data"]
        }
        write.csv(origin.data, quote = FALSE, file)
    },
    contentType = "text/csv"
    )
output$cellnamecaption <- renderText({
    input$cellname
})
imageRange <- reactive({
    onecell <- oneCell$obj
    if (is.null(onecell))
        return(NULL)
    tmp1 <- input$rawDataVizID
    tmp2 <- input$rawDataVizName
    if (!is.null(tmp2)){
        plateID <- tmp2
    } else if (!is.null(tmp1)) {
        plateID <- tmp1[1]:tmp1[2]
    } else {
        plateID <- NULL
    }
    plateID
})

output$heatmap.raw <- renderImage({
    onecell <- oneCell$obj
    if(is.null(onecell))
        return(list(src = ""))
    plateID <- imageRange()
    cellViz(onecell, data.type = "raw", plot = "heatmap",
            multiplot = TRUE, ctr.excluded = TRUE, plateID = plateID)
    if (length(plateID) != 1) {
        outfile <- file.path(getOption("opm.outpath"), paste("heatmap.raw", onecell["name"],"png",sep="."))
    } else{
        outfile <- file.path(getOption("opm.outpath"), paste(onecell["name"], "-", plateID, ".Visualization.png",sep=""))
    }
    list(src = outfile,contentType="image/png")
},deleteFile=TRUE)

output$boxplot.raw <- renderImage({
    onecell <- oneCell$obj
    if(is.null(onecell))
#        return()
        return(list(src = ""))
    plateID <- imageRange()
    cellViz(onecell, data.type = "raw", plot = "boxplot",
            multiplot = TRUE, ctr.excluded = TRUE, width = 960, plateID = plateID)
    outfile <- file.path(getOption("opm.outpath"), paste("boxplot.raw", onecell["name"],"png",sep = "."))
    list(src = outfile, contentType="image/png")
},deleteFile = TRUE)

## TODO
## width opx height numericInput
## Export figure button

