library(tidyverse)
library(jsonlite)
library(data.world)
# data import 
drug.list <- read_json("drug_list.json")
drug.therap <- map(drug.list, "therapeutic_areas")
drug.name <- map_chr(drug.list, 2) %>% 
  str_to_lower()
drug.apr <- map_chr(drug.list, 3)
drug.co <- map_chr(drug.list, 4) %>% 
  str_to_lower()
drug.desc <- map(drug.list, 5) %>% 
  str_to_lower()
# one null in the list
drug.desc[[980]] <- NA
drug.desc <- tbl_df(unlist(drug.desc))
name.test <- gsub(".*\\((.*)\\).*", "\\1", drug.name)
names1 <- tbl_df(drug.name) %>%
  bind_cols(tbl_df(name.test))
colnames(names1) <- c("full_name", "alt_name")
name.brand <- tbl_df(str_trim(gsub("\\(.*\\)", "\\1", drug.name))) %>% 
  set_names("name_brand")
names1 <- names1 %>% 
  bind_cols(name.brand)
drug.info1 <- names1 %>% 
  bind_cols(tbl_df(drug.apr) %>% set_names("approval")) %>% 
  bind_cols(tbl_df(drug.co) %>% set_names("company")) %>% 
  bind_cols(drug.desc %>% set_names("therapeutic_use"))
# messing around with matching a bit
drug.spend.ds <- "https://data.world/data4democracy/drug-spending"
d.drugs <- data.world::query(
  data.world::qry_sql("SELECT DISTINCT brand_name, generic_name FROM `spending_part_d_2011to2015_tidy`"),
  dataset = drug.spend.ds
  )
dim(d.drugs)
join.test1 <- d.drugs %>% 
  semi_join(drug.info1, by = c("brand_name" = "alt_name"))
join.test2 <- d.drugs %>% 
  semi_join(drug.info1, by = c("brand_name" = "name_brand"))
join.test3 <- d.drugs %>% 
  semi_join(drug.info1, by = c("generic_name" = "alt_name"))
dim(join.test1)
dim(join.test2)
dim(join.test3)
dim(join.test1 %>% anti_join(join.test2))
dim(join.test2 %>% anti_join(join.test3))
dim(join.test1 %>% anti_join(join.test3))

# for now, toss out the alt_name and the name_brand attempts, 
# those will need some work and its not worth uploading them
drug.info.upl <- drug.info1 %>% 
  select(-alt_name, -name_brand)
# just noticed that this dataset only has data dating back to 1995. Not worth the hassle at this time.