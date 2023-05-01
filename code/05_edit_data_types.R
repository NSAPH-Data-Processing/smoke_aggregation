library(tidyverse)
library(magrittr)
library(lubridate)
library(sf)
library(dplyr)
library(ggplot2)
sf_use_s2(FALSE)


# Loop through years 2006 to 2016
for (year in 2006:2016) {
  # Construct file names for input and output CSV files
  input_file <- sprintf("../data/output/daily_zip_%d.csv", year)
  output_file <- sprintf("../data/output/daily_zip/daily_zip_%d.csv", year)
  
  # Read in the input CSV file
  df <- read.csv(input_file)
  
  # Convert zip column to character format with leading zeros
  df$zip <- sprintf("%05d", df$zip)
  
  # Save modified data frame as new CSV file
  write.csv(df, output_file, row.names = FALSE)
}
