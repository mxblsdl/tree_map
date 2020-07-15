
# get data from ESRI server for tree map
library(units)
library(sf)
library(dplyr)
library(ggplot2)
library(tidyr)
# load data ---------------------------

# City Boundary
portland <- read_sf("https://opendata.arcgis.com/datasets/1559e31273654eb9858397861f1fdefa_10.geojson")

# Street Tree Data
trees <- read_sf('https://opendata.arcgis.com/datasets/eb67a0ad684d4bb6afda51dc065d1664_25.geojson')

# Park tree data
park_tree <- read_sf("https://opendata.arcgis.com/datasets/83a7e3f6a1d94db09f24849ee90f4be2_220.geojson")

# neighborhoods
neighborhoods <- read_sf("https://opendata.arcgis.com/datasets/1ef75e34b8504ab9b14bef0c26cade2c_3.geojson")

# parks 
parks <- read_sf("https://opendata.arcgis.com/datasets/9eef54196eaa4d12b54e9bc40e70ff09_35.geojson")

# Clean Data -------------------------------------

# Select Portland from Boundaries
portland <- portland %>% 
  filter(CITYNAME == "Portland") %>% 
  select(CITYNAME)

# drop unneeded columns and output in geopackage format

# clean parks
parks <- 
  parks %>% 
  select(NAME, ACRES)

# clean neighborhoods
neighborhoods <-
  neighborhoods %>% 
  select(MAPLABEL)

# clean street trees
# this is the largest data set
trees <- 
  trees %>% 
  select(Family, Genus, Common, DBH, Edible, Neighborhood)

# park trees
park_tree <- 
  park_tree %>% 
  select(Family, Genus, Common_name, Total_Annual_Benefits, DBH, Edible, Native)

# Analysis -------------------------------------------------------------

## Neighborhoods -----------------------------------------------------------------------
# which neighborhoods have the most trees per area?
tr_nei <- st_join(trees, neighborhoods)

# calculate number of trees in each neighborhood
neighborhoods <- 
  tr_nei %>% 
  st_set_geometry(NULL) %>% 
  group_by(MAPLABEL) %>% 
  summarise(n_trees = n()) %>% 
  left_join(neighborhoods, ., by = "MAPLABEL") %>% 
  mutate(trees_per_acre = n_trees / st_area(.),
         trees_per_acre = set_units(trees_per_acre, acre))

# what neighborhoods have the most edible trees?
neighborhoods <- 
  tr_nei %>% 
  st_set_geometry(NULL) %>% 
  group_by(MAPLABEL, Edible) %>% 
  summarise(n_fruit = n()) %>% 
  filter(Edible != "no") %>% 
  pivot_wider(values_from = "n_fruit", names_from = "Edible") %>% 
  right_join(., neighborhoods, by = "MAPLABEL")


# Parks -------------------------------------------------------------------

# what are the most valuable parks? Both in gross value and per acre?
tr_par <- st_join(parks, park_tree)

parks <- 
  tr_par %>% 
  st_set_geometry(NULL) %>% 
  group_by(NAME) %>% 
  summarise(val = sum(Total_Annual_Benefits, na.rm = T)) %>% 
  left_join(parks, ., by = "NAME") %>% 
  mutate(val_per_acre = val / ACRES)

# parks with the most edible/native trees?
parks <- 
  tr_par %>% 
  st_set_geometry(NULL) %>% 
  group_by(NAME, Edible) %>% 
  summarise(n_fruit = n()) %>% 
  filter(Edible != "No", Edible != "Yes") %>% 
  pivot_wider(values_from = "n_fruit", names_from = "Edible") %>% 
  right_join(., parks, by = "NAME")

# convert back to sf
parks <- st_as_sf(parks)
neighborhoods <- st_as_sf(neighborhoods)

# Output Data -------------------------------------------------------------

if!(dir.exists("dat")) {
  dir.create("dat")
}

# write to geopackage database
write_sf(parks, "dat/data.gpkg", layer = "park")
write_sf(neighborhoods, "dat/data.gpkg", layer = "neigh")
write_sf(portland, "dat/data.gpkg", layer = "portland")

# write indiv trees
write_sf(park_tree, "dat/data.gpkg", layer = "park_trees")

