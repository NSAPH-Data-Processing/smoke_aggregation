# Example for year 2006

library(tidyverse)
library(magrittr)
library(sf)
library(raster)

## Load grid and zip sf objects
grid_sf = read_rds("../data/intermediate/scratch/grid_sf.rds") %>% 
  rename(grid_id = ID)
zip_sf = read_rds("../data/intermediate/scratch/zip_sf.rds") 

# Load smoke grid data frame
smoke_grid_df_list = read_rds("../data/intermediate/scratch/smoke_grid_df_list.rds")
smoke_grid_df = smoke_grid_df_list[["2006"]]

# Join grid with smoke values
grid_sf %<>% 
  left_join(smoke_grid_df)

source("../../lib/var_poly_to_poly.R")

zip_smoke_df <- var_poly_to_poly(
  x_poly_sf = grid_sf, 
  y_poly_sf = zip_sf, 
  y_id = "ZIP", 
  x_var = "smoke", 
  fn = mean
)

write_rds(zip_smoke_df, "../data/output/zip_smoke_df.rds")
