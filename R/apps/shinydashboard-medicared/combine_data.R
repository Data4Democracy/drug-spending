###############################################################################
## Combine 2011-2015 data housed on data.world into a single  file
###############################################################################

library(tidyverse)

# data.world setup and inspection ---------------------------------------------
library(data.world)

# API token is saved in .Renviron (DW_API)
data.world::set_config(cfg_env("DW_API"))

# Datasets are identified by their URL
drugs_ds <- "https://data.world/data4democracy/drug-spending"

# List tables
data_list <- data.world::query(qry_sql("SELECT * FROM Tables"),
  dataset = drugs_ds)

data_list

# We want all the spending-201x tables

# Read in and combine datasets from all five years ----------------------------

# Function to read in a single year's CSV from data.world and add year
get_year <- function(yr) {
  data.world::query(qry_sql(paste0("SELECT * FROM `spending-", yr, "`")),
    dataset = drugs_ds)[,-1] %>%
    ## First column is a row number; don"t need that
    mutate(year = yr)
}

# Read in and combine all years' data
spend <- map_df(2011:2015, get_year)

# Add a row for each generic with overall summaries of each variable ----------
spend_overall <- spend %>%
  group_by(drugname_generic, year) %>%
  summarise(
    claim_count = sum(claim_count, na.rm = TRUE),
    total_spending = sum(total_spending, na.rm = TRUE),
    user_count = sum(user_count, na.rm = TRUE),
    unit_count = sum(unit_count, na.rm = TRUE),
    user_count_non_lowincome = sum(user_count_non_lowincome, na.rm = TRUE),
    user_count_lowincome = sum(user_count_lowincome, na.rm = TRUE)
  ) %>%
  mutate(
    total_spending_per_user = total_spending / user_count,
    drugname_brand = "ALL BRAND NAMES",
    ## Add NA values for variables that are brand-specific
    unit_cost_wavg = NA,
    out_of_pocket_avg_lowincome = NA,
    out_of_pocket_avg_non_lowincome = NA
  ) %>%
  ungroup()

# Select top 100 generics by number of users across all five years ------------
by_user_top100 <- group_by(spend_overall, drugname_generic) %>%
  summarise(total_users = sum(user_count, na.rm = TRUE)) %>%
  arrange(desc(total_users)) %>%
  slice(1:100)

# For top 100 generics, add ALL BRAND NAMES rows to by-brand-name rows --------
spend_all_top100 <- bind_rows(spend, spend_overall) %>%
  filter(drugname_generic %in% by_user_top100$drugname_generic) %>%
  arrange(drugname_generic)

# Write final file to data.world using SDK ------------------------------------

# data.world's REST API methods are available via the dwapi package
dwapi::upload_data_frame(
  dataset = drugs_ds,
  file_name = "spending_all_top100.csv",
  data_frame = spend_all_top100
)
