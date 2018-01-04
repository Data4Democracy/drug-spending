# FDA's National Drug Code Directory

## Data files ([available at data.world](https://data.world/data4democracy/drug-spending))
* CSV: `FDA_NDC_Product.csv`

## Link(s) to code used for scraping, tidying, etc, if applicable:

* `NA`

## Data types
* **string**: a sequence of characters
* **integer**: whole numbers


## Field listing
|Name                       |Type     |Description|
|---------------------------|---------|-----------|
|productid                  |string   |ID unique to the product, starts with the 8 or 9 digit productndc identifier |
|productndc                 |string   |Unique 8 or 9 digit, 2-segment number in the forms 4-4, 5-3, or 5-4, that is a universal product identifier in the United States. First segment represents the labeler, second segment represents the product. Dosage is embedded in the second NDC code segment and the same drug may have multiple NDC codes if it is available at a number of doses. Missing is the third segment that is needed for a full NDC code, which represents the package code (see link under other resources) |
|producttypename            |string   |Product type (prescription, over the counter, vaccine, etc) |
|proprietaryname            |string   |Brand name or trade name of the drug under which it's marketed, chosen by the manufacturer |
|proprietarynamesuffix      |string   |Add-on to propriety name, may have info about route of administration or dose |
|nonproprietaryname         |string   |Active ingredient(s) and/or nonproprietary name(s), likely similar to substancename column. May contain multiple compounds separated by `,` (or possibly another symbol), if the drug has multiple active ingredients |
|dosageformname             |string   |What form the drug is administered in (capsule, tablet, injection, etc) |
|routename                  |string   |What route the drug is administered by (oral, intravenous, topical, etc) |
|startmarketingdate         |integer  |When the drug was first marketed (column needs to be transformed into date format) |
|endmarketingdate           |integer  |The expiration date of the last lot distributed. Actively marketed drugs will not have a marketing end date (column needs to be transformed into date format) |
|marketingcategoryname      |string   |What FDA application type the drug is marketed under (see link under other resources) |
|applicationnumber          |string   |FDA application number |
|labelername                |string   |Manufacturer, repackager, or distributor |
|substancename              |string   |Active ingredient(s) and/or nonproprietary name(s), likely similar to nonproprietaryname column. May contain multiple compounds separated by `;` (or possibly another symbol), if the drug has multiple active ingredients |
|active_numerator_strength  |string   |Amount of active ingredient in the drug. May contain several values separated by `;` (or possibly another symbol), if the drug has multiple active ingredients |
|active_ingred_unit         |string   |The units that the amount of active ingredient is measured in. May contain several unit values, separated by `;` (or possibly another symbol), if the drug has multiple active ingredients |
|pharm_class                |string   |Pharmacological class - information on the drug's mechanism of action and/or drug target. Basically, info on how the drug does what it does |
|deaschedule                |string   |The Drug Enforcement Administration (DEA) schedule applicable to the drug as reported by the labeler |


## Important notes
This dataset was created as part of The Drug Listing Act of 1972, which requires drug manufacturers/distributors to provide a full list of currently marketed drugs. The information is submitted by the labeler (manufacturer, repackager, or distributor) to the FDA. It seems that inclusion in the NDC directory does not mean that the drug is FDA approved. The dataset includes information about active ingredients in a drug and their dosing, who produces the drug, and the pharmacological mechanism by which it acts.

#### Excluded from this dataset:
* Animal drugs
* Blood products
* Human drugs not in their final marketed form (as in no standalone active ingredients if they're not marketed)
* Drugs for further processing 
* Drug manufactured exclusively for a private label distributor (not commercially available)
* Drugs that are marketed exclusively as part of a kit or combination or some other part of a multi-level packaged product


#### Dataset source:
* Organization: Food and Drug Administration
* URL to dataset and more info: https://www.fda.gov/Drugs/InformationOnDrugs/ucm142438.htm

#### Other Resources related to this dataset:
* Explanation of NDC Code info: https://www.drugs.com/ndc.html
* More information on FDA labeling: https://www.fda.gov/ForIndustry/DataStandards/StructuredProductLabeling/default.htm
* FDA Marketing Category Name acronym explanation: https://www.fda.gov/Drugs/DevelopmentApprovalProcess/FormsSubmissionRequirements/ElectronicSubmissions/DataStandardsManualmonographs/ucm071826.htm
* FDA Listing and Registration instructions (more info on columns in the dataset): https://www.fda.gov/Drugs/GuidanceComplianceRegulatoryInformation/DrugRegistrationandListing/ucm078801.htm
* DEA website for (deaschedule column info): https://www.deadiversion.usdoj.gov/schedules/index.html
