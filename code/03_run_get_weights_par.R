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
print(Sys.time())
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
source("../lib/get_weights_par.R")

print("load data")
## Load grid and zip sf objects ----
grid_sf = read_rds("../data/intermediate/scratch/grid_sf.rds") %>% 
  rename(grid_id = ID)
zip_sf_list = read_rds("../data/intermediate/scratch/zip_sf_list.rds") 
zip_sf = zip_sf_list[[as.character(args$year)]] %>% 
  rename(zip_id = ZIP)
rm(zip_sf_list)


print("run aggregations")
## run aggregations ----
zip_weights_df <- get_weights_par(
  x_poly_sf = zip_sf, 
  y_poly_sf = grid_sf, 
  x_id = "zip_id", 
  y_id = "grid_id",
  cores = args$cores
)

print("finish aggregations")
zip_weights_df$year <- args$year

## save output ----
write_csv(
  zip_weights_df, 
  paste0("../data/output/", 
         "zip_weights_df_", as.character(args$year), ".csv")
)
print(Sys.time())
print("completed")
