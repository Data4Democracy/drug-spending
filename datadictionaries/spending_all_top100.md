# Medicare Part D Spending, Top 100 Drugs

## Data files ([available at data.world](https://data.world/data4democracy/drug-spending))

* CSV: `spending_all_top100.csv`

## Link(s) to code used for scraping, tidying, etc.:

* `drug-spending/R/apps/shinydashboard-medicared/combine_data.R`

## Data types
* **string**: a sequence of characters
* **integer**: whole numbers
* **decimal**: fractional numbers
* **money**: fractional numbers representing currency
* **year**; year date 

## Field listing
|Name                           |Type   |Description|
|-------------------------------|-------|-----------|
|drugname_brand                 |string |Brand name of the drug|
|drugname_generic               |string |Generic / nonproprietary name of the drug |
|claim_count                    |integer|Number of Medicare Part D Prescription Drug Events (PDEs); includes original prescriptions and refills|
|total_spending                 |money  |Aggregate drug spending for the Part D program (inc. Medicare, plan, and beneficiary payments)|
|user_count                     |integer|Number of Medicare Part D beneficiaries utilizing the drug|
|total_spending_per_user        |money  |`total_spending` / `user_count`|
|unit_count                     |decimal|Total dosage units of medication dispensed (e.g., number of tablets, grams, milliliters, etc.)|
|unit_cost_wavg                 |money  |`total_spending` / `unit_count`; for drugs with multiple strengths, dosage forms, etc., this is a claim-weighted average unit cost|
|user_count_non_lowincome       |integer|Number of beneficiaries using the drug who do not qualify for a low-income subsidy|
|out_of_pocket_avg_non_lowincome|money  |Average amount that beneficiaries **without** a low-income subsidy paid out-of-pocket|
|user_count_lowincome           |integer|Number of beneficiaries using the drug who do qualify for a low-income subsidy|
|out_of_pocket_avg_lowincome    |money  |Average amount that beneficiaries **with** a low-income subsidy paid out-of-pocket|
|year                           |year   |Which year the data in this row is for|

## Important notes

### General Medicare Spending Notes:

#### Data provenance
Drug information comes from Part D Prescription Drug Event (PDE) data and is available for a subset (~70%) of Medicare beneficiaries.

PDE records were summarized by drug by linking National Drug Codes (NDCs), which are available in the PDE data, to the First Databank MedKnowledge database and aggregating by brand name and generic name.

#### Data sources and calculation methods
Spending amounts are calculated based on the gross drug cost, which represents total spending for the prescription claim, including Medicare, plan, and beneficiary payments.

Data from all Part D organization and plan types were included in the analysis.

Data were aggregated across all strengths, dosage forms, and routes of administration.

#### Excluded data
Over-the-counter drugs are excluded from this data set.

To protect the privacy of Medicare beneficiaries, all drug records derived from 10 or fewer claims -- as well as records that can be used to calculate such data -- are also excluded.

### How the drugs in this dataset were selected: 
The data from the spending csv files for 2011-2015 was combined into one dataset, the drugs were grouped by year and by generic/nonpreprietary name, and then the most commonly perscribed drugs (by total users across all years) were selected. The `spending_all_top100.csv` file contains Medicare Part D spending information for these drugs.

#### Important Notes:
* Just because these drugs were selected by their generic name, does not mean that they are generics
* There may be multiple rows for the same drug for the same year under different brand names