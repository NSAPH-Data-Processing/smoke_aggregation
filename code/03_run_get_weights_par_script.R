source("03_run_get_weights_par.R")


# Define the range of years to loop through
years <- 2006:2016

# Loop through each year and call the 03_run_get_weights_par.R script with the appropriate -y parameter
for (year in years) {
  command <- paste("Rscript 03_run_get_weights_par.R -y", year, "-c 40", sep=" ")
  system(command)
}