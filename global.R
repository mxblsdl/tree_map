library(leaflet)
library(sf)

library(shiny)
library(shinyWidgets)
library(shinymaterial)
library(shinyjs)
library(shinyBS)

library(future)
library(promises)


#plan(multiprocess)
# global variables to use in tree map app

# read in parks
park <-invisible(st_read("dat/data.gpkg", layer = "park", quiet = T))    
park_names <- park$NAME
park_names <- c("Please Select Park", sort(park_names))

# read in neighborhoods
neigh <- invisible(st_read("dat/data.gpkg", layer = "neigh", quiet = T))
neigh_names <- neigh$MAPLABEL

# City Boundary
portland <- invisible(st_read("dat/data.gpkg", layer = "portland", quiet = T))

# park trees
# park_trees <- future(st_read("dat/data.gpkg", layer = "park_trees", quiet = T))
# park_trees <- st_read("dat/data.gpkg", layer = "park_trees", quiet = T)

park_trees <- value(future(st_read("dat/data.gpkg", layer = "park_trees", quiet = T)))

# Check layers in a geopackage database
# st_layers("dat/data.gpkg")
# 
headerButtons <- function(id, icon) {
  ns <- NS(id)
  tagList(
    material_button(NS(id, "tree"), label = "", depth = 1, icon = icon(icon))
  )
}

headerButtonsui <- function(id, icon){
  ns <- NS(id)
  tagList(
    material_button(NS(id, "tree"), label = "", depth = 1, icon = icon(icon))
    )
  }

# headerButtons <- function(input, output, session){
#   ns <- session$ns
#   
# }
headerButtons <- function(id) {
  moduleServer(id, function(input, output, session) {
    
  })
}
# Copy in UI
#headerButtonsui("headerButtonsui")

# Copy in server
#callModule(headerButtons, "headerButtonsui")
