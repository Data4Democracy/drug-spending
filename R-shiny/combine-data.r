
#This file combines the 2011-2015 data into a single feather file

library(feather)
library(jsonlite)

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

# add theraputic areas to spend

# load in drug names
drug_names <- read_feather('../data/drugnames.feather')
drug_info <- fromJSON('../data/drug_list.json')


# format the drug_info names so they can be used to match in the drug_names list
spend[,'theriputic_areas'] <- NA

for(drug in drug_info$name){
    name <- toupper(drug)
    # grab first word from name
    name <- strsplit(name, split = ' ')
    match <- grep(name[[1]][1], drug_names$drugname_brand)
    
    spend[spend$drugname_brand == drug_names[match,1], "theriputic_areas"] <- drug_info[drug_info$name == drug, "therapeutic_areas" ][[1]]
    # match first word to any word in spend brand names
    
}

write_feather(spend, 'combined-spending.feather')