# Cleaning January 2017 CMS drug name, manufacturer, and dosage data
# S. Kirmer
# Data4Democracy - Drug Spending Project
# January 2017

# Script follows the drug_manufacturer_data_cleaning scripts.

drugs_2017 <- read.csv("U://Medicaid_Drug/2017drugdata.csv", stringsAsFactors = FALSE)
drugs_2016 <- read.csv("U://Medicaid_Drug/2016drugdata.csv", stringsAsFactors = FALSE)

drugs <- rbind(drugs_2017, drugs_2016)

drugs$LABELER.NAME <- toupper(drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("abbvie",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "ABBVIE US, LLC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("ACCORD",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "ACCORD HEALTHCARE INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("ACORDA",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "ACORDA THERAPEUTICS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("ACTAVIS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "ACTAVIS INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("AKORN",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "AKORN", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("AMERICAN REGENT",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "AMERICAN REGENT INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("APOPHARMA",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "APOPHARMA", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("APTALIS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "APTALIS PHARMA US", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("AUXILIUM",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "AUXILIUM PHARMACEUTICALS", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("BD RX",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "BD RX", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("CARACO",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "CARACO PHARMACEUTICAL LABORATORIES", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("EYETECH",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "EYETECH", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("AMGEN",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "AMGEN USA, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("AMNEAL",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "AMNEAL PHARMACEUTICALS, LLC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("AMPHASTAR",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "AMPHASTAR PHARMACEUTICALS, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("ASTRAZENECA",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "ASTRAZENECA PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("BAUSCH & LOMB",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "BAUSCH & LOMB", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("BAXALTA",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "BAXALTA US INC.", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("BAXTER",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "BAXTER HEALTHCARE CORPORATION", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("BAYER",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "BAYER HEALTHCARE PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("BIOCSL",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "BIOCSL INC", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("BIOGEN",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "BIOGEN IDEC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("BLUEPOINT",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "BLUE POINT LABORATORIES", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("BRACCO",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "BRACCO DIAGNOSTICS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("BRISTOL-MYERS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "BRISTOL-MYERS SQUIBB COMPANY", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("CANGENE",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "CANGENE BIOPHARMA, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("CEPHALON",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "CEPHALON INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("CHIESI",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "CHIESI USA, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("COVIS PHARMACEUTICALS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "COVIS PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("CREALTA",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "CREALTA PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("CSL BEHRING",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "CSL BEHRING LLC", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("REDDY'S",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "DR. REDDY'S LABORATORIES, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("DURATA",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "DURATA PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("DYAX",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "DYAX CORPORATION", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("ENDO",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "ENDO PHARMACEUTICALS VALERA INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("FERRING",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "FERRING PHARMACEUTICALS INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("FRESENIUS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "FRESENIUS KABI USA LLC", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("FOREST LABORATORIES",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "FOREST LABORATORIES", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("GLENMARK",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "GLENMARK PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("HOSPIRA",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "HOSPIRA INC", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("GENZYME",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "GENZYME CORPORATION", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("GREENSTONE",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "GREENSTONE LLC", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("GRIFOLS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "GRIFOLS USA, LLC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("HALOZYME",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "HALOZYME THERAPEUTICS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("HERITAGE",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "HERITAGE PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("HI-TECH",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "HI-TECH PHARMACEUTICAL CO, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("IPSEN",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "IPSEN BIOPHARMACEUTICALS", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("JANSSEN",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "JANSSEN PHARMACEUTICALS, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("JHP",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "JHP PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("KEDRION",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "KEDRION BIOPHARMA, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("KINETIC",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "KINETIC CONCEPTS INCORPORATED", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("LANTHEUS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "LANTHEUS MEDICAL IMAGING", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("MEDICIS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "MEDICIS PHARMACEUTICALS, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("MERCK",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "MERCK", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("MERZ",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "MERZ PHARMACEUTICALS, LLC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("MYLAN",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "MYLAN PHARMACEUTICALS, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("NOVARTIS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "NOVARTIS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("NOVO NORDISK",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "NOVO NORDISK, INC", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("NOVAPLUS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "NOVAPLUS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("OTSUKA",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "OTSUKA AMERICA", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("PHOTOCURE",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "PHOTOCURE INC", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("MEDICINES COMPANY",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "MEDICINES COMPANY, THE", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("OMEROS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "OMEROS CORPORATION", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("PAR ",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "PAR PHARMACEUTICAL", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("PERRIGO",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "PERRIGO PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("PFIZER",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "PFIZER INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("RITEDOSE",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "RITEDOSE PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("ROXANE",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "ROXANE LABORATORIES", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("SAGENT",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "SAGENT PHARMACEUTICALS INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("SANDOZ",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "SANDOZ, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("SANOFI",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "SANOFI-AVENTIS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("SCHERING",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "SCHERING CORPORATION", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("SHIRE",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "SHIRE US, INC", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("SICOR",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "SICOR PHARMACEUTICALS, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("STRIDES",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "STRIDES PHARMA INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("SUN PHARMACEUTICAL",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "SUN PHARMACEUTICAL INDUSTRIES, LTD", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("TARO",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "TARO PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("THERAVANCE",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "THERAVANCE BIOPHARMA, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("TEVA",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "TEVA PHARMACEUTICALS USA, INC", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("UNITED THERAPEUTICS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "UNITED THERAPEUTICS CORPORATION", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("TOLMAR",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "TOLMAR PHARMACEUTICALS, INC", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("WATSON",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "WATSON PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("WG CRITICAL",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "WG CRITICAL CARE LLC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("WYETH",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "WYETH PHARMACEUTICAL", drugs$LABELER.NAME)

drugs$LABELER.NAME <- ifelse(grepl("WEST-WARD",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "WEST-WARD PHARMACEUTICALS CORP", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("X-GEN",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "X-GEN PHARMACEUTICALS, INC", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("ZYDUS",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "ZYDUS PHARMACEUTICALS", drugs$LABELER.NAME)
drugs$LABELER.NAME <- ifelse(grepl("ZIMMER",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE, "ZIMMER BIOMET, INC/SEIKAGAKU CORP", drugs$LABELER.NAME)

# abbvie <- drugs[grepl("X-GEN",drugs$LABELER.NAME, ignore.case = TRUE) == TRUE,]

drugs <- unique(drugs)

write.csv(drugs[,c(2:14)], "U://Medicaid_Drug/manufacturers_drugs_cleaned.csv")













