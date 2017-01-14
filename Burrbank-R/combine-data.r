
#This file combines the 2011-2015 data into a single feather file

library(feather)

spend2011 <- read_feather('../data/spending-2011.feather')
spend2012 <- read_feather('../data/spending-2012.feather')
spend2013 <- read_feather('../data/spending-2013.feather')
spend2014 <- read_feather('../data/spending-2014.feather')
spend2015 <- read_feather('../data/spending-2015.feather')


spend2011$year <- 2011
spend2012$year <- 2012
spend2013$year <- 2013
spend2014$year <- 2014
spend2015$year <- 2015

spend <- rbind(spend2011, spend2012, spend2013, spend2014, spend2015)

spend <- test[order(test$drugname_generic, test$year),]

write_feather(spend, 'combined-spending.feather')