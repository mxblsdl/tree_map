

# Return to Portland View
# flyHome <- function(){
#   observeEvent(input$flyHome, {
#     # load Portland city boundary
#     port_bound <- st_bbox(portland)
#     
#     # fly to full view
#     leafletProxy("map") %>% 
#       flyToBounds(., 
#                   lng1 = port_bound[[1]],
#                   lat1 = port_bound[[2]],
#                   lng2 = port_bound[[3]],
#                   lat2 = port_bound[[4]], options = list(easeLinearity = .1))
#   })
# }

flyFunc <- function(map, subset) {
  # get bounds
  bounds <- st_bbox(subset)
  
  # fly to 
  leafletProxy(map) %>% 
    flyToBounds(
      map = .,
      lng1 = bounds[[1]],
      lat1 = bounds[[2]],
      lng2 = bounds[[3]],
      lat2 = bounds[[4]]
    )
  
  # TODO highlight neighborhood with CSS
  # look here: https://stackoverflow.com/questions/50357378/add-remove-css-class-to-div-via-shiny
}