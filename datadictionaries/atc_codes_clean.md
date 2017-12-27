# ATC Codes (Clean) (Anatomical The4rapeutic Chemical Classification System)

## Data files ([available at data.world](https://data.world/data4democracy/drug-spending))

* Raw KEG file: `br08303.keg`
* Tidied CSV (intermediate): `atc-codes.csv`
* CSV: `atc_codes_clean.csv`

## Link(s) to code used for scraping, tidying, etc.:

* original source: http://www.genome.jp/kegg-bin/get_htext?br08303.keg
* `atc_codes_cleanup.rmd`

## Data types
* **string**: a sequence of characters

## Field listing
|Name         |Type    |Description|
|-------------|--------|-----------|
|level5_code  |string  |Fifth level full classification code (should be unique to each drug)|
|field5       |string  |Generic drug name/active ingredient|
|kegg         |string  |KEGG drug name for some compounds and KEGG Drug ID|
|level1_code  |string  |First level classification code|
|level1       |string  |First level ATC classification - Main anatomical group|
|level2_code  |string  |Second level classification code|
|level2       |string  |Second level ATC classification - Therapeutic subgroup|
|level3_code  |string  |Third level classification code|
|level3       |string  |Third level ATC classification - Therapeutic/pharmacological subgroup|
|level4_code  |string  |Fourth level classification code|
|level4       |string  |Fourth level ATC classification - Chemical/therapeutic/pharmacological subgroup|


## Important notes

### General Information:

This dataset contains Anatomical Therapeutic Chemical (ATC) Classification System codes for therapeutic compounds. This code system is a method by which the World Health Organization (WHO) classifies the active ingredients of drugs based on where in the body they act and their method of action, drug target, and/or chemical properties. It is not a therapeutic classification per se, and it may not provide information on what disease a drug is used for. However, this dataset may be useful in combination with other data sources for linking drugs to therapeutic uses.

The classification system is a funnel type of classification, with the broadest category assigned at the First Level (where in the body the drug acts), and is more specific with each tier. The Fifth Level code should be specific for each chemical compound, altough some compounds may have multiple classifications.

### Sources to better understand the ATC classification system:

* Wikipedia: https://en.wikipedia.org/wiki/Anatomical_Therapeutic_Chemical_Classification_System
* WHO portal: http://apps.who.int/medicinedocs/en/d/Js4876e/6.2.html
* WHO Collaborating Centre: https://www.whocc.no/atc_ddd_index/