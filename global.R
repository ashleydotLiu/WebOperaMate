library(shiny)
library(OperaMate)
library(ggplot2)
library(shinydashboard)
library(shinyapps)
library(markdown)

## Global values
exist.platemap <- FALSE
op <- options()

options("device" = "png")
## Change default file size limit from 5MB to 30MB
options(shiny.maxRequestSize = 30*1024^2)
options("opm.outpath" = tempdir())

