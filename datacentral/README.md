## Data Central: How to Contribute, Sources, and Data Dictionaries

As our work continues to expand, this will be a central repository to document summaries, sources,
and field names for all our data sets. Data is housed in our [repo on data.world](https://data.world/data4democracy/drug-spending).

### How Do I Contribute Data?

---

We're glad you asked!

If you have a data source that would help with our objectives [need md version of goals statement],
we'd be grateful to have it. Here's an overview of how to most effectively contribute. Please join
the discussion on our [Slack channel](https://datafordemocracy.slack.com/messages/drug-spending/) -
our group would love to work with you. (If you're not already in the Data for Democracy Slack team,
you'll need an invitation - more info [here](https://github.com/Data4Democracy/read-this-first).)

1. [Tidy the data](https://en.wikipedia.org/wiki/Tidy_data), using `lower_snake_case` for variable
and file names.
1. Submit a pull request to this repo with a file containing a data dictionary for your data source
named `[datasource]_dictionary.md`; it'll be reviewed by our maintainers. We have a data dictionary
template here [need to create a template], or you can look at our other dictionary files for
inspiration.
1. Once the PR is merged, become a contributor to our
[repo at data.world](https://data.world/data4democracy/drug-spending) if you haven't already, then
upload your final data set.
1. Edit the info for each field in your data.world dataset with a detailed description. This will help other users *tremendously*.
1. Submit a PR to update this overview file (this can be done by contributors or maintainers).
1. Receive our grateful thanks.

### Overview of Currently Available Datasets

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

Link to full data dictionary [need link - Matt will cover this]

---

#### 2. [ATC Codes](https://data.world/data4democracy/drug-spending/query/?query=--+atc-codes.csv%2Fatc-codes+%28atc-codes.csv%29%0ASELECT+%2A+FROM+%60atc-codes.csv%2Fatc-codes%60+LIMIT+5000)

###### Formats: KEG (original); CSV (tidied)
###### Original Source: www.genome.jp

The [Anatomical Therapeutic Chemical Classification System](https://en.wikipedia.org/wiki/Anatomical_Therapeutic_Chemical_Classification_System), maintained by the WHO, is used to classify drugs based on both the organ or system on which they act and their therapeutic, pharmacological and chemical properties. Procuring the codes from WHO is prohibitively expensive; our dataset is scraped from www.genome.jp.

Link to full data dictionary [in progress]

---

#### 3. FDA-Approved Drugs (can't get DW query link to go anywhere? will check in on this later)

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

#### 5. [Cleaned drug data](https://data.world/data4democracy/drug-spending/query/?query=--+drugdata_clean.csv%2Fdrugdata_clean+%28drugdata_clean.csv%29%0ASELECT+%2A+FROM+%60drugdata_clean.csv%2Fdrugdata_clean%60+LIMIT+5000)

###### Formats: CSV
###### Original Source: CMS.gov

I'll need Stephanie to write this one!

---

#### 6. Medical Expenditure Panel Survey *(too large to query; stored on DW)*

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
