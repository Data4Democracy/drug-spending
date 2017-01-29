####################################################################################################
## Combine 2011-2015 data housed on data.world into a single feather file
####################################################################################################

library(data.world)
library(feather)
library(jsonlite)
library(tidyverse)

## Set connection (see package README for details: https://github.com/datadotworld/data.world-r)
conn <- data.world()

## What data tables are available? (both dplyr and data.world have a query(); must specify)
data_list <- data.world::query(conn,
                               dataset = 'data4democracy/drug-spending',
                               query = "SELECT * FROM Tables")

## -- Read in each year's data set, add year and drug names, combine into a single data.frame ------
## Function to add a column with spending year to a data frame
add_drug_year <- function(df, yr){
  mutate(df, year = yr)
}

## Function to read in one year's CSV from data.world
## First column is a row number; don't need that
get_year <- function(yr){
  data.world::query(connection = conn,
                    dataset = 'data4democracy/drug-spending',
                    query = paste0("SELECT * FROM `spending-", yr, "`"))[,-1]
}

drug_years <- 2011:2015

spend <- map(drug_years, get_year) %>%
  map2(drug_years, add_drug_year) %>%
  bind_rows()

## -- For testing: data set of 100 random generics -------------------------------------------------
drug_list <- unique(spend$drugname_generic)
drug_list_random <- sample(drug_list, size = 100)
write_feather(spend[spend$drugname_generic %in% drug_list_random,], 'testing-random.feather')

## -- For testing: Take first 100 drugs sorted by # of users ---------------------------------------
by_user_top100 <- group_by(spend, drugname_generic) %>%
  summarise(total_users = sum(user_count, na.rm = TRUE)) %>%
  arrange(desc(total_users)) %>%
  slice(1:100)

write_feather(spend[spend$drugname_generic %in% by_user_top100$drugname_generic,],
              'testing-top100-byuser.feather')
