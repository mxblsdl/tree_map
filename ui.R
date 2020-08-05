# tree map app for Portland
### Author: Max Blasdel
### Contact: maxblasdel@gmail.com

# define user interface
ui <-
    material_page(
        tags$head(
            tags$style(includeCSS("styles.css")),
            useShinyjs()
        ),
        title = "Portland Urban Forestry",

# Side Bar ----------------------------------------------------------------

        material_side_nav(
            fixed = T,
            material_row( #TODO address large margins, make smaller
                material_text_box("park-search", 
                                  "Search Parks")
            ),
            material_row(
                material_column(width = 9,
                                material_dropdown("parks", 
                                                  "Parks",
                                                  choices = park_names, selected = "Select Park"
                                )),
                material_column(width = 3,
                    actionButton("flyPark", "", icon = icon("plane"))
                )
            ),
#            selectize_mod("sel", "Selectize", park_names, placeholder = "Search for Park"),
            material_row(
                material_column(width = 9,
                                material_dropdown("neigh", 
                                                  "Neighborhoods",
                                                  choices = c("Select Neighborhood", sort(neigh_names)), selected = "Select Park"
                )),
                material_column(width = 3,
                                actionButton("flyNeigh", "", icon = icon("plane"))
                                )
            ),
            material_row(
                material_column(width = 6,offset = 6,
                    actionButton("flyHome", "Full View", icon = icon("map"))
                )
             )
        ),

# Header Controls ---------------------------------------------------------

    material_depth(depth = 1,
    material_row(id = "treecontrols", title = "",
                     material_column(offset = 3,
                         switchInput(inputId = "edible-switch", "", value = F, inline = F),
                         disabled(radioButtons("edible", label = "Edible Trees", choices = c("Fruit", "Nut"), inline = T))
                     ),
                    material_column(
                        switchInput("value-switch", "", value = T, inline = T, onStatus = "success"),
                        radioButtons("value", label = "Tree Value", choices = c("Total", "Per Acre"), inline = T)
                    )
                )
    ),

# Leaflet Map -------------------------------------------------------------
# height needs to be set to view window height

        leafletOutput("map", width = "100%", height = "70vh"), 
        
        # Floating Card on top of map (not being used)
        material_card(id = "card", title = "Most Valuable Parks", 
                      depth = 3,
                      divider = T,
                      plotOutput("valueParks", width = '100%', height = "20vh")),


# Plots Below Map -------------------------------------------------------------------
        
    # create non-map content
    material_row(
        material_column(width = 6,
                        "Small Parks",
                        plotOutput("park-small")
                        ),
        material_column(width = 6,
                        "Large Parks",
                        plotOutput("park-large"))
    )

    # TODO
    
    # what do I want to show?
# edible trees, 
# Map ####

# change map based on total value or value per acre


# change map colors based on fruit or nut trees
# TODO park trees species #### also map 
# most species
# Show native or not
# TODO figure out to show the park trees, maybe on a certain zoom level??
# popup of DBH, Species, annual benefits
# 
# Graphs ########
# horizontal bar graphs show top five and bottom five
# scatter showing relationship between park size and number of trees
# scatter showing relationship between park sizee and value of trees
# Most prominent species 
# native versus non-native

)


