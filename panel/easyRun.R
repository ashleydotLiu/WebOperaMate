configParser <- function(configFile) {
    op.par <- list()
    config <- file(configFile, open = "r")
    lines <- readLines(config)
    ID <- grep("^#", lines)
    lines <- gsub(" *", "", lines[-ID])
    lstlines <- strsplit(lines, ":")
    i <- 0
    for (line in lstlines) {
        i <- i + 1
        if (length(line) == 1) {
            eval(parse(text = paste("op.par[[\"", line[1], "\"]] <- NULL", sep = "")))
        } else {
            tmp <- paste("\"", unlist(strsplit(line[2], ",")), "\"", sep = "")
            if (length(tmp) > 1){
                tmp <- paste("c(", paste(tmp, collapse = ","), ")", sep = "")
            }
            eval(parse(text = paste("op.par[[\"", line[1], "\"]] <- ", tmp, sep = "")))
        }
    }
    if (is.null(op.par[["eg.filename"]]) | is.null(op.par[["rep.id"]]) | is.null(op.par[["exp.id"]])
        | is.null(op.par[["sep"]]) | is.null(op.par[["barcode"]])) {
        warning("File format  is not clear. The standard format will be used.")
        egFilename <- getOption("opm.filename.example")
    } else{
        egFilename <- list(eg.filename = op.par[["eg.filename"]], rep.id = op.par[["rep.id"]],
                           exp.id = op.par[["exp.id"]], sep = op.par[["sep"]], barcode = op.par[["barcode"]])
    }
    op.par[["egFilename"]] <- egFilename
    ## if (is.null(cellnames)) {
    ##     stop ("Please specify the terms to analyze!")
    ## }
    opm.QC.threshold <- vector()
    if (!is.null(op.par[["correlationTh"]]))
        opm.QC.threshold["correlation"] <- op.par[["correlationTh"]]
    if (!is.null(op.par[["zfactorTh"]]))
        opm.QC.threshold["zfactor"] <- op.par[["zfactorTh"]]
    if (!is.null(op.par[["cellnumberTh"]]))
        opm.QC.threshold["cellnumber"] <- op.par[["cellnumberTh"]]
    mode(opm.QC.threshold) <- "numeric"
    op.par[["opm.QC.threshold"]] <- opm.QC.threshold
    mode(op.par[["sig.threshold"]]) <- "numeric"
    mode(op.par[["sig.pvalue.threshold"]]) <- "numeric"
    mode(op.par[["well.digits"]]) <- "numeric"
    mode(op.par[["if.replace.badPlateData"]]) <- "logical"

    close(config)

    op.par
}
summaryBarPlot <- function(stats, cellnames, outpath) {
    png(file.path(outpath, "Statistics.png"))
    stats.ggplot <- data.frame(count = stats,
                               subType = names(stats),
                               Type = rep(cellnames, each = 2)
                               )
    xlab.ggplot <- apply(stats.ggplot, 1, function(x)
                         sub(paste0(x["Type"], "."), "", x["subType"]))
    print(ggplot(data = stats.ggplot, aes(x = subType, y = count)) +
          geom_bar(aes(fill = Type), stat = "identity") +
          scale_x_discrete(labels = xlab.ggplot ) +
          geom_text(aes(label = count)) +
          xlab(""))
    dev.off()
}

#' #' Data process and analysis pipeline
#'
#' A systematical pipeline for opera data importing, normalization, quality
#' control, hit detection, analysis, and visualization.
#' @param configFile the location of the file specifying all parameters
#' @param gDevice the graphics device
#' @param ... addition arguments for graphics devices
#' @return a list of three components:  a list of cellData objects, the
#' annotated table of each well, and the enrichment analysis table
#' @export
#' @examples
#' configFile <- file.path(system.file("Test", package = "OperaMate"),
#' "demoData", "demoParam.txt")
#' operaReport <- operaMate(configFile, gDevice = "png")
#' head(operaReport$report)
#'
operaMate <- function(datapath, genemap, op.par, platemap = NULL) {

    outpath <- tempdir()
    op <- options("device")
    options("device" = "png")
    cellnames <- op.par[["cellnames"]]

    lstPlates <- loadAll(cellformat = op.par[["cellformat"]], datapath = datapath,
                         egFilename = op.par[["egFilename"]], well.digits = op.par[["well.digits"]],
                         platemap = platemap)

    cellnames.1 <- cellnames[cellnames %in% names(lstPlates[[1]]["data"])]
    if("Average.Total.Intensity" %in% cellnames){
        cellnames.1 <- unique(c("Average.Intensity.of.Nuclei",
                                "Average.Intensity.of.Cytoplasm", cellnames.1))
    }
    lstCells <- list()
    for(cellname in c("Cells.Analyzed", cellnames.1)){
        oneCell <- cellData(cellname)
        lstCells[[cellname]] <- cellLoad(oneCell, lstPlates,
                                         positive.ctr = op.par[["positive.control"]],
                                         negative.ctr = op.par[["negative.control"]],
                                         neglect.well = op.par[["neglect.well"]],
                                         expwell = op.par[["case.well"]])
    }
    cell.cellNum <- lstCells[["Cells.Analyzed"]]
    lstCells <- lstCells[-1]
    lstCells <- lapply(lstCells, function(cell) {
        cellNumLoad(cell, cell.cellNum)
    })
    lstCells <- lapply(lstCells,function(cell){
        cellNorm(cell, norm.method = op.par[["norm.method"]])
    })

    for(cell in lstCells){
        cellViz(cell, outpath = outpath, multiplot = TRUE)
    }

    lstCells <- lapply(lstCells,function(cell){
        cellQC(cell, qcType = op.par[["opm.qcType"]],
               qc.threshold = op.par[["opm.QC.threshold"]],
               replace.badPlateData = op.par[["if.replace.badPlateData"]],
               outpath = outpath)
    })

    if("Average.Total.Intensity" %in% cellnames){
        lstCells[["Average.Total.Intensity"]] <-
            cellMean(lstCells[["Average.Intensity.of.Nuclei"]],
                     lstCells[[ "Average.Intensity.of.Cytoplasm"]],
                     "Average.Total.Intensity")
    }
#    lstCells <- lstCells[cellnames]

    lstCells <- lapply(lstCells, function(cell){
        cell <- cellSig(cell, method = op.par[["sig.method"]],
                        th = op.par[["sig.threshold"]], thPVal = op.par[["sig.pvalue.threshold"]],
                        adjust.method = getOption("opm.adjust.methods"),
                        digits = getOption("opm.threshold.digits"),
                        plot = TRUE, outpath = outpath)
        cell
    })
    options(op)
    return(lstCells)
}
