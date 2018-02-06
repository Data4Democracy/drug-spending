library(tidyverse)
library(data.world)
# data import from data.world using the data.world package:
drug.spend.ds <- "https://data.world/data4democracy/drug-spending"
# variables in the data:
part.d.var <- data.world::query(
  data.world::qry_sql("SELECT * FROM variables"),
  dataset = drug.spend.ds 
)
# full part D data
part.d.data <- data.world::query(
  data.world::qry_sql("SELECT * FROM data"),
  dataset = drug.spend.ds
)
# data structure
glimpse(part.d.data)
# sanity check - are any drugs missing data for all years?
dim(part.d.data %>% 
      filter(
        is.na(claim_count_2011) & is.na(claim_count_2012) & is.na(claim_count_2013) & is.na(claim_count_2014) & is.na(claim_count_2015)
      )
)
# data for 2011
d.2011 <- part.d.data %>% 
  select(ends_with("name"), ends_with("2011")) %>% 
  mutate(year = 2011, annual_change_in_average_cost_per_unit = NA)
# remove the years from the column names
cln.names <- str_replace(colnames(d.2011), "_2011", "")
colnames(d.2011) <- cln.names
# lots of copy/paste, but just need to finish
d.full <- d.2011 %>% 
  bind_rows(
    part.d.data %>% 
      select(ends_with("name"), ends_with("2012")) %>% 
      mutate(year = 2012, annual_change_in_average_cost_per_unit = NA) %>% 
      `colnames<-`(cln.names)
  ) %>%
  bind_rows(
    part.d.data %>% 
      select(ends_with("name"), ends_with("2013")) %>% 
      mutate(year = 2013, annual_change_in_average_cost_per_unit = NA) %>% 
      `colnames<-`(cln.names)
  ) %>%
  bind_rows(
    part.d.data %>% 
      select(ends_with("name"), ends_with("2014")) %>% 
      mutate(year = 2014, annual_change_in_average_cost_per_unit = NA) %>% 
      `colnames<-`(cln.names)
  ) %>%
  bind_rows(
    part.d.data %>% 
      select(ends_with("name"), ends_with("2015"), -annual_change_in_average_cost_per_unit_2015) %>% 
      mutate(
        year = 2015, 
        annual_change_in_average_cost_per_unit = part.d.data$annual_change_in_average_cost_per_unit_2015
        ) %>% 
      `colnames<-`(cln.names)
    )
glimpse(d.full)
dim(d.full)

# sanity checks:
sum(is.na(part.d.data %>% select(starts_with("claim_count"))))
sum(is.na(d.full$claim_count))
sum(is.na(d.full$year))
sum(is.na(part.d.data %>% select(starts_with("average_cost_per_unit"))))
sum(is.na(d.full$average_cost_per_unit_weighted))

d.full <- d.full %>% 
  mutate(brand_name = str_to_lower(brand_name), generic_name = str_to_lower(generic_name)) %>% 
  select(ends_with("_name"), year, everything()) %>% 
  arrange(generic_name, brand_name, year)

# dwapi::upload_data_frame(
#  dataset = drug.spend.ds,
#  file_name = "spending_part_d_2011to2015_tidy.csv",
#  data_frame = d.full
# )
