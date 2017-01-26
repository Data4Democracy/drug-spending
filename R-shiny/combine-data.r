
#This file combines the 2011-2015 data into a single feather file

library(feather)
library(jsonlite)
library(dplyr)

# load in spending data
spend2011 <- read_feather('../data/spending-2011.feather')
spend2012 <- read_feather('../data/spending-2012.feather')
spend2013 <- read_feather('../data/spending-2013.feather')
spend2014 <- read_feather('../data/spending-2014.feather')
spend2015 <- read_feather('../data/spending-2015.feather')

# add year column
spend2011$year <- 2011
spend2012$year <- 2012
spend2013$year <- 2013
spend2014$year <- 2014
spend2015$year <- 2015

# stack the dataframes
spend <- rbind(spend2011, spend2012, spend2013, spend2014, spend2015)
rm(spend2011,spend2012,spend2013,spend2014,spend2015)

spend <- spend[order(spend$drugname_generic, spend$drugname_brand, spend$year),]

# write_feather(spend, 'combined-spending.feather')

# create list of all drugs
drug_list <- unique(spend$drugname_generic)

#take random 100 drug sample from the drug list
drug_list_random <- sample(drug_list, size = 100)
write_feather(spend[spend$drugname_generic %in% drug_list_random,], 'testing-random.feather')

#take the first 100 drugs sorted by # of user
by_user <- group_by(spend, drugname_generic) %>%
    summarise(total_users = sum(user_count, na.rm = TRUE)) %>%
    arrange(desc(total_users))

by_user_top100 <- head(by_user, 100)

write_feather(spend[spend$drugname_generic %in% by_user_top100$drugname_generic,], 'testing-top100-byuser.feather')

