## -- Read in data sets used for all plots ---------------------------------------------------------
library(feather)
drug_costs <- read_feather('testing-top100-byuser.feather')
drug_costs_overall <- read_feather('testing-top100-byuser-overall.feather')

## -- For out-of-pocket costs, want to easily compare low-income vs non-low-income users; create ---
## -- data frame in long format --------------------------------------------------------------------
library(tidyverse)

oop_costs <- drug_costs %>%
  dplyr::select(drugname_brand, drugname_generic, year, out_of_pocket_avg_non_lowincome,
                out_of_pocket_avg_lowincome) %>%
  gather(key = lis_status, value = oop_avg,
         out_of_pocket_avg_non_lowincome:out_of_pocket_avg_lowincome) %>%
  mutate(lis_status = gsub('out_of_pocket_avg_', '', lis_status, fixed = TRUE))
