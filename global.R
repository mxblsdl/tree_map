#plan(multiprocess)
# global variables to use in tree map app

# read in parks
park <-invisible(st_read("dat/data.gpkg", layer = "park", quiet = T))    
park_names <- park$NAME

# read in neighborhoods
neigh <- invisible(st_read("dat/data.gpkg", layer = "neigh", quiet = T))
neigh_names <- neigh$MAPLABEL

# City Boundary
portland <- invisible(st_read("dat/data.gpkg", layer = "portland", quiet = T))

# park trees
park_trees <-future(then(invisible(st_read("dat/data.gpkg", layer = "park_trees", quiet = T)))) 

# st_layers("dat/data.gpkg")
