# Medicare Drug Manufacturer Data

## Data files ([available at data.world](https://data.world/data4democracy/drug-spending))
* CSV: `drugdata_clean.csv`

## Data types
* **string**: a sequence of characters
* **integer**: whole numbers
* **decimal**: fractional numbers
* **date**: MM/DD/YYYY 


## Field listing
|Name                           |Type   |Description|
|-------------------------------|-------|-----------|
|HCPCS.CODE                     |integer|Healthcare Common Procedure Coding System code for the item, if any|
|NDC                            |string |National Drug Code for the item, if any. Typically xxxxx-xxxx-xx (dashes are included).|
|LABELER.NAME                   |string |Cleaned name of the company that manufactures/sells the drug|
|DRUG.NAME                      |string |Brand name for the drug, if any. May include generic name if no brand.|
|SHORT.DESCRIPTION              |string |Generic name for the drug, plus sometimes details about the manufacture or use.|
|HCPCS.DOSAGE                   |string |Description of the dosage of the drug assigned to a particular HCPCS code. Numeric and units together.|
|DOSAGENUM                      |decimal|Numeric value isolated from HCPCS.DOSAGE.|
|DOSAGEUNITS                    |string |Units isolated from HCPCS.DOSAGE.|
|PKG.SIZE                       |decimal|Amount in one item/package.  (ex.,  For a product that is 100mcg/0.5 ml in one vial, the package size would be 0.5.) |
|PKG.QTY                        |integer|Number of items in the NDC (ex., For an NDC that is 4 vials in a shelf pack, the package quantity would be 4.)|
|BILLUNITS                      |decimal|the number of billable units per NDC (ex., 20 billable units in each item multiplied by 4 vials in the NDC shelf pack (aka the package quantity) = 80 billable units per NDC.)|
|BILLUNITSPKG                   |decimal|the number of billable units per package (ex., 100 mcg in a package divided by 5 mcg in the dosage descriptor = 20 billable units per package.)|
|ASOFDATE                       |date   |Start date for the record's effective period. Records included here are effective either 1/1/2017-3/31/2017, or 1/1/2016-3/31/2016.|

## Important notes

### Data provenance
Drug information comes from Medicare's own documentation of manufacturers and packaging/coding of drugs and biologicals. Original page: https://www.cms.gov/Medicare/Medicare-Fee-for-Service-Part-B-Drugs/McrPartBDrugAvgSalesPrice/2016ASPFiles.html

Records were compiled from the NDC-HCPCS crosswalks available in .csv format on the above website. The documentation is meant to be used for appropriate medical billing coding, so that the correct coding can be applied to drugs or biologicals being billed to Medicare. Some records may seem very similar, but have different codes- this is usually due to different packaging, where different sizes or doses are packaged separately.

None of the dose or unit information should be interpreted as judgment of the appropriate amount of a drug or biological for any particular patient, this is strictly classification related to billing.

### Data sources and calculation methods
Manufacturer names have been formatted to be as consistent as possible. When subsidiaries were listed alongside parent companies, the name of the parent company has been retained, as this is more useful for lobbying or financial contribution analysis.

Note from the original source documentation: "Effective January 1, 2005, Medicare will base payment for a Part B drug on 106% of the Average Sales Price (ASP) of the drug as reported quarterly to the Centers for Medicare and Medicaid Services (CMS) by manufacturers. Manufacturers submit ASP data at the 11-digit National Drug Code (NDC) level. Providers mostly use Healthcare Common Procedure Coding System (HCPCS) codes to bill Medicare for drugs and biologicals."

### Excluded data
This dataset only includes records effective 1/1/2017-3/31/2017, or 1/1/2016-3/31/2016. Medicare provides quarterly updates to this data, so more (although not necessarily different) data is available at the above linked page going back to approximately 2006.
