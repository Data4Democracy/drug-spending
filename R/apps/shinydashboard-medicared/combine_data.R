####################################################################################################
## Combine 2011-2015 data housed on data.world into a single feather file
####################################################################################################

library(data.world)
library(tidyverse)

## Set connection (see package README for details: https://github.com/datadotworld/data.world-r)
conn <- data.world(token = Sys.getenv("DW_API")) ## API token is saved in .Renviron

## -- What data tables are available? (both dplyr and data.world have a query(); must specify) -----
data_list <- data.world::query(conn,
                               dataset = 'data4democracy/drug-spending',
                               query = "SELECT * FROM Tables")

data_list

## We want all the spending-201x tables

## -- Read in and combine datasets from all five years ---------------------------------------------
## Function to read in a single year's CSV from data.world and add year
get_year <- function(yr){
  data.world::query(connection = conn,
                    dataset = 'data4democracy/drug-spending',
                    query = paste0("SELECT * FROM `spending-", yr, "`"))[,-1] %>%
                    ## First column is a row number; don't need that
    mutate(year = yr)
}

## Read in and combine all years' data
spend <- map_df(2011:2015, get_year)

## -- Add a row for each generic with overall summaries of each variable ---------------------------
spend_overall <- spend %>%
  group_by(drugname_generic, year) %>%
  summarise(claim_count = sum(claim_count, na.rm = TRUE),
            total_spending = sum(total_spending, na.rm = TRUE),
            user_count = sum(user_count, na.rm = TRUE),
            unit_count = sum(unit_count, na.rm = TRUE),
            user_count_non_lowincome = sum(user_count_non_lowincome, na.rm = TRUE),
            user_count_lowincome = sum(user_count_lowincome, na.rm = TRUE)) %>%
  mutate(total_spending_per_user = total_spending / user_count,
         drugname_brand = "ALL BRAND NAMES",
         ## Add NA values for variables that are brand-specific
         unit_cost_wavg = NA,
         out_of_pocket_avg_lowincome = NA,
         out_of_pocket_avg_non_lowincome = NA) %>%
  ungroup()

## -- Select top 100 generics by number of users across all five years -----------------------------
by_user_top100 <- group_by(spend_overall, drugname_generic) %>%
  summarise(total_users = sum(user_count, na.rm = TRUE)) %>%
  arrange(desc(total_users)) %>%
  slice(1:100)

## -- For top 100 generics, add ALL BRAND NAMES rows to by-brand-name rows -------------------------
spend_all_top100 <- bind_rows(spend, spend_overall) %>%
  filter(drugname_generic %in% by_user_top100$drugname_generic) %>%
  arrange(drugname_generic)

## -- Write final file to data.world using SDK -----------------------------------------------------
data.world::uploadDataFrame(connection = conn,
                            fileName = "spending_all_top100.csv",
                            dataFrame = spend_all_top100,
                            dataset = "data4democracy/drug-spending")
