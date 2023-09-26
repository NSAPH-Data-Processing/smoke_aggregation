# Smoke Aggregation Repository

Welcome to the **Smoke Aggregation** repository. This repository serves as a comprehensive resource for computing standardized weights for different zip codes based on a 10km grid and subsequently calculating smoke values per zip code for the years 2006-2016. The dataset included here consists of daily aggregated measurements of PM2.5 from ambient wildfire smoke in the contiguous United States, covering the period from 2006 to 2016. This valuable dataset is sourced from a study conducted by Childs et al. (2022), titled "Daily Local-Level Estimates of Ambient Wildfire Smoke PM2.5 for the Contiguous US," published in Environmental Science & Technology.

## Source: 
The 10km grid data used in this project can be obtained from the GitHub repository https://github.com/echolab-stanford/daily-10km-smokePM.

Paper Reference: This project is based on research described in the paper by Childs et al., 2022, titled "Daily local-level estimates of ambient wildfire smoke PM2.5 for the contiguous US."

The data source have an aggregation on ZCTA level instead of ZIP level from the 10x10 grid. We aggregated the 10x10km grid data  into zipcode leel using area-weighted average technique. 


## Project Overview

The primary objective of this project is to create standardized weights for different zip codes based on a 10km grid. These weights are used to calculate smoke values for individual zip codes over the specified 11-year timeframe. To achieve this, the project utilizes an area-weighted averaging technique applied to a 10km grid, ensuring that the sum of weights within each zip code polygon equals 1. This methodology allows us to estimate smoke concentrations at a local level, providing valuable insights into the impact of wildfire smoke on different regions.

## Data Sources

- **10km_grid/10km_grid_wgs84/**: This directory contains the shapefile for the 10 km grid, which serves as the spatial framework for the project. You can access the original grid data on GitHub at [https://github.com/echolab-stanford/daily-10km-smokePM](https://github.com/echolab-stanford/daily-10km-smokePM).

- **10km_grid/smokePM2pt5_predictions_daily_10km_20060101-20201231.rds:** This file comprises a data frame containing the final set of daily smoke PM2.5 predictions on days with smoke events at a 10 km resolution. It covers the time span from January 1, 2006, to December 31, 2020, encompassing the contiguous United States. The 'grid_id_10km' column in this file corresponds to the 'ID' column in the 10 km grid shapefile.

- **Yearly zipcode grid shapefile:** Located at "./data/input/Zipcode_Info/polygon/ESRI," this shapefile represents the yearly zipcode grid. It plays a crucial role in the aggregation of smoke data to the zipcode level. This file is obtained from ArcGIS shapefile: [https://www.arcgis.com/home/item.html?id=46b350fa939149debfd9cc71566b43b4](ArcGIS Shapefile)

## Output

The primary output of this project is a CSV file containing the following columns: zip_id, date, and smoke values. This file provides a detailed breakdown of smoke concentrations for each zip code on a daily basis. Below is an example of what the output file looks like:

```plaintext
  zip   date       smoke
  <chr> <date>     <dbl>
1 00012 2016-01-01     0
2 00012 2016-01-02     0
3 00012 2016-01-03     0
4 00012 2016-01-04     0
5 00012 2016-01-05     0
6 00012 2016-01-06     0
```

## Accessing Data

If you have access to the NSAPH CANNON database, you can find the project's data at the following location: "/n/dominici_lab/lab/data_processing/smoke_aggregation". However, if you do not have access to this database, you can still obtain the data through the Dataverse platform at [https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/VHNJBD](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/VHNJBD).

## Running Example Weights

To run example weights and perform smoke aggregation, navigate to the 'code' directory, and execute the following R scripts in sequence:

1. **01_yearly_grid_mean.R**: This script calculates yearly grid means for smoke values.
2. **02_match_cts_extent_list.R**: It matches coordinate reference systems (CRS) and extents for different spatial objects.
3. **03_run_get_weights_par_script.R**: This script computes standardized weights for zip codes based on the 10km grid.
4. **04_daily_aggregation.R**: This script aggregates daily smoke values to generate comprehensive smoke data for individual zip codes.

## Notebook EDA

The 'notebooks' folder contains a collection of notebooks that offer detailed explanations and insights into various aspects of the code and data processing:

1. **01_eda_preds.Rmd:** This notebook aids in identifying grids with daily smoke data and provides a comprehensive distribution analysis of smoke values.
2. **02_yearly_grid_mean.Rmd:** It explains the process of aggregating data to obtain grid_id, year, and corresponding smoke values.
3. **03_match_cts_extent.Rmd:** This notebook covers the alignment of spatial objects by matching CRS and extents. It also illustrates how to create bounding boxes and visualize the mapping between zip codes and grid_id.
4. **04_test_grid_to_zip.Rmd:** Demonstrating the joining of grid data with smoke values using the 'over' function.
5. **07_get_weights_par_test.Rmd:** This notebook serves as a unit test for the 'get_weights_par' function, ensuring that the sum of weights for each zip code equals 1.
6. **08_zip_code_EDA.Rmd:** Focusing on ZIP code analysis, this EDA notebook helps understand the coverage of the smoke aggregation files within specific geographic regions.

Feel free to explore these notebooks for a deeper understanding of the code and data processing steps, which can provide valuable insights into the project's methodology and findings.

