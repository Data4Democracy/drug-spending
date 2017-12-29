# USP Drug Classifications

## Data files ([available at data.world](https://data.world/data4democracy/drug-spending))
* Raw text: `br08302.keg`
* Tidy CSV: `usp_drug_classification.csv`

## Link(s) to code used for scraping, tidying, etc, if applicable:

Data was directly downloaded from [KEGG](http://www.genome.jp/kegg-bin/get_htext?htext=br08302.keg), 
(click on `Download htext` in the upper left-hand corner) no scraping needed.

* Tidying script: `usp_drug_classification_tidying_script.py`

## Data types
* **string**: a sequence of characters

## Field listing
|Name                 |Type    |Description                                                      |
|---------------------|--------|-----------------------------------------------------------------|
|usp_category         |string  |USP Category (broad therapeutic category)                        |
|usp_class            |string  |USP Class (more specific drug class)                             |
|usp_drug             |string  |Active drug ingredient / general drug                            |
|kegg_id_drug         |string  |The KEGG identifier for the `usp_drug` (e.g. DG00245)            |
|drug_example         |string  |Drug formulation (should be identical if same active ingredient) |
|kegg_id_drug_example |string  |The KEGG identifier for the `drug_example` (e.g. D01122)         |
|nomenclature         |string  |(Unparsed) nomenclature description (e.g. `'(JP17/USP/INN)'`)    |

## Important notes

### Background
From the US Pharmacopeial Convention's [website](http://www.usp.org/usp-healthcare-professionals/usp-drug-classification-system): 
the USP Drug Classification system (USP DC) is an independent drug classification system currently 
under development by the USP Healthcare Quality Expert Committee.  The USP DC is designed to address 
stakeholder needs emerging from the extended use of the USP Medicare Model Guidelines (USP MMG) 
beyond the Medicare Part D benefit.

The USP DC is intended to be complementary to the USP MMG and is developed with similar guiding principles, 
taxonomy, and structure of the [USP Categories and Classes](http://www.usp.org/sites/default/files/usp_pdf/EN/healthcareProfessionals/2016_usp_mmg_guiding_principles.pdf).

### Raw data

The raw data was downloaded from the KEGG website: http://www.genome.jp/kegg-bin/get_htext?htext=br08302.keg

`br08302.keg` is a text file with the hierarchical USP drug classifications. Lines beginning with `A` are
USP Categories, subsequent lines beginning with `B` are USP Classes in that category, lines beginning
with `C` are the `drugs` (i.e. the general drug compound), and lines beginning with `D` are `example_drugs`
(i.e. the medication or formulation you would buy) of that drug.

### Interpreting the fields

According to the [guidelines](http://www.usp.org/sites/default/files/usp_pdf/EN/healthcareProfessionals/2016_usp_mmg_guiding_pri\
nciples.pdf), 
a **USP Category** is the broadest classification which provides a high level formulary 
structure designed to include all potential therapeutic agents for diseases and conditions.
A **USP Class** is a more granular classification, occurring within a specific USP Category in the USP 
Drug Classifications, which provides for therapeutic or pharmacologic groupings of FDA approved medications, 
consistent with current U.S. healthcare practices and standards of care.

From what I understand, the **nomenclature** string indicates to which official nomenclature system
that name belongs to. For example, "a [British Approved Name (BAN)](https://en.wikipedia.org/wiki/British_Approved_Name) 
is the official non-proprietary or generic name given to a pharmaceutical substance, as defined in the 
British Pharmacopoeia (BP)" whereas "[United States Adopted Names](https://en.wikipedia.org/wiki/United_States_Adopted_Name) 
are unique nonproprietary names assigned to pharmaceuticals marketed in the United States."

I'm not sure of the best way to store this information (or how useful it will be), so for now the
nomunclature strings are in the tidy data unparsed.

### Other notes

- *TBD whether this data includes medications covered by Part D Medicare or if it is only complementary to that data.*

- Note that the individual KEGG pages (e.g. [D00903](http://www.genome.jp/dbget-bin/www_bget?dr:D00903)) 
for these drugs have a wealth of information, including product and generic names, chemical formula, 
additional classes, ATC codes, biochemical information, other classifications, and links to the compound 
in other databases (e.g. PubChem, DrugBank, etc).

