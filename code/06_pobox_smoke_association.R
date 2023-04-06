library(tidyverse)
library(magrittr)
library(lubridate)
library(sf)
#library(viridis)
#library(fst)
#library(data.table)
#library(dplyr)
#library(rgeos)
#library(sp)

years = sprintf("%04d", c(2006:2016))
load("../data/input/smoke/daily_zip.RData")
zip_smoke_df = as.data.frame(zip_smoke_df)%>% 
  mutate(year = year(date))

# load("../data/intermediate/scratch/pobox_zip_df.RData")

# Create output data.frame
smoke_df = data.frame(ZIP = character(),
                      date = Date(),
                      smoke = double(),
                      stringsAsFactors = FALSE)

for(year in years){
  
  # load smoke value
  zip_smoke_df_y = zip_smoke_df[zip_smoke_df$year == as.numeric(year),]%>%
    rename(ZIP = zip)
  
  pobox_zip = pobox_zip_df[pobox_zip_df$year == as.numeric(year),]
  
  pobox_zip = pobox_zip[!pobox_zip$PO_BOX %in% zip_smoke_df$ZIP,]
  
  pobox_zip %<>%
    left_join(zip_smoke_df_y, by = c("ZIP"))
  
  sub_smoke = pobox_zip[, c("PO_BOX", "date", "smoke")] %>%
    rename(ZIP = PO_BOX) 
  
  smoke_df = rbind(smoke_df, zip_smoke_df_y[,1:3], sub_smoke)
  
}

saveRDS(smoke_df, file =  "../data/input/smoke/smoke_df.rds")

