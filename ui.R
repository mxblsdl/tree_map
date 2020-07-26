
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

# define user interface
ui <- shinyUI(
    bootstrapPage(
        tags$head(
            # TODO move to sep CSS file
            tags$style(includeCSS("styles.css")),
            useShinyjs()
            ),
        
        # Leaflet Map -------------------------------------------------------------
        # hidden()
        # side panel that shows with button press
            div(id = "hidden-panel", class = "hidden", "some info", style = "display:inline-flex;"),
            div(id = "map-wrapper",
                leafletOutput("map", width = "100%", height = "100vh"), # redundant but want to remember height can be set in body
        ),
        
        # TODO maybe change this   
        absolutePanel(width = 300, top = 10, right = 20,
                      titlePanel("Portland Urban Forestry", windowTitle = "Trees of Portland"),
                      
                      # Input values ------------------------------------------------------------
                      
                      sidebarPanel(id = "controls-panel",
                                   width = 14,
                                   selectizeInput("parks", "Parks",
                                               choices = park_names,
                                               options = list(
                                                   placeholder = 'Search For a Park',
                                                   onInitialize = I('function() { this.setValue(""); }')
                                               ),
                                               width = '100%'),
                                   
                                       selectizeInput("neighborhoods","Portland Neighborhoods",
                                                      choices = neigh_names,
                                                      options = list(
                                                          placeholder = 'Select Neighborhood',
                                                          onInitialize = I('function() { this.setValue(""); }')
                                                      )
                                       ),
                                   div(class = "btn-fly",
                                     actionButton("flyto", "Fly To Location", icon = icon("play-circle"))
                                       ),
                                   div(class = "btn-fly",
                                        actionButton("flyHome", "Full View", icon = icon("map"))
                                        ),
                                   
                                   #  toggle abandon in favor of leaflet controls group
                                   # materialSwitch("park-show",
                                   #                label = "Parks",
                                   #                value = F, 
                                   #                inline = T,
                                   #                status = "info"),
                                   # materialSwitch(inputId = "neigh-show",
                                   #                label = "Neighborhoods",
                                   #                value = F,
                                   #                inline = T,
                                   #                status = "info")
                      ) # end side bar panel
        )
    )
)
