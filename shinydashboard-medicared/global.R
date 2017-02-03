library(tidyverse)

## -- Read in data sets used for all plots ---------------------------------------------------------
library(feather)
drug_costs <- read_feather('testing-top100-byuser.feather')
drug_costs_overall <- read_feather('testing-top100-byuser-overall.feather')

## -- Add numeric indicator for each brand name within a generic, in descending order of -----------
## -- total users over time ------------------------------------------------------------------------
brand_indicators <- drug_costs %>%
  group_by(drugname_brand, drugname_generic) %>%
  summarise(total_users = sum(user_count, na.rm = TRUE)) %>%
  arrange(drugname_generic, desc(total_users)) %>%
  ungroup() %>%
  group_by(drugname_generic) %>%
  mutate(generic_num = 1:n()) %>%
  ungroup()

drug_costs <- left_join(drug_costs,
                        dplyr::select(brand_indicators, -total_users),
                        by = c('drugname_brand', 'drugname_generic'))

## -- For out-of-pocket costs, want to easily compare low-income vs non-low-income users; create ---
## -- data frame in long format --------------------------------------------------------------------
oop_costs <- drug_costs %>%
  dplyr::select(drugname_brand, drugname_generic, year, out_of_pocket_avg_non_lowincome,
                out_of_pocket_avg_lowincome) %>%
  gather(key = lis_status, value = oop_avg,
         out_of_pocket_avg_non_lowincome:out_of_pocket_avg_lowincome) %>%
  mutate(lis_status = gsub('out_of_pocket_avg_', '', lis_status, fixed = TRUE),
         lis_status = factor(ifelse(lis_status == 'lowincome', 1, 2),
                             levels = 1:2,
                             labels = c('Patients Receiving Low-Income Subsidy',
                                        'Patients Receiving No Subsidy')))

