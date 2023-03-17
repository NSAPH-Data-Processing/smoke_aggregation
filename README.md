# smoke_aggregation
Repository for computing the standardized weight across different zipcode given the 10km grids
* Input: 
  * # 10km_grid/10km_grid_wgs84/: This is a folder that contains the shapefile for the 10 km grid.
  * 10km_grid/smokePM2pt5_predictions_daily_10km_20060101-20201231.rds: This is a file that contains a data frame with the final set of daily smoke PM2.5 predictions on smoke days at 10 km resolution from January 1, 2006 to December 31, 2020 for the contiguous US. The 'grid_id_10km' column in this file corresponds to the 'ID' column in the 10 km grid shapefile.
  * Yearly zipcode grid shapefile: ./data/input/Zipcode_Info/polygon/ESRI", year, "USZIP5_POLY_WGS84.shp 
  
* Output: Rds file containing zip_id, grid_id, and weight

Example output: 
```
  zip_id grid_id  w
1 03281 104504 0.120474045
2 03281 104505 0.489675352
3 03281 104506 0.001825444
4 03281 105019 0.080026705
5 03281 105020 0.307998349
```

To run example weights:   
```
mkdir $HOME/singularity_images
cd $HOME/singularity_images
singularity pull docker://nsaph/r_exposures:v0
cd code
Rscript 01_yearly_grid_mean.R
Rscript 02_match_cts_extent_list.R
Rscript test_get_weights.R
sbatch 03_run_get_weights_par.sbatch
```
