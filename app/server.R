
library(leaflet)
library(future)
library(promises)
library(shinyWidgets)

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
#    pop <- park$NAME
    
    # add parks after basemap loads
    leafletProxy("map") %>% 
        addPolygons(data = park, 
                    popup = paste0(park$NAME, "<br>Acres: ", park$ACRES),
                    options = popupOptions(className = "popup", 
                                        autoPan = T,
                                        zoomAnimation = T))
    
    # get subset of neighborhood
    # sub_neigh <- reactive({
    #     subset(neigh, subset = NAME == input$neigh)
    # })
    
    # call event on button press
    observeEvent(input$flyto, {

        # TODO event is pressing the button
        n <- input$neighborhoods

        # get subset of neighborhood
        sub_neigh <- subset(neigh, MAPLABEL == n)

        # get bounds
        bounds <- st_bbox(sub_neigh)
        
        # fly to 
        leafletProxy("map") %>% 
        flyToBounds(map = ., lng1 = bounds[[1]],lat1 = bounds[[2]], lng2 = bounds[[3]], lat2 = bounds[[4]])
        
        # TODO highlight neighborhood with CSS
        # look here: https://stackoverflow.com/questions/50357378/add-remove-css-class-to-div-via-shiny
        
        }, ignoreInit = T
    )

    # load portland city boundary
    port_bound <- st_bbox(portland)
    
    # Return to Portland View
    observeEvent(input$flyHome, {
        # fly to full view
        leafletProxy("map") %>% 
            flyToBounds(., 
                        lng1 = port_bound[[1]],
                        lat1 = port_bound[[2]],
                        lng2 = port_bound[[3]],
                        lat2 = port_bound[[4]], options = list(easeLinearity = .1))
    })
    
    
    # Load Spatial Data with Promise-------------------------------------------------------
    
    # load park trees with future
    # plan(multiprocess)
    # pt <- reactive({
    #     future(
    #         read_sf("dat/data.gpkg", layer = "park_trees")
    #     )
    # })
    # future({
    #     read_sf("dat/data.gpkg", layer = "park_trees")
    # }) %>%
    #     ggplot2::ggplot() +
    #     ggplot2::geom_sf
    
    # City boundary
    leafletProxy("map") %>% 
        addPolygons(data = portland, fillOpacity = 0, color = c("#EEAEEE"))
    
    
    # Add toggle functionality
    # TODO observe matierla input toggle
    
} # end of server
