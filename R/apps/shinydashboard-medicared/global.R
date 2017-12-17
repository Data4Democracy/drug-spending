library(tidyverse)

## -- Read in data sets used for all plots ---------------------------------------------------------
## install.packages("data.world")
library(data.world)

## Set connection with data.world - only need to do this once per session

## My data.world API token is stored in my .Renviron file, like this:
## DW_API=abunchoflettersandnumbers
## That lets me share my code with no security risk.
saved_cfg <- data.world::save_config(Sys.getenv("DW_API"))
data.world::set_config(saved_cfg)

## Name the URL for the dataset we want
url_drugs <- "https://data.world/data4democracy/drug-spending"

## Query data.world to get all available table names
tables_drugs <- data.world::query(
  data.world::qry_sql("SELECT * FROM Tables"), ## qry_sql sends an SQL query
  dataset = url_drugs ## this is the dataset we want to query
)
tables_drugs

## Read in dataset from data.world
drug_costs_everything <- data.world::query(
  data.world::qry_sql("SELECT * FROM spending_all_top100"),
  dataset = url_drugs
)

# ## Alternately: Read in dataset direct from data.world
# drug_costs_everything <- read.csv("https://query.data.world/s/1y5at2ieqmq2y4txl98psir76",
#                                   header = TRUE)

drug_costs_brands <- drug_costs_everything %>%
  filter(drugname_brand != "ALL BRAND NAMES")

drug_costs_overall <- drug_costs_everything %>%
  filter(drugname_brand == "ALL BRAND NAMES")

## If working offline: use feather files from pre-data.world
# library(feather)
# drug_costs_brands <- read_feather('testing-top100-byuser.feather')
# drug_costs_overall <- read_feather('testing-top100-byuser-overall.feather')

## -- Add numeric indicator for each brand name within a generic, in descending order of -----------
## -- total users over time ------------------------------------------------------------------------
brand_indicators <- drug_costs_brands %>%
  group_by(drugname_brand, drugname_generic) %>%
  summarise(total_users = sum(user_count, na.rm = TRUE)) %>%
  arrange(drugname_generic, desc(total_users)) %>%
  ungroup() %>%
  group_by(drugname_generic) %>%
  mutate(generic_num = 1:n()) %>%
  ungroup()

drug_costs_brands <- left_join(drug_costs_brands,
                               dplyr::select(brand_indicators, -total_users),
                               by = c('drugname_brand', 'drugname_generic'))

## -- For out-of-pocket costs, want to easily compare low-income vs non-low-income users; create ---
## -- data frame in long format --------------------------------------------------------------------
oop_costs <- drug_costs_brands %>%
  dplyr::select(drugname_brand, drugname_generic, year, out_of_pocket_avg_non_lowincome,
                out_of_pocket_avg_lowincome) %>%
  gather(key = lis_status, value = oop_avg,
         out_of_pocket_avg_non_lowincome:out_of_pocket_avg_lowincome) %>%
  mutate(lis_status = gsub('out_of_pocket_avg_', '', lis_status, fixed = TRUE),
         lis_status = factor(ifelse(lis_status == 'lowincome', 1, 2),
                             levels = 1:2,
                             labels = c('Patients Receiving Low-Income Subsidy',
                                        'Patients Receiving No Subsidy')))

