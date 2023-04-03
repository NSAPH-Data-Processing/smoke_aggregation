## load libraries ----
library(dplyr)
library(tidyverse)
library(magrittr)
library(sf)
library(raster)
library(parallel)
library(argparse)
print("This is the sf package version we are using:")
print(packageVersion("sf"))

## define parser arguments ----
parser <- ArgumentParser()
parser$add_argument("-y", "--year", default=2006,
                    help="Year to run", type="integer")
parser$add_argument("-c", "--cores", default=24,
                    help="Number of cores", type="integer")
args = parser$parse_args()
print("use R script get_weights_par")
# args = list()
# args$year = 2006
# args$cores = 24

## read functions ----
source("../../lib/get_weights_par.R")

print("load data")
## Load grid and zip sf objects ----
grid_sf = read_rds("../data/intermediate/scratch/grid_sf.rds") %>% 
  rename(grid_id = ID)
zip_sf_list = read_rds("../data/intermediate/scratch/zip_sf_list.rds") 
zip_sf = zip_sf_list[[as.character(args$year)]] %>% 
  rename(zip_id = ZIP)
rm(zip_sf_list)
x_poly_sf = zip_sf
y_poly_sf = grid_sf 
x_id = "zip_id"
y_id = "grid_id"
cores = args$cores

## crop polygons within same bounding box ---- 
x_poly_sf <- st_make_valid(x_poly_sf)
x_poly_sf <- st_crop(x_poly_sf, st_bbox(y_poly_sf))

# assign 1s to zipcode polygons ----
x_poly_sf$w <- 1


x_to_y <- data.frame()

# error zipcodes 
for(i in c("03281")) {
  x_i_sf <- dplyr::select(x_poly_sf[x_poly_sf[[x_id]] == i, ], c("w", "geometry"))
  y_i_sf <- dplyr::select(st_crop(y_poly_sf, extent(x_i_sf)), c(y_id, "geometry"))
  
  # y_i_w <- st_drop_geometry(st_interpolate_aw(x_i_sf, y_i_sf, extensive = T))
  tryCatch({
    y_i_w <- st_drop_geometry(st_interpolate_aw(x_i_sf, y_i_sf, extensive = T))
    
    x_to_y_i <- data.frame(
      x_id = i, 
      y_id = y_i_sf[[y_id]][as.numeric(rownames(y_i_w))],
      w = y_i_w$w)
    
    x_to_y <- rbind(x_to_y, x_to_y_i)
    
  }, error=function(e){
    print("An error occurred while calculating the weights.")
    print(i)
  })
}


## example successful one
test_x <- dplyr::select(x_poly_sf[x_poly_sf[[x_id]] == "01604", ], c("w", "geometry"))
test_y <- dplyr::select(st_crop(y_poly_sf, extent(test_x)), c(y_id, "geometry"))

test_interpolate <- st_interpolate_aw(test_x, test_y, extensive = T)

############
# The success one
plot(test_x[[2]])
plot(test_y[[2]], add = TRUE)
plot(test_interpolate[[2]])


# The error one 
plot(x_i_sf[[2]])
plot(y_i_sf[[2]], add = TRUE)
st_interpolate_aw(x_i_sf, y_i_sf, extensive = T)


