## Hit function analysis panel
organism <- reactive({
    organism <- input$organism
    if(!length(organism))
        return(NULL)
    tmp <- unlist(strsplit(organism," "))
    organism <- tolower(paste0(substr(tmp[1],1,1),tmp[2]))
    organism
})
hitType <- reactive({
    hit.type <- input$hit.type
    if(hit.type == "All")
        hit.type <- c("High", "Low")
    hit.type
})

funChart <- reactive({
    if(cellStatus() == 4 & !is.null(geneMap()) & !is.null(organism())) {
        chart <- cellSigAnalysis(oneCell$obj, geneMap(), organism(),
                                 hitType())
    } else {
        chart <- NULL
    }
    chart
})

output$funTypeUI <- renderUI({
    chart <- funChart()
    if(is.null(chart))
        return()
    terms <- unique(chart[, "domain"])
    selectizeInput("fun.type", "Select domain to visualize",
                   choices = terms,
                   multiple = TRUE)

})
output$downloadEnrich <- downloadHandler(
    filename = function(){paste0(input$cellname,"-FunctionalProfiling.txt")},
    content = function(file) {
        chart <- funChart()
        write.table(chart, row.names = FALSE, col.names = TRUE, quote = FALSE, file,
                    sep = "\t")
    },
    contentType = "text/txt"
    )

output$function.plot <- renderImage({
    chart <- funChart()
    if (is.null(chart)) {
        return(list(src = ""))
    }
    prefix <- oneCell$obj["name"]
    type <- reactive(input$fun.type)()
    if(!length(type))
        type <- NULL
    cellSigAnalysisPlot(chart, prefix = prefix, type = type,
                        fill = reactive(input$bar.color)())
    outfile <- file.path(getOption("opm.outpath"), paste(prefix, "HitFunctions.png", sep = "."))
    list(src = outfile, contentType = "image/png")
}, deleteFile = TRUE)




