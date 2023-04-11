library(tidyverse)
library(magrittr)
library(lubridate)
library(sf)
library(dplyr)
library(ggplot2)
sf_use_s2(FALSE)

# Load grid
grid_10km = read_sf("../data/input/local_data/10km_grid_wgs84/10km_grid_wgs84.shp")%>% 
  rename(
    grid_id = ID
  )

# Load smokePM predictions on smoke days
preds = read_csv("../data/input/local_data/smokePM2pt5_predictions_daily_10km_20060101-20201231.csv") %>% 
  mutate(
    date = ymd(date)
  ) %>% 
  rename(
    smoke = smokePM_pred,
    grid_id = grid_id_10km
  )

# Create output data.frame
zip_smoke_df = data.frame(zip = character(),
                          date = Date(),
                          smoke = double(),
                          stringsAsFactors = FALSE)

for(y_ in 2016:2016){
  # Load full set of dates
  print("Now Processing year:")
  print(y_)
  dates = seq.Date(ymd(paste0(y_, "0101")), 
                   ymd(paste0(y_, "1231")), 
                   by = "day")
  
  # Get full combination of grid cell-days
  out = expand.grid(grid_id = grid_10km$grid_id, date = dates)
  
  # Match smokePM predictions on smoke days to grid cell-days
  out = left_join(out, preds, by = c("grid_id", "date"))
  
  # Predict 0 for remaining grid cell-days, which are non-smoke days
  out = mutate(out, smoke = replace_na(smoke, 0))
  
  
  # Load area-based weights 
  zip_to_grid = read.csv(paste0("../data/output/zip_weights_df_", as.character(y_), ".csv"))%>% 
    mutate(
      zip = sprintf("%05d", zip_id)
    )
  
  # Merge gridded smoke values with weights
  zip_grid_smoke = merge(out, zip_to_grid)
  
  # Compute zip-code level smoke values
  zip_smoke_df_y = zip_grid_smoke %>%
    group_by(zip, date)  %>%
    summarise(smoke =  weighted.mean(smoke, w=w))
  
  #save(zip_smoke_df_y, file = "../data/output/smoke/daily_zip_.RData")
  write_csv(
    zip_smoke_df_y, 
    paste0("../data/output/", 
           "daily_zip_", as.character(y_), ".csv")
  )

}
