

library(shiny)
library(future)
library(promises)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

    # Load Map ----------------------------------------------------------------
    leaf_map <- reactive({
        leaflet(options = leafletOptions(maxZoom = 20, minZoom = 5)) %>%
            addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
            setView(lng = -122.63,
                    lat = 45.54,
                    zoom = 12) %>%
            setMaxBounds(lng1 = -122.4,
                         lat1 = 45.4,
                         lng2 = -122.8,
                         lat2 = 45.67
            ) %>%
            leafem::addMouseCoordinates()
    })
    
    # update UI element
    output$map <- renderLeaflet(leaf_map())
    
    # pop ups
    pop <- park$NAME
    
    # add parks after basemap loads
    leafletProxy("map") %>% 
        addPolygons(data = park, 
                    popup = paste0(park$NAME, "<br>Acres: ", park$ACRES),
                    options = popupOptions(className = "popup", 
                                        autoPan = T,
                                        zoomAnimation = T))
    
    

    
    # Load Spatial Data -------------------------------------------------------
    # load park data
    
    #     updateSelectizeInput(session, "parks",
    #                          choices = park_names,
    #                          server = T
    #                          # ,
    #                          #  options = list(render = I('    
    #                          #      placeholder = "Select Park";
    #                          #      onInitialize(this.setValue(placeholder));
    #                          #  ')
    #                          #)# TODO get working ^
    # )
    
    
}
