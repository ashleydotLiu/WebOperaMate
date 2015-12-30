source("dashboardheader.R", local = TRUE)
source("dashboardSidebar.R", local = TRUE)
source("dashboardBody.R", local = TRUE)

shinyUI <- dashboardPage(
    skin = "black",
#    includeCSS("www/style.css"),
    headerUI,
    sidebarUI,
    bodyUI)



