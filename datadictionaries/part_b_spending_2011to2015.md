# Medicare Part B Spending (2011-2015)

## Data files ([available at data.world](https://data.world/data4democracy/drug-spending))
* XLSX (original): `Medicare_Drug_Spending_PartB_All_Drugs_YTD_2015_12_06_2016.xlsx`
* CSV (tidy): `spending_part_b_2011to2015_tidy.csv`

## Link(s) to code used for scraping, tidying, etc, if applicable:

* `/drug-spending/R/datawrangling/spending_part_b_cleanup.R`

## Data types
* **string**: a sequence of characters
* **integer**: whole numbers
* **decimal**: fractional numbers
* **money**: fractional numbers representing currency
* **date**: date formatted YYYY

## Field listing (for the `spending_part_b_2011to2015_tidy.csv` version)
|Name                                    |Type    |Description|
|----------------------------------------|--------|-----------|
|hcpcs_code                              |string  |Healthcare Common Procedure Coding System (HCPCS) code for the drug |
|hcpcs_description                       |string  |HCPCS Description of the drug (drug name, as well as dose and administration method for some) |
|year                                    |date    |Year of data for the row |
|claim_count                             |integer |Number of Medicare Part B claims |
|total_spending                          |money   |Aggregate drug spending for the Part B program |
|beneficiary_count                       |integer |Number of Medicare Part B fee-for-service beneficiaries utilizing the drug |
|total_annual_spending_per_user          |money   |Total Spending divided by the number of unique beneficiaries utilizing the drug (Beneficiary Count) during the benefit year |
|unit_count                              |decimal |Total dosage units of medication billed during the calendar year (e.g. number of tablets, grams, milliliters or other units) |
|average_cost_per_unit                   |money   |Total Spending divided by the number of dosage units |
|average_beneficiary_cost_share          |money   |Average amount that beneficiaries using the drug paid out of pocket during the year |
|annual_change_in_average_cost_per_unit  |decimal |Annual change in average cost per unit reflects the percent change in average cost per unit. (Was calculated only between 2014-2015 in the original data) |

## Important notes

Original data source: https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Information-on-Prescription-Drugs/2015MedicareData.html

### Data Source and Summarization: 
(Source: `Medicare_Drug_Spending_PartB_All_Drugs_YTD_2015_12_06_2016.xlsx`) 

Medicare Part B claims (e.g. physician and other suppliers, durable medical equipment and other supplies, hospital outpatient data) contain information on drugs administered and billed directly by providers. Analyses of Part B drugs are possible for all Part B fee-for-service Medicare beneficiaries, but exclude any beneficiaries in the Medicare Advantage program (~30%). Drug spending metrics for Part B drugs are based on total spending, which is derived from summing the three revenue center payment fields on the claim referring to Medicare payment, deductible, and coinsurance. This represents the full value of the product, including the Medicare payment and beneficiary liability.

Part B claims were summarized by Healthcare Common Procedure Coding System (HCPCS) codes and limited to HCPCS codes listed in in the publicly available Medicare Average Sales Price (ASP) quarterly files at any point in the prior 5 years. In addition to the HCPCS listed in the ASP drug lists, oral anti-cancer drugs identified by HCPCS beginning with 'WW' were included. Part B claims were excluded if Medicare was not the primary payer or if the drugs were billed using "Not Otherwise Classified" (NOC) codes (e.g. J3490, J3590, or J9999), since identification of NOC drugs are not specified on the claim. In addition, Part B institutional claims submitted by critical access hospitals (CAHs), Maryland hospitals, as well as claims with total spending amounts of zero associated with the drug, which is due to bundling in Ambulatory Payment Classification groups, were excluded.

Claims data were averaged across any applicable modifiers or place of service indicators associated with a single HCPCS. Drugs with multiple strengths (e.g. 20mg, 40mg, 80mg) were not combined when individual HCPCS codes exist for different strengths (e.g., methylprednisolone has different HCPCS codes for 20mg, 40mg, and 80mg). 

Difference between drugs covered under Medicare Part B vs Part D: https://www.cigna.com/medicare/understanding-medicare/part-d-part-b

In general, Part B covers drugs that are administered in a hospital/clinical/medical setting, most likely because they are injected (which must be done by a doctor) or administered through an IV infusion.

#### To do for this data:
* The `hcpcs_description` column contains a lot of information and likely needs to be broken up for therapeutic matching
* Need to understand how the variables in the Part B spending dataset may relate to the variables in the Part D dataset
