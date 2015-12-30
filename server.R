shinyServer <- function(input, output, session){
    source("panel/easyRun.R", local = TRUE)
    source("panel/panel-server-easyworkflow.R", local = TRUE)
    source("panel/panel-server-dataload.R", local = TRUE)
    source("panel/panel-server-dataimport.R", local = TRUE)
    source("panel/panel-server-normalization.R", local = TRUE)
    source("panel/panel-server-qualitycontrol.R", local = TRUE)
    source("panel/panel-server-hitdetection.R", local = TRUE)
    source("panel/panel-server-hitfunction.R", local = TRUE)
}
