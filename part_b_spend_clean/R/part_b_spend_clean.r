library(readxl)
library(stringr)
library(tidyverse)

# Read data----
in_file <- "data/Medicare_Drug_Spending_PartB_All_Drugs_YTD_2015_12_06_2016.xlsx"

data_definitons <- read_excel(in_file, 2, skip = 1) %>%
  select(variable = Variables, definiton = 2) %>% 
  mutate(variable = tolower(gsub("( )|(, )","_",variable)),
         variable = gsub("_\\(2015_only\\)","",variable))

data <- read_excel(in_file, 3, skip = 2) %>% 
  setNames(tolower(gsub("( )|(, )","_",names(.)))) %>% 
  filter(!is.na(hcpcs_code)) %>% 
  rename(average_beneficiary_cost_share_2015 = average_annual_beneficiary_cost_share_2015) %>% 
  mutate(hcpcs_description = trimws(hcpcs_description),
         hcpcs_code = trimws(hcpcs_code)) %>% 
  select(hcpcs_code, everything())

# Tidy data----

variable_names <- data %>% 
  select(-contains("hcpcs")) %>% 
  setNames(tolower(str_replace(names(.), "_[0-9]{4}",""))) %>% 
  names() %>% 
  unique()

make_variable_df <- function(variable_name){
  variable_df <- data %>% 
    select(1:2, starts_with(variable_name))
  
  variable_df %>% 
    gather_("year", variable_name, names(variable_df[3:ncol(variable_df)])) %>% 
    mutate(year = str_replace(year, ".+?(?=[0-9]{4})", ""))
}

variable_df_list <- map(variable_names, make_variable_df)

part_b_spend_clean <- Reduce(function(x, y) merge(x, y, all=TRUE), variable_df_list)

# Write data----
write_csv(data_definitons, "output/data_definitons.csv")
write_csv(part_b_spend_clean, "output/part_b_spend_clean.csv")

