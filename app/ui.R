
# tree map app for Portland
### Author: Max Blasdel
### Contact: maxblasdel@gmail.com

# define user interface
shinyUI(
    bootstrapPage(
        tags$head(
            # TODO move to sep CSS file
            tags$style(type = "text/css",
            "body {
            width: 100%; height: 100%;
            }
            #controls-panel {
            background-color: rgba(0,45,25,0.3);
            };
            #map {
            height: calc(100vh) !important;
                       }
            .btn-fly {
            text-align:center;
            }
            ")),
        
        # Leaflet Map -------------------------------------------------------------
        
        leafletOutput("map", height = "100vh"), # redundant but want to remember height can be set in body
        
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
                                               actionButton("flyHome", "Full View", icon = icon("map")),
                                               ),
                                   # TODO toggle neighborhoods and parks
                                   materialSwitch("park-show",
                                                  label = "Parks",
                                                  value = F, 
                                                  inline = T,
                                                  status = "info"),
                                   materialSwitch(inputId = "neigh-show",
                                                  label = "Neighborhoods",
                                                  value = F,
                                                  inline = T,
                                                  status = "info")
                      ) # end side bar panel
        )
    )
)
