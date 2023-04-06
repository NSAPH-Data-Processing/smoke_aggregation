# Adjusting the annual averages

# total pm
f <- list.files("/n/dominici_nsaph_l3/Lab/projects/analytic/denom_by_year",
                pattern = "\\.fst",
                full.names = TRUE)[8:18]
myvars <- c("year", "zip", "pm25_ensemble")

medicare_df <- as.data.frame(rbindlist(lapply(f,
                                              read_fst,
                                              columns = myvars,
                                              as.data.table = TRUE))) %>%
  mutate(zip = sprintf("%05d", zip))

total_pm = medicare_df %>%
  group_by(zip, year) %>%
  summarize(pm = mean(pm25_ensemble))

saveRDS(total_pm, file = "../data/input/smoke/total_pm.rds")

# smoke pm
smoke_df = readRDS("../data/input/smoke/smoke_df.rds")

smoke_pm = smoke_df %>% 
  mutate(year = year(date)) %>% 
  rename(zip = ZIP) %>%
  group_by(zip, year) %>%
  summarize(smoke = mean(smoke))

saveRDS(smoke_pm, file = "../data/input/smoke/smoke_pm.rds")
