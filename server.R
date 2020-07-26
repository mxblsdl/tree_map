



# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    # update UI element
    output$map <- renderLeaflet(leaf_map())
    
    # add polygons to map
    addLeafPolys("map")

    # get subset of neighborhood
    # sub_neigh <- reactive({
    #     subset(neigh, subset = NAME == input$neigh)
    # })
    
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
        if(input$parks == "Please Select Park") {
            hide("flyPark")
        } else {
            show("flyPark")
        }
})

observe({
    if(input$neigh == "Please Select Neighborhood") {
        hide("flyNeigh")
    } else {
        show("flyNeigh")
    }
})

    # Load Spatial Data with Promise-------------------------------------------------------
    
    # load park trees with future
    # plan(multiprocess)
    # pt <- reactive({
    #     future(
    #         read_sf("dat/data.gpkg", layer = "park_trees")
    #     )
    # })
    
    # observe more button on map
    # observeEvent(input$`map-change`, {
    #     toggleClass("map-wrapper", "change-map")
    #     toggleCssClass("hidden-panel", "hidden")
    #     #toggle(id = "hidden-panel", anim = T, animType = "fade", time = .5)
    #     }
    # )
    
    
} # end of server
