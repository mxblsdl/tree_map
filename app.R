

#TODO library calls
library(leaflet)
library(shiny)
library(sf)


#Other info
options(shiny.autoreload = TRUE) # allows interactive development
# ???

park <- st_read("dat/data.gpkg", layer = "park")   
park_names <- park$NAME

# run shiny app
runApp("app")


rstudioapi::jobRunScript("app.R", workingDir = getwd())

# to run interactive development start local job and run this file

rstudioapi::viewer('http://127.0.0.1:4638')

# app will show up in the `Viewer` pane and reload on each save
# errors in the app will require the rstudioapi call again