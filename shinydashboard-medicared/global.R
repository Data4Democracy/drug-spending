library(feather)
drug_costs <- read_feather('testing-top100-byuser.feather')
default_drug <- drug_costs$drugname_generic[1]
