# Pharma Lobby and Lobbying Keyed

## Data files ([available at data.world](https://data.world/data4democracy/drug-spending))
* CSV: `Pharma_Lobby.csv`
* CSV (modified): `lobbying_keyed.csv`

## Link(s) to code used for scraping, tidying, etc, if applicable:

* `NA`

## Data types
* **string**: a sequence of characters
* **integer**: whole numbers
* **money**: fractional numbers representing currency
* **date**: string formatted YYYY

## Field listing
#### `Pharma_Lobby.csv`
|Name      |Type    |Description|
|----------|--------|-----------|
|column_a  |integer |Row number |
|client    |string  |Client/Parent. Person/Entity that employed or retained lobbying services |
|sub       |string  |Subsidiary/Affiliate. Any entity other than the client that contributed over $5,000 toward lobbying activities and actively participated in the lobbying process. For most sub will be the same as client (this value was missing in the original dataset, but the original uploader seems to have copied over the client name if the sub was missing) |
|total     |money   |Total amount of money spent on lobbying that year |
|year      |date    |Year for which information is contained in that row |
|catcode   |string  |Code that denotes industry and/or sector (see links) |

#### `lobbying_keyed.csv`
|Name      |Type    |Description|
|-------------|--------|-----------|
|column_a     |integer |Row number (different from column_a in `Pharma_Lobby.csv`) |
|client       |string  |Client/Parent. Person/Entity that employed or retained lobbying services |
|x            |integer |column_a value from `Pharma_Lobby.csv` |
|sub          |string  |Subsidiary/Affiliate. Any entity other than the client that contributed over $5,000 toward lobbying activities and actively participated in the lobbying process. For most sub will be the same as client (this value was missing in the original dataset, but the original uploader seems to have copied over the client name if the sub was missing) |
|total        |money   |Total amount of money spent on lobbying that year |
|year         |date    |Year for which information is contained in that row |
|catcode      |string  |Code that denotes industry and/or sector (see links) |
|company_key  |integer |Unique value representing the company (likely for client company) |


## Important notes
These datasets contain information on yearly lobbying by pharmaceutical groups over the years. `lobbying_keyed.csv` was an attempt to clean the `Pharma_Lobby.csv` file, but the two files contain essentially the same information.

#### To do to clean up this data:
* Remove column_a in both files, remove x in the lobbying_keyed file
* Replace the sub value with `NA` if the Subsidiary/Affiliate was missing in the original dataset (instead of inserting client value)
* Convert the client and sub columns to all lowercase 
* Update with new lobbying information


#### Useful links:
* Dataset source: https://www.opensecrets.org/lobby/indusclient.php?id=h04&year=2016
* Definitions of lobbying terms: https://lobbyingdisclosure.house.gov/amended_lda_guide.html
* Catcode reference: https://www.opensecrets.org/downloads/crp/CRP_Categories.txt
* OpenSecrets.org Resource center: https://www.opensecrets.org/resources/dollarocracy/
