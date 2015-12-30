if(interactive()) {
  source("global.R")
  source("ui.R")
  source("server.R")
  shinyApp(ui = shinyUI, server = shinyServer)
  options(op)
}



## or Deploy App
## shinyapps::deployApp("WebOperaMate")

