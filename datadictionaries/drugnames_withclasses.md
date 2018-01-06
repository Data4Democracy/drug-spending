# Drug names with classes

## Data files ([available at data.world](https://data.world/data4democracy/drug-spending))
* Format 1: `drugnames_withclasses.csv`
* Format 2: `drugnames_withclasses.feather`

## Link(s) to code used for scraping, tidying, etc, if applicable:
[Scraping and tidying script](https://github.com/Data4Democracy/drug-spending/blob/master/python/notebooks/druguse_definitions.ipynb)

## Data types
* **string**: a sequence of characters
* **integer**: whole numbers

## Field listing
|Name              |Type    |Description|
|------------------|--------|-----------|
|drugname_brand    |string  |Brand or trade name of the drug |
|drugname_generic  |string  |Generic or nonproprietary name of the drug (seems to contain specific formulation information such as type and amount of active ingredient) |
|rxnorm_rxcui      |integer |Numeric identifiers including missing/unknown. Each represents  a unique drug name which is separately provided |
|drug_major_class  |string  |This is a set of 30 possible alpha-numeric  codes including missing/unknown. It indicates the major class of the drug, such as  cardiovascular medications and central nervous system medications |
|dmc_name          |string  |String description of `drug_major_class` (seems mainly unknown/missing or NA) |
|drug_class        |string  |This is a set of 263 possible alpha-numeric (two-letter plus  three-digit) codes. It indicates the class of the drug, such as antidepressants and  analgesics |
|dc_name           |string  |String description of `drug_class` |

## Important notes

**Data provenance**
Drug information comes from Part D Prescription Drug Event (PDE) data and is available for a subset (~70%) of Medicare beneficiaries.
Unique drug identifiers and classes were from CMS 2010 Medicare Prescription Drug Profiles Public Use Files which represents 100% of prescription drug claims.

**Data calculation methods**

TODO:
- Add information on how drugnames were mapped to RXCUI
- Add how major class and class were matched to their description 


### Note:
This is an older dataset / dictionary that needs to be verified