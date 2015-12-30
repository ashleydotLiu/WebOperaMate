## Data Uploading Panel

## Unzip the loaded compressed file and
## extract the directory of the extracted files
dataPath <- reactive ({
    inFile <- input$zipFile
    if (is.null(inFile))
        return(NULL)

    # Directory to extract files
    dataPath <- file.path(dirname(inFile$datapath), "dataFolder")
    unzip(inFile$datapath, exdir = dataPath)

    dataPath
})

## Import the mapping file of the gene information of each well
geneMap <- reactive ({
    inFile <- input$geneInfoFile
    if (is.null(inFile))
        return(NULL)

    genemap <- read.csv(inFile$datapath, stringsAsFactors = FALSE,
             skip = input$geneMapSkip)
    colnames(genemap) <- tolower(colnames(genemap))
    colnames(genemap)[colnames(genemap) == "barcode"] <- "Barcode"
    colnames(genemap)[colnames(genemap) == "well"] <- "Well"
    colnames(genemap)[colnames(genemap) == "genesymbol"] <- "GeneSymbol"
    genemap
})

## Extract the plate unique ID and other required information
## from file names
plateMap <- reactive ({
    if (is.null(dataPath()))
        return(NULL)
    lstFiles <- unlist(list.files(dataPath(), recursive = TRUE, full.names = TRUE))
    if (input$ifPlateMapFile) {
        inFile <- input$plateInfoFile
        if (is.null(inFile))
            return(NULL)
        platemap <- read.csv(inFile$datapath, stringsAsFactors = FALSE)
        ID <- match(basename(lstFiles), platemap$FileName)
        platemap <- platemap[ID, ]
        platemap$Path <- lstFiles
        platemap <- platemap[!is.na(ID),]
        tmp <- sapply(split(platemap$RepID, platemap$PlateID), length)
        platemap$RepNumber <- tmp[match(platemap$PlateID, names(tmp))]
        exist.platemap <<- TRUE
    } else {
        size <- length(lstFiles)
        platemap <- data.frame(FileName = basename(lstFiles),
                               Format = rep("-", size),
                               PlateID = rep("-", size),
                               RepID = rep("-", size),
                               RepNumber = rep("-", size),
                               Barcode = rep("-", size),
                               Path = lstFiles,
                               stringsAsFactors = FALSE)
        if (length(input$format))
            platemap$Format <- rep(input$format, size)
        ## Extract plateID and replicationID according to the rules
        ## of the example file name
        exist.platemap <<- FALSE
        if(input$egFilename!="" & input$sep!=""
           &input$plateID!="" & input$repID!=""){

            egFile <- list(eg.filename = input$egFilename,
                           rep.id = input$repID,
                           exp.id = input$plateID,
                           sep = input$sep,
                           barcode = input$barcodeID)
            catchInfo <- try(tmp <- nameParser(lstFiles, egFile))
            if (class(catchInfo) != "try-error") {
                platemap$RepID <- tmp$RepID
                platemap$Barcode <- tmp$Barcode
                platemap$PlateID <- tmp$PlateID
                tmp <- sapply(split(platemap$RepID, platemap$PlateID), length)
                platemap$RepNumber <- tmp[match(platemap$PlateID, names(tmp))]
                exist.platemap <<- TRUE
            }
        }
    }
    platemap
})

## Show the information extracted from the file names
output$table.plateMap <- renderDataTable({
    platemap <- plateMap()
    if(!is.null(platemap)){
        platemap <- subset(platemap, select = -Path)
    }
    platemap
}, options = list(pageLength = 15))

output$table.geneMap <- renderDataTable({
    geneMap()
}, options = list(pageLength = 15))

output$table.plateNoStats <- renderText({
    data <- plateMap()
    if (!is.null(data)){
        if (data$RepID[1] != "-"){
             paste(
                paste("No of Items:", nrow(data)),
                paste("No of Plates:", length(unique(data$PlateID))),
                paste("No of Replicates for plates: ", paste(unique(data$RepNumber), collapse="/")),
                sep = "\n")
        }
    }
})
## Download the plateMap() table to modify it
## If the extracted information from the file names are not expected,
## you can download and modify it, and upload it again.
output$downloadPlateMap <- downloadHandler(
    filename <- "plateMap.csv",
    content <- function(file) {
        platemap <- plateMap()
        if(!is.null(platemap)){
            platemap <- subset(platemap, select = -Path)
        }
        write.csv(platemap, file, row.names = FALSE)
    }
    )
loadAllTag <- reactive({
    input$loadAll
})
lstPlates <- eventReactive(loadAllTag(), {
    if(!exist.platemap)
        return(NULL)
    loadAll(platemap = plateMap())
})

observeEvent(loadAllTag(),{
    updateTabsetPanel(session,"tabs1",selected="uploadFilePanel")
    lstPlates()
})

