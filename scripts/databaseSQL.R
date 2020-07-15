
# example of reading from geopackage
library(tictoc)

tic()
read_sf("dat/data.gpkg", layer = "park", query = paste0("SELECT * FROM park WHERE NAME = 'Forest Park'"))
toc()

tic()
read_sf("dat/data.gpkg", layer = "park")
toc()

st_layers("dat/data.gpkg")
