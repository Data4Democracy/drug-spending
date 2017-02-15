# Data Dictionary Template; Insert Dataset Name Here

## Data files ([available at data.world](https://data.world/data4democracy/drug-spending))
* Format 1: `filename.format1`
* Format 2: `filename.format2`

## Link(s) to code used for scraping, tidying, etc, if applicable:

These should also be stored in this folder.

* `thisdata_scrapy_script.py`
* `thisdata_tidying_script.R`

## Data types
* **string**: a sequence of characters
* **integer**: whole numbers
* **decimal**: fractional numbers
* **money**: fractional numbers representing currency
* **date**: string formatted YYYY-MM-DD

## Field listing
|Name     |Type    |Description|
|---------|--------|-----------|
|field_1  |string  |Maybe this is a drug brand name|
|field_2  |integer |Maybe this is the number of prescriptions written for that drug|
|field_3  |money   |This could be the average cost of each prescription|
|field_4  |date    |And this could be the first date the drug was approved|
|field_5  |decimal |This could be the number of units for the drug|

## Important notes

As much information as we know about the dataset, we should put here, in subsections if that would help organization. Ideas:

- Detailed information about the data source
- Population: who/what specifically it involves or excludes
- How it was calculated or aggregated
- Any other information we have - thorough is better
