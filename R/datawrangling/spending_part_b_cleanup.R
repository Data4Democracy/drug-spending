library(tidyverse)
library(data.world)
# data import from data.world using the data.world package:
drug.spend.ds <- "https://data.world/data4democracy/drug-spending"
# variables in the data:
part.b.var <- data.world::query(
  data.world::qry_sql("SELECT * FROM variables_2"),
  dataset = drug.spend.ds 
)
# full part B data
part.b.data <- data.world::query(
  data.world::qry_sql("SELECT * FROM data_2"),
  dataset = drug.spend.ds
)
# data structure
glimpse(part.b.data)
# data for 2011
b.2011 <- part.b.data %>% 
  select(starts_with("hcpcs"), ends_with("2011")) %>% 
  mutate(year = 2011, annual_change_in_average_cost_per_unit = NA)
# remove the years from the column names
cln.names <- str_replace(colnames(b.2011), "_2011", "")
colnames(b.2011) <- cln.names
# lots of copy/paste, but just need to finish
b.full <- b.2011 %>% 
  bind_rows(
    part.b.data %>% 
      select(starts_with("hcpcs"), ends_with("2012")) %>% 
      mutate(year = 2012, annual_change_in_average_cost_per_unit = NA) %>% 
      `colnames<-`(cln.names)
  ) %>%
  bind_rows(
    part.b.data %>% 
      select(starts_with("hcpcs"), ends_with("2013")) %>% 
      mutate(year = 2013, annual_change_in_average_cost_per_unit = NA) %>% 
      `colnames<-`(cln.names)
  ) %>%
  bind_rows(
    part.b.data %>% 
      select(starts_with("hcpcs"), ends_with("2014")) %>% 
      mutate(year = 2014, annual_change_in_average_cost_per_unit = NA) %>% 
      `colnames<-`(cln.names)
  ) %>%
  bind_rows(
    part.b.data %>% 
      select(starts_with("hcpcs"), ends_with("2015"), -annual_change_in_average_cost_per_unit_2015) %>% 
      mutate(
        year = 2015, 
        annual_change_in_average_cost_per_unit = part.b.data$annual_change_in_average_cost_per_unit_2015
        ) %>% 
      `colnames<-`(cln.names)
    )
glimpse(b.full)
# sanity checks:
sum(is.na(part.b.data %>% select(starts_with("claim_count"))))
sum(is.na(b.full$claim_count))
sum(is.na(b.full$year))
sum(is.na(b.full$hcpcs_code))
sum(is.na(part.b.data$hcpcs_code))
sum(is.na(part.b.data %>% select(starts_with("average_cost_per_unit"))))
sum(is.na(b.full$average_cost_per_unit))

# would like for the variable names to match the part d data as much as possible
part.d.data <- data.world::query(
  data.world::qry_sql("SELECT * FROM `spending-2011` LIMIT 20"),
  dataset = drug.spend.ds
)
colnames(part.d.data)
colnames(b.full)
# not immediately clear what needs to be done to combine these datasets in the future
# will worry about this later
b.full <- b.full %>% 
  select(hcpcs_code, hcpcs_description, year, everything())
glimpse(b.full)
# good enough for now
# dwapi::upload_data_frame(
#  dataset = drug.spend.ds,
#  file_name = "spending_part_b_2011to2015_tidy.csv",
#  data_frame = b.full
# )
