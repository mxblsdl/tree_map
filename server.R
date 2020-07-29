



# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    # update UI element
    output$map <- renderLeaflet(leaf_map())

    # add polygons to map
    addLeafPolys("map", park, neigh)

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

# change drop down inputs
vals <- reactive({
    grep(input$`park-search`, x = park_names, ignore.case = T, value = T)
})

observe({
    update_material_dropdown(session = session, input_id = "parks", choices = vals(), value = vals()[1])
})

} # end of server
