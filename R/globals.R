
# global variables to use in tree map app
library(leaflet)
library(shiny)
library(sf)

# read in parks
park <-invisible(st_read("dat/data.gpkg", layer = "park"))    
park_names <- park$NAME

# read in neighborhoods
neigh <- invisible(st_read("dat/data.gpkg", layer = "neigh"))
neigh_names <- neigh$MAPLABEL

# City Boundary
portland <- invisible(st_read("dat/data.gpkg", layer = "portland"))
