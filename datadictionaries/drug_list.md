# Drug List (FDA Approved drugs by date and therapeutic indication)

## Data files ([available at data.world](https://data.world/data4democracy/drug-spending))

* JSON: `drug_list.json`

## Link(s) to code used for scraping, tidying, etc, if applicable:

* `NA`

## Data types
* **string**: a sequence of characters


## Field listing
|Name                |Type    |Description|
|--------------------|--------|-----------|
|name                |string  |Drug name, often formatted "brand (generic/nonproprietary)." |
|approval_status     |string  |Date approved (month and year). Most rows start with "Approved", although not all. |
|company             |string  |Drug maker/distributor |
|specific_treatment  |string  |Therapeutic area of drug. Most descriptions mention a specific disease. |


## Important notes

Data source: http://www.centerwatch.com/drug-information/fda-approved-drugs/therapeutic-areas

Dataset contains information on FDA-approved drugs, date approved, company that produces/distributes the drug, and therapeutic use of drug.

### To do to improve this dataset:
* Could be useful to re-scrape/collect the data again to get the broad categories for the drugs as seen on the website (Cardiology/Vascular Diseases, Dental and Oral Health, Dermatology, etc)
* Split the name column into two columns: brand name and the generic/nonproprietary name
* Clean up the approval_status column (maybe split into two) and turn date approved into its own separate column
* Need some kind of text analysis to turn the specific_treatment into usable categories. For example, as the data is right now, HIV drugs are described in a number of ways, including (but not limited to): "AIDS, HIV Infection", "AIDS/HIV infection", "HIV", "HIV infection", etc. and they can all be broadly categorized as "HIV" or "HIV/AIDS"
