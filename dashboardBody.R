source("panel/easyRun.R")
source("panel/panel-ui-easyworkflow.R")
source("panel/panel-ui-dataload.R", local = TRUE)
source("panel/panel-ui-dataimport.R", local = TRUE)
source("panel/panel-ui-normalization.R", local = TRUE)
source("panel/panel-ui-qualitycontrol.R", local = TRUE)
source("panel/panel-ui-hitdetection.R", local = TRUE)
source("panel/panel-ui-hitfunction.R", local = TRUE)
source("acknowledgement/acknowledgement.R", local = TRUE)
source("mainPage/getstart.R", local = TRUE)
## Start Page
startBody <- tabItem(
    tabName = "start",
    mainPageUI
    )
easyRunBody <- tabItem(
    tabName = "easyRun",
    easyProcsUI
    )
## Computation Pages
uploadBody <- tabItem(
    tabName = "upload",
    loadDataUI
    )
importBody <- tabItem(
    tabName = "import",
    importDataUI
    )
normBody <- tabItem(
    tabName = "norm",
    normDataUI
    )
qcBody <- tabItem(
    tabName = "qc",
    qcDataUI
    )
hitBody <- tabItem(
    tabName = "hit",
    hitDetecUI
)
hitFunBody <- tabItem(
    tabName = "hitfun",
    hitFunUI
    )
## Acknowledge Page
ackBody <- tabItem(
  tabName = "acknowledgement",
    acknowledgeUI
)

# Dashboard body
bodyUI <- dashboardBody(
    includeCSS("www/custom.css"),
    tabItems(
        startBody,
        easyRunBody,
        uploadBody,
        importBody,
        normBody,
        qcBody,
        hitBody,
        hitFunBody,
        ackBody
        )
    )
