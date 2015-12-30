## Quality control panel

qcMethod <- reactive({
    input$qc.method
})
qcDownload <- reactive({
    input$qc.downloadTerms
})
observe({
    if(cellStatus() > 1 & input$cellQC) {
        oneCell$obj <- cellQC(oneCell$obj,
                              qcType = qcMethod(),
                              qc.threshold = c(correlation = input$pth,
                              zfactor = input$zth,
                              cellnumber = input$nth),
                              replace.badPlateData = input$replace.badPlateData)
    }
})

output$qualityControlUI <- renderUI({
    fluidPage(
        if ("plateCorrelation" %in% qcMethod()) {
            numericInput("pth", "The minimum correlation between the replicates", value = 0.8, min = 0, max = 1, step = 0.1)
        },
        if("zFactor" %in% qcMethod()) {
            numericInput("zth", "The z' factor threshold", value = 0.5, max = 1, step = 0.1)
        },
        if("cellNumber" %in% qcMethod()) {
            numericInput("nth", "The cell number threshold", value = 50, min = 0, step = 10)
        }
        )
})

output$qc.well <- renderImage({
    if(cellStatus()<3)
        return(list(src = ""))
    outfile <- file.path(getOption("opm.outpath"), paste(oneCell$obj["name"],".wellQualityControl.png", sep = ""))
    list(src = outfile, contentType = "image/png")
}, deleteFile = TRUE)

output$qc.plate <- renderImage({
    if(cellStatus()<3)
        return(list(src = ""))
    outfile <- file.path(getOption("opm.outpath"), paste(oneCell$obj["name"],".plateQualityControl.png", sep = ""))
    list(src = outfile, contentType = "image/png")
}, deleteFile = TRUE)

output$downloadQcData <- downloadHandler(
    filename = function(){paste0(input$cellname,"-qcData.zip")},
    content = function(file) {
        filenames <- c(paste0(input$cellname,"-qcData.csv"),
                       paste0(input$cellname,"-PlateQuality.csv"),
                       paste0(input$cellname,"-PlateCorrelation.csv"),
                       paste0(input$cellname,"-qcData.csv"))
        flag <- rep(FALSE, 4)

        if ("Data after quality control" %in% qcDownload()) {
            qc.data <- oneCell$obj["qc.data"]
            write.csv(qc.data, quote = FALSE, filenames[1])
            flag[1] <- TRUE
        }
        if ("Plate quality" %in% qcDownload()) {
            plate.quality <- oneCell$obj["plate.quality"]
            if (length(plate.quality)) {
                write.csv(plate.quality, quote = FALSE, filenames[2])
                flag[2] <- TRUE
            }
        }
        if ("Plate correlation matrixes" %in% qcDownload()) {
            cor.data <- oneCell$obj["plate.quality.data"]$plate.correlation
            if (length(cor.data) > 0) {
                cor.data <- do.call(cbind, cor.data)
                write.csv(cor.data, quote = FALSE, filenames[3])
                flag[3] <- TRUE
            }
        }
        if ("Z factors" %in% qcDownload()) {
            zfactor <- oneCell$obj["plate.quality.data"]$plate.zfactor
            if(!is.null(zfactor)) {
                write.csv(qc.data, quote = FALSE, filenames[4])
                flag[4] <- TRUE
            }
        }
       zip(zipfile = file,  files = filenames[flag])
    },
    contentType = "zip"
    )
