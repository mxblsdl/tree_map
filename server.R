
# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    # update UI element
    output$map <- renderLeaflet(leaf_map())

    # add polygons to map
    addLeafPolys("map", park, neigh)

    # add park trees lazy...
    # TODO make lazy
    leafletProxy('map') %>%  
        addMarkers(data = park_trees,
                   clusterOptions = markerClusterOptions(maxClusterRadius = 40, 
                                                         disableClusteringAtZoom = 18,
                                                         spiderfyOnMaxZoom = F),
                   group = "Trees") %>%
        addLayersControl(
            overlayGroups = c("Parks", "Neighborhoods", "Trees"), 
            position = "topright",
            options = layersControlOptions(collapsed = T),
            baseGroups = c("Default", "Satellite")
        ) %>% 
        hideGroup(c("Neighborhoods", "Trees"))

    # call event on button press

    # fly to neighborhoods
    observeEvent(input$flyNeigh, {
        # get subset of neighborhood
        sub <- subset(neigh, MAPLABEL == input$neigh)

        # fly to
        flyFunc("map", sub)    
        }, ignoreInit = T
    )

    # fly to parks
    observeEvent(input$flyPark, {
        # get subset of neighborhood
        sub <- subset(park, NAME == input$parks)

        # fly to
        flyFunc("map", sub)    
    }, ignoreInit = T
    )

    # fly home
    observeEvent(input$flyHome, {
        flyFunc("map", portland)
    })
    
    # hide and show fly to buttons    
    observe({
            if(input$parks == "Please Select Park") hide("flyPark") else show("flyPark")
    })

    observe({
        if(input$neigh == "Please Select Neighborhood") hide("flyNeigh") else show("flyNeigh")
    })

# change park dropdown inputs
vals <- reactive({
    grep(input$`park-search`, x = park_names, ignore.case = T, value = T)
})

observe({
    update_material_dropdown(session = session, input_id = "parks", choices = vals(), value = vals()[1])
})

# Park Trees Filter -------------------------------------------------------

onclick("t", 
    print(input$t),
#    addClass("t", "with-gap")
)


# runjs("document.getElementById('popbtn').onclick = function() { 
#            console.log(this);
#          };"
#       )

} # end of server
