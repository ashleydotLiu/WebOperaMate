# Dashboard sidebar
sidebarUI <- dashboardSidebar(
    width = 250,
    sidebarMenu(
        menuItem(
            "Get to know",
            tabName = "start",
            icon = icon("book")
            ),
        menuItem(
            "Automatic Analysis",
            tabName = "easyRun",
            icon = icon("play")
            ),
        menuItem(
            "Data Upload",
            tabName = "upload",
            icon = icon("upload")
            ),
        menuItem(
            "Data Import",
            tabName = "import",
            icon = icon("briefcase")
            ),
        menuItem(
            "Normalization",
            tabName = "norm",
            icon = icon("area-chart")
            ),
        menuItem(
            "Quality Control",
            tabName = "qc",
            icon = icon("filter")
            ),
        menuItem(
            "Hit Detection",
            tabName = "hit",
            icon = icon("flag")
            ),
        menuItem(
            "Hit Functions",
            tabName = "hitfun",
            icon = icon("magic")
            ),
        menuItem(
            "Acknowledgement",
            tabName = "acknowledgement",
            icon = icon("coffee")
        )
    )
)
