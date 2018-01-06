# Drug Uses

## Data files ([available at data.world](https://data.world/data4democracy/drug-spending))
* CSV: `drug_uses.csv`

## Link(s) to code used for scraping, tidying, etc, if applicable:

* `NA`

## Data types
* **string**: a sequence of characters
* **integer**: whole numbers


## Field listing
|Name              |Type    |Description|
|------------------|--------|-----------|
|column_a          |integer |Row number |
|drugname_brand    |string  |Drug brand or trade name |
|drugname_generic  |string  |Drug generic name and/or name of active ingredient |
|anatomical        |string  |Where in the body the drug acts (skin, nervous system, etc.). This column seems to be a match for the First Level of the ATC Classification System (see `atc_codes_clean.csv` and the related dictionary) |
|therapeutic       |string  |Second Level of the ATC Classification System (see `atc_codes_clean.csv` and the related dictionary) |
|pharmacologic     |string  |Third Level of the ATC Classification System (see `atc_codes_clean.csv` and the related dictionary) |
|chemical          |string  |Fourth Level of the ATC Classification System (see `atc_codes_clean.csv` and the related dictionary) |
|substance         |string  |Drug generic name and/or name of active ingredient (likely same as drugname_generic column) |
|name              |string  |Specific active ingredient formulation (ie the type of salt such as chloride, fluoride, sodium succinate and so on) |

## Important notes

Appears to be drugs with brand names and generic/nonpropriety names, matched to their ATC classification (see `atc_codes_clean.csv` and the corresponding data dictionary). Also includes specific main ingredient formulation.

#### Need:
Source for this data
