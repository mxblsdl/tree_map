
# Load Map ----------------------------------------------------------------
leaf_map <- reactive({
  leaflet(options = leafletOptions(maxZoom = 20, minZoom = 5, zoomControl = F)) %>%
    htmlwidgets::onRender("function(el, x) {
                          L.control.zoom({position: 'topright'}).addTo(this)
                          }") %>% 
    addProviderTiles(providers$CartoDB.Positron, group = "Default") %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
    setView(lng = -122.63,
            lat = 45.54,
            zoom = 12) %>%
    setMaxBounds(lng1 = -122.4,
                 lat1 = 45.4,
                 lng2 = -122.8,
                 lat2 = 45.67
    ) %>%
    leafem::addMouseCoordinates()# %>%
    #addControl(actionButton("map-change", label = "", icon = icon("bars"), class = "leaf-extend"), position = "topleft")
})


# add parks after basemap loads
addLeafPolys <- function(map, park, neigh) {
  leafletProxy(map) %>% 
    addPolygons(data = park,
                popup = paste0(park$NAME, 
                               "<br>Acres: ",
                               round(park$ACRES, 1)
                               ),
                options = popupOptions(className = "popup", 
                                       autoPan = T),
                color = "#548B54",
                group = "Parks") %>% 
    addPolygons(data = neigh,
                popup = paste0(neigh$MAPLABEL),
                options = popupOptions(className = "popup", 
                                       autoPan = T),
                color = "#ffffff",
                weight = 3,
                fillOpacity = .1,
#                highlightOptions = T,
              #  stroke = T,
                opacity = .6,
                fillColor = "red",
                group = "Neighborhoods") %>% 
    addLayersControl(
      overlayGroups = c("Parks", "Neighborhoods"), 
      position = "topright",
      options = layersControlOptions(collapsed = T)
    ) %>% 
    hideGroup(c("Neighborhoods"))
}