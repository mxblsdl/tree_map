
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
# neighborhoods <- read_sf("https://opendata.arcgis.com/datasets/1ef75e34b8504ab9b14bef0c26cade2c_3.geojson")
neighborhoods <- read_sf("https://opendata.arcgis.com/datasets/9f50a605cf4945259b983fa35c993fe9_125.geojson")

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

# Combining polygons with two neighborhood names
# Simply taking first rather doing indiv investigation
# Remove any long name titles
neigh <- neighborhoods %>% 
  mutate(MAPLABEL = gsub("/.*", "", MAPLABEL),
         MAPLABEL = gsub("Association", "Assn.", MAPLABEL),
         MAPLABEL = gsub("Community Assn.", "", MAPLABEL),
         MAPLABEL = gsub("Assn. of Neighbors", "", MAPLABEL),
         MAPLABEL = gsub("Neighborhood District Assn.|District Assn.", "", MAPLABEL),
         MAPLABEL = gsub("Improvement League|Residential League|Neighborhood Network|Foothills League",
                         "",
                         MAPLABEL)
         ) %>% 
  group_by(MAPLABEL) %>% 
  summarise()

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
tr_nei <- st_join(trees, neigh)

# calculate number of trees in each neighborhood
neighborhoods <- 
  tr_nei %>% 
  st_set_geometry(NULL) %>% 
  group_by(MAPLABEL) %>% 
  summarise(n_trees = n()) %>% 
  left_join(neigh, ., by = "MAPLABEL") %>% 
  mutate(acres = st_area(.),
         acres = set_units(acres, acre),
         trees_per_acre = n_trees / acres)

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
parks %>% 
  mutate(acres = st_area(.),
         acres = set_units(acres, acre))

tr_par <- st_join(parks, park_tree)

# calculate the total number of trees in each park
parks <-
  tr_par %>% 
  st_set_geometry(NULL) %>% 
  group_by(NAME) %>% 
  summarise(total_trees = n()) %>% 
  left_join(parks, ., by = "NAME")

parks <- 
  tr_par %>% 
  st_set_geometry(NULL) %>% 
  group_by(NAME) %>% 
  summarise(total_annual_benefits = sum(Total_Annual_Benefits, na.rm = T)) %>% 
  left_join(parks, ., by = "NAME") %>% 
  mutate(benefits_per_acre = total_annual_benefits / ACRES)

# parks with the most edible/native trees?
parks <- 
  tr_par %>% 
  st_set_geometry(NULL) %>% 
  group_by(NAME, Edible) %>% 
  summarise(n_fruit = n()) %>% 
  filter(Edible != "No", Edible != "Yes") %>% 
  pivot_wider(values_from = "n_fruit", names_from = "Edible") %>% 
  right_join(., parks, by = "NAME")

# Drop the unclaimed areas
neighborhoods <- neighborhoods %>% 
  filter(! grepl("Unclaimed", MAPLABEL))

# replace an NA values with 0
parks[is.na(parks)] <- 0
neighborhoods[is.na(neighborhoods)] <- 0

# convert back to sf
parks <- st_as_sf(parks)
neighborhoods <- st_as_sf(neighborhoods)

# Output Data -------------------------------------------------------------

if(!dir.exists("dat")) {
  dir.create("dat")
}


st_layers("dat/data.gpkg")
# write to geopackage database
write_sf(parks, "dat/data.gpkg", layer = "park")
write_sf(neighborhoods, "dat/data.gpkg", layer = "neigh")
write_sf(portland, "dat/data.gpkg", layer = "portland")
# write indiv trees

write_sf(park_tree, "dat/data.gpkg", layer = "park_trees")

