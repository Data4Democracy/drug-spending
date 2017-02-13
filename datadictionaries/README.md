## Data Central: How to Contribute, Sources, and Data Dictionaries

As our work continues to expand, this will be a central repository to document summaries, sources,
and field names for all our data sets. Data is housed in our [repo on data.world](https://data.world/data4democracy/drug-spending).

### How Do I Contribute Data?

---

We're glad you asked!

If you have a data source that would help with our [objectives](../docs/objectives.md),
we'd be grateful to have it. Here's an overview of how to most effectively contribute. Please join
the discussion on our [Slack channel](https://datafordemocracy.slack.com/messages/drug-spending/) -
our group would love to work with you. (If you're not already in the Data for Democracy Slack team,
you'll need an invitation - more info [here](https://github.com/Data4Democracy/read-this-first).)

1. [Tidy the data](https://en.wikipedia.org/wiki/Tidy_data), using `lower_snake_case` for variable
and file names and ISO format (YYYY-MM-DD) for dates. Also keep in mind these [best practices](https://docs.google.com/document/d/1p5A2DQ5gFC7XVKNVDw_ifKnycv_j1udmqY1M0rjbcxo/edit) from data.world. We prefer CSV format; [feather](http://blog.cloudera.com/blog/2016/03/feather-a-fast-on-disk-format-for-data-frames-for-r-and-python-powered-by-apache-arrow/) format is also very useful (feel free to add both).
1. Fork this repo and request to be a [contributor to our dataset on data.world](https://data.world/data4democracy/drug-spending/contributors), if you haven't already.
1. Submit a pull request to this repo including the following:
    * In either [`python/datawrangling`](../python/datawrangling) or [`R/datawrangling`](../R/datawrangling), as appropriate, add any script(s) you used to scrape, tidy, etc. (If you have multiple scripts, feel free to create a subdirectory.) Be specific when you name the scripts and directories - eg, `scrape_druglist_from_genomejp.py` is better than `drugscraping.py`.
    * In `/datadictionaries`, add a data dictionary for your data source named `[datasource].md`. We have a [data dictionary template](TEMPLATE.md); for more specifics, check out the other dictionaries available in this folder.
    * Edit this README with a short overview of your dataset.
1. Once the PR is reviewed by our maintainers and merged, upload your final data set to data.world and label it "clean data" (click on Edit). Add a link to the data dictionary in the Description field. *(If you'd rather not join data.world, a maintainer can do this as well. It's a fun place, though!)*
    - If you'd like to add the raw data as well (eg, XLSX files), feel free; make sure to label it "raw data."
    - Bonus points: Edit the info for each field in your data.world dataset with a detailed description.
1. Submit a PR to update this overview file (this can be done by you or maintainers).
1. Receive our grateful thanks, likely including emoji.

### Overview of Currently Available Datasets

All datasets are available in our [repo on data.world](https://data.world/data4democracy/drug-spending). If individual datasets can be queried, direct links are included.

---

#### 1. [Medicare Part D Spending Data, 2011-2015](https://data.world/data4democracy/drug-spending/query/?query=--+Medicare_Drug_Spending_PartD_All_Drugs_YTD_2015_12_06_2016.xlsx%2FMethods+%28Medicare_Drug_Spending_PartD_All_Drugs_YTD_2015_12_06_2016.xlsx%29%0ASELECT+%2A+FROM+%60Medicare_Drug_Spending_PartD_All_Drugs_YTD_2015_12_06_2016.xlsx%2FMethods%60)

###### Formats: XLSX (original); CSV, feather (tidied)
###### Original Source: US Centers for Medicare and Medicaid Services ([CMS.gov](https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Information-on-Prescription-Drugs/Downloads/Part_D_All_Drugs_2015.zip))

This is the data that initially inspired our project.

The Excel file contains aggregate data for total and average spending by Medicare and by consumers,
as well as total and average number of claims, for each brand name drug by year. Generic names are
also included.

In our data.world repo, the original file has been tidied and split into one dataset per year,
available in both .csv and .feather format; these are titled, for example, `spending-2011.feather`.
We also have a `feather` file containing solely the unique brand names + generic names included in
all five years of data (`drugnames.feather`).

Links to full data dictionaries:
[2011](part-d_spending_2011.md)
[2012](part-d_spending_2012.md)
[2013](part-d_spending_2013.md)
[2014](part-d_spending_2014.md)
[2015](part-d_spending_2015.md)

---

#### 2. [ATC Codes](https://data.world/data4democracy/drug-spending/query/?query=--+atc-codes.csv%2Fatc-codes+%28atc-codes.csv%29%0ASELECT+%2A+FROM+%60atc-codes.csv%2Fatc-codes%60+LIMIT+5000)

###### Formats: KEG (original); CSV (tidied)
###### Original Source: www.genome.jp

The [Anatomical Therapeutic Chemical Classification System](https://en.wikipedia.org/wiki/Anatomical_Therapeutic_Chemical_Classification_System), maintained by the WHO, is used to classify drugs based on both the organ or system on which they act and their therapeutic, pharmacological and chemical properties. Procuring the codes from WHO is prohibitively expensive; our dataset is scraped from www.genome.jp.

Link to full data dictionary [in progress]

---

#### 3. FDA-Approved Drugs

###### Formats: JSON
###### Original Source: [Center Watch](http://www.centerwatch.com/drug-information/fda-approved-drugs/therapeutic-areas)

This dataset contains a list of FDA-approved drugs, their approval date, manufacturer, and specific
purpose.

---

#### 4. [Drug Uses](https://data.world/data4democracy/drug-spending/query/?query=--+drug_uses.csv%2Fdrug_uses+%28drug_uses.csv%29%0ASELECT+%2A+FROM+%60drug_uses.csv%2Fdrug_uses%60+LIMIT+5000)

###### Formats: CSV, feather
###### Original Source: n/a

This is a first pass at a crosswalk between the ATC codes and Medicare Part D spending data. Work to
finalize this is welcome!

Link to full data dictionary [in progress]

---

#### 5. [Cleaned manufacturer data](https://data.world/data4democracy/drug-spending/query/?query=--+drugdata_clean.csv%2Fdrugdata_clean+%28drugdata_clean.csv%29%0ASELECT+%2A+FROM+%60drugdata_clean.csv%2Fdrugdata_clean%60+LIMIT+5000)

###### Formats: CSV
###### Original Source: CMS.gov

This dataset contains the information you'd need to link specific drugs and their dosages to the manufacturer - helpful for creating a path from Medicaid spending to lobbying efforts. Brand name and generic or descriptive names are both offered, as well as dosage and package size. Further, there are identifying codes for each drug (HCPCS and NDC).

---

#### 6. Medical Expenditure Panel Survey *(too large for direct query link)*

###### Formats: zip, CSV, feather
###### Original Source: meps.ahrq.gov

I'll need Alex to write this one, and/or I'll look at it later.

Link to full data dictionary [in progress]

---

#### 7. [Pharmaceutical Lobbying Transactions](https://data.world/data4democracy/drug-spending/query/?query=--+Pharma_Lobby.csv%2FPharma_Lobby+%28Pharma_Lobby.csv%29%0ASELECT+%2A+FROM+%60Pharma_Lobby.csv%2FPharma_Lobby%60+LIMIT+5000)

###### Formats: CSV
###### Original Source: [OpenSecrets](https://www.opensecrets.org/lobby/indusclient.php?id=h04&year=2016)

OpenSecrets has data on lobbying transactions from pharmaceutical companies and their subsidiaries, totaled by year.

Link to full data dictionary [in progress]
