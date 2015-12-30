# Dashboard header
headerUI <- dashboardHeader(
    title = "WebOperaMate",
    titleWidth = 250,
    ## MESSAGES
    dropdownMenu(
        type = "messages",
        messageItem(
            from = "Documentation",
            message = "View Document and Source Code",
            icon = icon("archive"),
            href = "https://github.com/ashleydotLiu/WebOperaMate"
            ),
        messageItem(
            from = "Contact us",
            message = "Report bugs here.",
            icon = icon("question"),
            href = "https://github.com/ashleydotLiu/WebOperaMate/issues"
            )
        )
    )
