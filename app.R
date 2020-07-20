

#TODO library calls
library(leaflet)
library(shiny)
library(sf)
library(shinyBS)
library(shinyWidgets)
library(shinyjs)

source("app/globals.R")
source("app/ui.R")
source("app/server.R")
#Other info
#options(shiny.autoreload = TRUE) # allows interactive development
# ???

# run shiny app
shinyApp(ui = ui, server = server())

#rstudioapi::jobRunScript("app.R", workingDir = getwd())

# to run interactive development start local job and run this file

#rstudioapi::viewer('http://127.0.0.1:6714')

# app will show up in the `Viewer` pane and reload on each save
# errors in the app will require the rstudioapi call again