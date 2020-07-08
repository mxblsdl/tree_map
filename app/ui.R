
# tree map app for Portland
### Author: Max Blasdel
### Contact: maxblasdel@gmail.com

# define user interface
shinyUI(
    bootstrapPage(
        tags$head(
            tags$style(type = "text/css",
            "body {
            width: 100%; height: 100%;
            }
            #controls-panel {
            background-color: rgba(0,45,25,0.3);
            }  
            #map {
            height: calc(100vh) !important;
                       }")),
        
        # Leaflet Map -------------------------------------------------------------
        
        leafletOutput("map", height = "100vh"), # redundant but want to remember height can be set in body
        
        # TODO maybe change this   
        absolutePanel(width = 280, top = 10, right = 20,
                      titlePanel("Portland Urban Forestry", windowTitle = "Trees of Portland"),
                      
                      # Input values ------------------------------------------------------------
                      
                      sidebarPanel(id = "controls-panel",
                                   width = 12,
                                   selectizeInput("parks", "Parks",
                                               choices = park_names,
                                               options = list(
                                                   placeholder = 'Search For a Park',
                                                   onInitialize = I('function() { this.setValue(""); }')
                                               ),
                                               width = '100%'),
                                   selectInput("constrain_var",
                                               "Constraint Measure",
                                               choices = c("LPG Usage", 
                                                           "Household Size", 
                                                           "Wealth Index")),
                                   # TODO make slider reactive based on above input value
                                   sliderInput("con", 
                                               "Constraint Value",
                                               value = 0.05,
                                               min = 0,
                                               max = 1,
                                               step = 0.01,
                                               post = " %",
                                               width = "100%")
                      ) # end side bar panel
        )
    )
)
