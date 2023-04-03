library(tidyverse)
library(magrittr)
library(lubridate)
library(sf)
library(raster)
library(rgeos)
library(viridis)
library(tictoc)
library(dplyr)
sf_use_s2(FALSE)

years = sprintf("%02d", c(6:16))
grid_sf = read_sf("./data/input/remote_data/10km_grid_wgs84/10km_grid_wgs84.shp")

zip_sf_list = list()

for(year in years){
  
  zip_sf = read_sf(paste0("./data/input/Zipcode_Info/polygon/ESRI", year, "USZIP5_POLY_WGS84.shp"))
  
  # making sure crs are equivalent 
  # if(st_crs(grid_sf)!= st_crs(zip_sf)){
  #   zip_sf <- st_transform(st_crs(grid_sf)) 
  # }
  
  zip_sf <- st_make_valid(zip_sf)
  zip_sf <- st_crop(zip_sf, st_bbox(grid_sf))
  
  zip_sf_list[[paste0("20",year)]] = zip_sf
  
}

write_rds(zip_sf_list, "./data/intermediate/scratch/zip_sf_list.rds")


# zip_sf_list = read_rds("./data/intermediate/scratch/zip_sf_list.rds")
# zip_s = zip_sf_list[["2016"]]

# zip_s %>% 
#  ggplot() + 
# geom_sf(aes(fill = "red"), alpha = 0.75, lwd = 0.1) + 
#  theme(legend.position = "none")





