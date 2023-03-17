
--------------------------------------------------------------------------------
10 km grid
--------------------------------------------------------------------------------
10km_grid/10km_grid_wgs84/:
This is a folder that contains the shapefile for the 10 km grid.

--------------------------------------------------------------------------------
10km_grid/smokePM2pt5_predictions_daily_10km_20060101-20201231.rds:
This is a file that contains a data frame with the final set of daily smoke PM2.5 predictions on smoke days at 10 km resolution from January 1, 2006 to December 31, 2020 for the contiguous US. The 'grid_id_10km' column in this file corresponds to the 'ID' column in the 10 km grid shapefile.

All rows in this file are predictions on smoke days. Predictions on non-smoke days are by construction 0 ug/m^3 and not included in this file. A smoke PM2.5 prediction of 0 in this file means that the grid cell-day did have a smoke day but did not have elevated PM2.5. The full set of smoke PM2.5 predictions on both smoke days and non-smoke days can be obtained by setting the smoke PM2.5 prediction to 0 on grid cell-days in the 10 km grid and in the January 1, 2006-December 31, 2020 date range that are not in this file. For example, the R code below returns the full set of smoke PM2.5 predictions:


```r
library(tidyverse)
library(lubridate)
library(sf)
```


```r
# Load smokePM predictions on smoke days
preds = read_csv("../data/input/smoke_PM/smokePM2pt5_predictions_daily_10km_20060101-20201231.csv") %>% 
  mutate(
    date = ymd(date)
  ) %>% 
  rename(
    smoke = smokePM_pred,
    grid_id = grid_id_10km
  )

head(preds)
```

```
## # A tibble: 6 × 3
##   grid_id date       smoke
##     <dbl> <date>     <dbl>
## 1   56334 2006-01-01  2.71
## 2   56335 2006-01-01  3.07
## 3   56336 2006-01-01  2.48
## 4   56337 2006-01-01  3.09
## 5   56338 2006-01-01  3.67
## 6   56847 2006-01-01  1.94
```


```r
# Load 10 km grid
grid_10km = read_sf("../data/input/remote_data/10km_grid_wgs84/10km_grid_wgs84.shp")

head(grid_10km)
```

```
## Simple feature collection with 6 features and 3 fields
## Geometry type: POLYGON
## Dimension:     XY
## Bounding box:  xmin: -81.81382 ymin: 24.44919 xmax: -81.22679 ymax: 24.58611
## Geodetic CRS:  WGS 84
## # A tibble: 6 × 4
##      ID  COORDX  COORDY                                                                   geometry
##   <int>   <dbl>   <dbl>                                                              <POLYGON [°]>
## 1  1397 -800000 2770000 ((-81.71753 24.54554, -81.70852 24.45745, -81.80474 24.44919, -81.81382 2…
## 2  1398 -790000 2770000 ((-81.62121 24.55377, -81.61226 24.46565, -81.70852 24.45745, -81.71753 2…
## 3  1399 -780000 2770000 ((-81.52484 24.56195, -81.51596 24.47379, -81.61226 24.46565, -81.62121 2…
## 4  1400 -770000 2770000 ((-81.42843 24.57006, -81.41961 24.48187, -81.51596 24.47379, -81.52484 2…
## 5  1401 -760000 2770000 ((-81.33197 24.57811, -81.32322 24.48989, -81.41961 24.48187, -81.42843 2…
## 6  1402 -750000 2770000 ((-81.23548 24.58611, -81.22679 24.49785, -81.32322 24.48989, -81.33197 2…
```


```r
smoke_grid_df_list = list()
years_ = 2006

for(y_ in years_) {
  print(y_)
  # Load full set of dates
  #dates = seq.Date(ymd("20060101"), ymd("20201231"), by = "day")
  dates = seq.Date(ymd(paste0(y_, "0101")), 
                   ymd(paste0(y_, "1231")), 
                   by = "day")
  
  # Get full combination of grid cell-days
  # Warning: this may require a large amount of memory
  out = expand.grid(grid_id = grid_10km$ID, date = dates)
  
  # Match smokePM predictions on smoke days to grid cell-days
  out = left_join(out, preds, by = c("grid_id", "date"))
  
  # Predict 0 for remaining grid cell-days, which are non-smoke days
  out = mutate(out, smoke = replace_na(smoke, 0))
  
  # Compute smoke yearly grid mean
  out %<>% 
    mutate(year = year(date)) %>% 
    group_by(grid_id, year) %>% 
    summarise(smoke = mean(smoke))
  
  smoke_grid_df_list[[as.character(y_)]] <- out
}
```

```
## [1] 2006
```

```r
head(smoke_grid_df_list[[as.character(y_)]])
```

```
## # A tibble: 6 × 3
## # Groups:   grid_id [6]
##   grid_id  year  smoke
##     <dbl> <dbl>  <dbl>
## 1    1397  2006 0.0615
## 2    1398  2006 0.0576
## 3    1399  2006 0.0541
## 4    1400  2006 0.0470
## 5    1401  2006 0.0462
## 6    1402  2006 0.0438
```
