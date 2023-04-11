# smoke_aggregation
Repository for computing the standardized weight across different zipcode given the 10km grids, then calculate the smoke values per zipcode from 2006-2016 

* Input: 
  * 10km_grid/10km_grid_wgs84/: This is a folder that contains the shapefile for the 10 km grid.
  * 10km_grid/smokePM2pt5_predictions_daily_10km_20060101-20201231.rds: This is a file that contains a data frame with the final set of daily smoke PM2.5 predictions on smoke days at 10 km resolution from January 1, 2006 to December 31, 2020 for the contiguous US. The 'grid_id_10km' column in this file corresponds to the 'ID' column in the 10 km grid shapefile.
  * Yearly zipcode grid shapefile: ./data/input/Zipcode_Info/polygon/ESRI", year, "USZIP5_POLY_WGS84.shp" 
  
* Output: CSV file containing zip_id, date, and smoke

Example output: 
```
  zip   date       smoke
  <chr> <date>     <dbl>
1 00012 2016-01-01     0
2 00012 2016-01-02     0
3 00012 2016-01-03     0
4 00012 2016-01-04     0
5 00012 2016-01-05     0
6 00012 2016-01-06     0
```

To run example weights:   
```
cd code
Rscript 01_yearly_grid_mean.R
Rscript 02_match_cts_extent_list.R
Rscript 03_run_get_weights_par_script.R
Rscript 04_daily_aggregation.R

```
## Notebook EDA 
These are the high level explanation of what each code in the notebooks folder do: 
1. 01_eda_preds.Rmd: Identify grids with smoke per day, distribution of smoke values
2. 02_yearly_grid_mean.Rmd: Aggregation to obtain grid_id, year, and smoke values
3. 03_match_cts_extent.Rmd: Match the crs and extents of sf objects, create bounding box, plot the mapping between zipcode and grid_id
4. 04_test_grid_to_zip.Rmd: Join grid with smoke values with 'over' function
5. 07_get_weights_par_test.Rmd: get_weights_par unit test. Testing if the sum of weights for 1 zipcode is equals to 1 
6. 08_zip_code_EDA.Rmd: ZIP code EDA to see the coverage of the smoke aggregation files