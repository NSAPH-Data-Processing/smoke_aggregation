library(tidyverse)
library(magrittr)
library(lubridate)
library(sf)
#library(viridis)
#library(fst)
#library(data.table)
#library(dplyr)
#library(rgeos)
#library(sp)
library(ggplot2)
#library(rgdal)
#sf_use_s2(FALSE)

years = sprintf("%02d", c(06:16))

# Load zip sf list
zip_sf_list = read_rds("../data/input/smoke/zip_sf_list.rds") 

pobox_zip_df = data.frame(PO_BOX = character(),
                          ZIP = character(),
                          #LAT = double(),
                          #LON = double(),
                          year = double(),
                          stringsAsFactors = FALSE)

for(year in years){
  
  zip_sf = zip_sf_list[[paste0("20", year)]]
  
  po_box = read_csv(paste0("/n/dominici_nsaph_l3/Lab/data/shapefiles/zip_shape_files/Zipcode_Info/pobox_csv/ESRI", year, "USZIP5_POINT_WGS84_POBOX.csv")) %>%
    rename(PO_BOX = ZIP) %>%
    mutate(PO_BOX = sprintf("%05d", PO_BOX))
  
  po_box_sf = st_as_sf(po_box[,c(1,3,4)], coords = c("POINT_X", "POINT_Y"), crs=st_crs(zip_sf))
  
  po_box_sf <- st_crop(po_box_sf, st_bbox(zip_sf))
  
  # zip_sf %>%
  #   st_simplify() %>%
  #   ggplot(aes(fill = "red"), alpha = 0.75, lwd = 0.1) +
  #   geom_sf() +
  #   geom_sf(data = po_box_sf ) +
  #   theme(legend.position = "none")
  
  #po_box_sf$ZIP = unlist(st_drop_geometry(zip_sf[unlist(st_intersects(po_box_sf, zip_sf)),"ZIP"]))
  po_box_sf$ZIP = st_drop_geometry(zip_sf)$ZIP[unlist(st_intersects(po_box_sf, zip_sf))]
  
  # po_box %<>%
  #   merge(po_box_sf, by = "PO_BOX")
  # 
  # po_box = st_drop_geometry(po_box[, c(1, 6, 3, 4)])%>%
  #   rename(LAT = POINT_X, LON = POINT_Y)
  # 
  # po_box$year = as.numeric(paste0("20",year))
  # pobox_zip_df = rbind(pobox_zip_df, po_box)
  
  po_box_sf$year = as.numeric(paste0("20",year))
  pobox_zip_df = rbind(pobox_zip_df, 
                       st_drop_geometry(po_box_sf))
  
}

#save(pobox_zip_df, file =  "../data/intermediate/scratch/pobox_zip_df.RData")
saveRDS(pobox_zip_df, file =  "../data/input/smoke/pobox_zip_df.rds")
