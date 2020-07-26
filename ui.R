
# tree map app for Portland
### Author: Max Blasdel
### Contact: maxblasdel@gmail.com
library(leaflet)
library(shiny)
library(sf)
library(shinyjs)
library(future)
library(promises)
library(shinyWidgets)
library(shinymaterial)

# define user interface
ui <-
    material_page(
        tags$head(
            # TODO move to sep CSS file
            tags$style(includeCSS("styles.css")),
            useShinyjs()
        ),
        title = "Portland Urban Forestry",
        material_side_nav(
            fixed = T,
            material_row(
                material_dropdown("parks", 
                                  "Parks",
                                  choices = c("Please Select Park", sort(park_names)), selected = "Please Select Park"
                ),
                actionButton("flyPark", "", icon = icon("plane")),
                width = 12
            ),
            div(class = "divider"),
            material_row(
                material_dropdown("neigh", 
                                  "Neighborhoods",
                                  choices = c("Please Select Neighborhood", sort(neigh_names)), selected = "Please Select Park"
                ),
                actionButton("flyNeigh", "", icon = icon("plane")),
                width = 12
            ),
            # Input values ------------------------------------------------------------
            material_row(
                material_column(width = 6,offset = 6,
                    actionButton("flyHome", "Full View", icon = icon("map"))
                )
             ),
        ),
        
        # Leaflet Map -------------------------------------------------------------
        
        # height needs to be set to view window height
        leafletOutput("map", width = "100%", height = "100vh"), 
        
        # absolute panel to float over map
        absolutePanel(width = '30vw', 
                      bottom = 10, 
                      right = 20,
                      height = "40vh",
                      material_card(id = "t", title = "Most Valuable Parks", depth = 3,divider = T, 
                                    plotOutput("valueParks", width = '100%', height = "20vh"))
                      ) # end absolute panel
        
)
