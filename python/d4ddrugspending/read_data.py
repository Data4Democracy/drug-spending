import requests # to download the dataset
import zipfile # to extract from archive
import shutil # to write the dataset to file
import os # rename file to something more type-able
import argparse # argument parsing for command line options

import pandas as pd
import numpy as np

import feather

# custom exception for undefined option
class OptionUndefinedError(Exception):
    def __init__(self, expression):
        print("Option for output file format not recognized!")


def _download_data(url, data_dir="../data/", data_name="dataset", zipped_data=False):
    """
    Helper function to download the data from a given URL into a 
    directory to be specified. If it's a zip file, unzip.

    Parameters
    ----------
    url : string
        String with the URL from where to download the data

    data_dir : string, optional, default: "../data/"
        Path to the directory where to store the new data

    zipped_data: bool, optional, default: False
        Is the file we download a zip file? If True, unzip it.
    """

    # figure out if data directory exists
    # if not, create it!
    try:
        os.stat(data_dir)
    except FileNotFoundError:
        os.mkdir(data_dir)

    # open a connection to the URL
    response = requests.get(url, stream=True)

    # store file to disk
    with open(data_dir + data_name, 'wb') as ds_zipout:
        shutil.copyfileobj(response.raw, ds_zipout)

    # if it's a zip file, then unzip:   
    if zipped_data:
        zip = zipfile.ZipFile(data_dir + data_name, 'r')

        # get list of file names in zip file:
        ds_filenames = zip.namelist()
        # loop through file names and extract each
        for f in ds_filenames:
            zip.extract(f, path=data_dir)

    return 


def download_partd(data_dir="../data/", output_format="feather"):
    """
    Download the Medicare Part D expenditure data from the CMS website.
    This function will dowload the data, load the original Excel file into 
    a pandas DataFrame and do some data wrangling and cleaning. 

    The end result are a file with drug names (both generic and brand) as well 
    as one file per year with the actual data. The file type of the output files 
    is determined by the `output_format` keyword argument.

    Parameters
    ----------
    data_dir : string
       The path to the directory where the data should be stored.

    output_format : string, optional, default: "feather"
       The file format for the output file. Currently supported data formats are:
            * "cvs": return comma-separated values in a simple ASCII file
            * "feather": return a `.feather` file (required `feather` Python package!)

    """


    # URL for the CMS Part D data 
    url = 'https://www.cms.gov/Research-Statistics-Data-and-Systems/'+ \
          'Statistics-Trends-and-Reports/Information-on-Prescription-Drugs/'+ \
          'Downloads/Part_D_All_Drugs_2015.zip'
   
    # download data from CMS:
    _download_data(url, data_dir=data_dir, data_name="part_d.zip", zipped_data=True)
     
    # data is in a form of an Excel sheet (because of course it is)
    # we need to make sure we read the right work sheet (i.e. the one with the data):
    xls = pd.ExcelFile(data_dir + "Medicare_Drug_Spending_PartD_All_Drugs_YTD_2015_12_06_2016.xlsx")
    partd = xls.parse('Data', skiprows=3)
    partd.index = np.arange(1, len(partd) + 1)

    # First part: get out the drug names (generic + brand) and store them to a file

    # Capture only the drug names (we'll need this later)
    partd_drugnames = partd.iloc[:, :2]
    partd_drugnames.columns = ['drugname_brand', 'drugname_generic']

    # Strip extraneous whitespace from drug names
    partd_drugnames.loc[:, 'drugname_brand'] = partd_drugnames.loc[:, 'drugname_brand'].map(lambda x: x.strip())
    partd_drugnames.loc[:, 'drugname_generic'] = partd_drugnames.loc[:, 'drugname_generic'].map(lambda x: x.strip())
 
    # make all drugnames lowercase:
    partd_drugnames["drugname_generic"] = partd_drugnames["drugname_generic"].str.lower()
    partd_drugnames["drugname_brand"] = partd_drugnames["drugname_brand"].str.lower()


    if output_format == "csv":
        # get all the column names for the file header
        hdr = list(partd_drugnames.columns)
        # add a `#` to the first element of the list so header 
        # won't be confused for data
        hdr[0] = "#" + hdr[0]
        partd_drugnames.to_csv(data_dir + "drugnames.csv", sep="\t", header=hdr,
                               index=False) 
    elif output_format == "feather":
        # write the results to a feather file:
        feather.write_dataframe(partd_drugnames, data_dir + 'drugnames.feather')
    else:
        raise OptionUndefinedError()

    # Separate column groups by year
    cols_by_year = [
        { 'year': 2011, 'start': 2, 'end': 12 },
        { 'year': 2012, 'start': 12, 'end': 22 },
        { 'year': 2013, 'start': 22, 'end': 32 },
        { 'year': 2014, 'start': 32, 'end': 42 },
        { 'year': 2015, 'start': 42, 'end': 53 },
    ]

    partd_years = {}

    col_brandname = 0
    col_genericname = 1
    for cols in cols_by_year:
        year, start, end = cols['year'], cols['start'], cols['end']

        partd_years[year] = pd.concat([partd_drugnames,
                                       partd.iloc[:, start:end]],
                                      axis=1)

    # Remove 2015's extra column for "Annual Change in Average Cost Per Unit" (we can calculate it, anyhow)
    partd_years[2015] = partd_years[2015].drop(partd_years[2015].columns[-1], axis=1)

    # Drop any rows in each year that have absolutely no data, then reset their row indices
    for year in partd_years:
        nonnull_rows = partd_years[year].iloc[:, 2:].apply(lambda x: x.notnull().any(), axis=1)
        partd_years[year] = partd_years[year][nonnull_rows]
        partd_years[year].index = np.arange(1, len(partd_years[year]) + 1) 

    # Make columns easier to type and more generic w.r.t. year
    generic_columns = [
        "drugname_brand",
        "drugname_generic",
        "claim_count",
        "total_spending",
        "user_count",
        "total_spending_per_user",
        "unit_count",
        "unit_cost_wavg",
        "user_count_non_lowincome",
        "out_of_pocket_avg_non_lowincome",
        "user_count_lowincome",
        "out_of_pocket_avg_lowincome"
    ]

    for year in partd_years:
        partd_years[year].columns = generic_columns

    # Cast all column data to appropriate numeric types

    # Suppress SettingWithCopyWarnings because I think it's
    # tripping on the fact that we have a dict of DataFrames
    pd.options.mode.chained_assignment = None
    for year in partd_years:
        # Ignore the first two columns, which are strings and contain drug names
        for col in partd_years[year].columns[2:]:
            partd_years[year].loc[:, col] = pd.to_numeric(partd_years[year][col])
    pd.options.mode.chained_assignment = 'warn'


    if output_format == "csv":
        for year in partd_years:
            hdr = list(partd_years[year].columns)
            hdr[0] = "#" + hdr[0]
            partd_years[year].to_csv(data_dir + "spending-" + str(year) + ".csv", sep="\t", header=hdr,      
                                     index=False)
    elif output_format == "feather":
        # Serialize data for each year to feather file for use in both Python and R
        for year in partd_years:
            feather.write_dataframe(partd_years[year], data_dir + 'spending-' + str(year) + '.feather')

    else:
        raise OptionUndefinedError()

    return

def download_puf(data_dir="../data/", all_columns=True , output_format="feather"):
    """
    Download the CMS prescription drug profiles.
    This function will dowload the data, load the original CSV file into 
    a pandas DataFrame and do some data wrangling and cleaning. 

    The end result will be a feather file with the prescription drug
    profiles.

    Parameters
    ----------
    data_dir : string
       The path to the directory where the data should be stored.

    all_columns : bool, optional, default: True
       If True, store all columns in a feather file.
       If False, only store the columns with RXCUI ID, drug major class 
       and drug class

    output_format : string, optional, default: "feather"
       The file format for the output file. Currently supported data formats are:
            * "cvs": return comma-separated values in a simple ASCII file
            * "feather": return a `.feather` file (required `feather` Python package!)
        
    """
    url = "https://www.cms.gov/Research-Statistics-Data-and-Systems/"+\
          "Statistics-Trends-and-Reports/BSAPUFS/Downloads/2010_PD_Profiles_PUF.zip"

    
    # download data from CMS:
    _download_data(url, data_dir=data_dir, data_name="puf.zip", zipped_data=True)

    # read CSV into DataFrame
    puf = pd.read_csv(data_dir + "2010_PD_Profiles_PUF.csv")

    # if we don't want to save all columns, drop those except for the three columns 
    # we're interested in.
    if not all_columns:
        puf.drop(["BENE_SEX_IDENT_CD", "BENE_AGE_CAT_CD", "PDE_DRUG_TYPE_CD", "PLAN_TYPE", 
                 "COVERAGE_TYPE", "benefit_phase","DRUG_BENEFIT_TYPE",
                 "PRESCRIBER_TYPE", "GAP_COVERAGE", "TIER_ID", "MEAN_RXHCC_SCORE",
                 "AVE_DAYS_SUPPLY", "AVE_TOT_DRUG_COST", "AVE_PTNT_PAY_AMT",
                 "PDE_CNT", "BENE_CNT_CAT"], axis=1, inplace=True)

    if output_format == "csv":
        # get all the column names for the file header
        hdr = list(puf.columns)
        # add a `#` to the first element of the list so header 
        # won't be confused for data
        hdr[0] = "#" + hdr[0]
        puf.to_csv(data_dir + "puf.csv", sep="\t", header=hdr,
                               index=False)
    elif output_format == "feather":
        # write the results to a feather file:
        feather.write_dataframe(puf, data_dir + 'puf.feather')
    else:
        raise OptionUndefinedError()

    return 

def download_rxnorm(data_dir="../data/", output_format="feather"):
    """
    Download RxNorm data for *currently prescribable* drugs. The RxNorm data 
    describes a standard identifier for drugs, along with commonly used names, 
    ingredients and relationships. The full data set is very large and requires a  
    special licence. Here, we use the subset of drugs that can currently be 
    prescribed, which are available without licence. We are also going to ignore 
    the relational data and focus on commonly used identifiers and the RxNorm ID.

    Parameters
    ----------
    data_dir : string
       The path to the directory where the data should be stored.

    output_format : string, optional, default: "feather"
       The file format for the output file. Currently supported data formats are:
            * "cvs": return comma-separated values in a simple ASCII file
            * "feather": return a `.feather` file (required `feather` Python package!)

    """
    # URL to the data file
    url = "https://download.nlm.nih.gov/rxnorm/RxNorm_full_prescribe_01032017.zip"

    # download data from NIH:
    _download_data(url, data_dir=data_dir, data_name="rxnorm.zip", zipped_data=True)


    # Column names as copied from the NIH website
    names = ["RXCUI", "LAT", "TS", "LUI", "STT", "SUI", "ISPREF", "RXAUI",
         "SAUI", "SCUI", "SDUI", "SAB", "TTY", "CODE", "STR", "SRL", "SUPPRESS", "CVF"]

    # we only want column 0 (the RXCUI identifier) and 14 (the commonly used name)
    rxnorm = pd.read_csv(data_dir + "rrf/RXNCONSO.RRF", sep="|", names=names, index_col=False,
                         usecols=[0,14])
 
    # make all strings lowercase
    rxnorm["STR"] = rxnorm["STR"].str.lower()

    if output_format == "csv":
        # get all the column names for the file header
        hdr = list(rxnorm.columns)
        # add a `#` to the first element of the list so header 
        # won't be confused for data
        hdr[0] = "#" + hdr[0]
        rxnorm.to_csv(data_dir + "rxnorm.csv", sep="\t", header=hdr,
                               index=False)
    elif output_format == "feather":
        # write the results to a feather file:
        feather.write_dataframe(rxnorm, data_dir + 'rxnorm.feather')
    else:
        raise OptionUndefinedError()

    return

def download_drug_class_ids(data_dir="../data/", output_format="feather"):
    """
    Download the table associating major and minor classes with alphanumeric codes.
    This data originates in the VA's National Drug File, but also exists in more accessible 
    for in the SAS files related to the CMS PUF files.

    Parameters
    ----------
    data_dir : string
       The path to the directory where the data should be stored.

    output_format : string, optional, default: "feather"
       The file format for the output file. Currently supported data formats are:
            * "cvs": return comma-separated values in a simple ASCII file
            * "feather": return a `.feather` file (required `feather` Python package!)
    """

    url = "https://www.cms.gov/Research-Statistics-Data-and-Systems/" + \
          "Statistics-Trends-and-Reports/BSAPUFS/Downloads/2010_PD_Profiles_PUF_DUG.zip"
    
    # download data from CMS:
    _download_data(url, data_dir=data_dir, data_name="drug_classes_dataset.zip", zipped_data=True)

    # read drug major classes
    drug_major_class = pd.read_csv(data_dir+"DRUG_MAJOR_CLASS_TABLE.csv")
 
    # read drug minor classes
    drug_class = pd.read_csv(data_dir+"DRUG_CLASS_TABLE.csv")

    # replace NaN values in drug_class table
    drug_class.replace(to_replace=np.nan, value="N/A", inplace=True)

    if output_format == "csv":
        # get all the column names for the file header
        hdr_dmc = list(drug_major_class.columns)
        hdr_dc = list(drug_class.columns)
        # add a `#` to the first element of the list so header 
        # won't be confused for data
        hdr_dmc[0] = "#" + hdr_dmc[0]
        hdr_dc[0] = "#" + hdr_dc[0]

        drug_major_class.to_csv(data_dir + "drug_major_class.csv", sep="\t", header=hdr_dmc,
                               index=False)
        drug_class.to_csv(data_dir + "drug_class.csv", sep="\t", header=hdr_dc,
                          index=False)

    elif output_format == "feather":
        # write the results to a feather file:
        feather.write_dataframe(drug_major_class, data_dir + 'drug_major_class.feather')
        feather.write_dataframe(drug_class, data_dir + 'drug_class.feather')
    else:
        raise OptionUndefinedError()

    return


def make_drug_table(data_dir="../data/", data_local=True, file_format="feather"):
    """ 
    Make a table that associates:
        * drug brand name
        * drug generic name
        * drug RxNorm RXCUI Identifier
        * drug major class
        * drug minor class

    If the data doesn't exist locally, it will be downloaded.
    The output is a feather file called `drugnames_withclasses.feather`.

    Parameters
    ----------
    data_dir : string, optional, default: "../data/"
        The directory that contains the data as .feather files.

    data_local : bool, optional, default: True
        If True, code assumes that the data exists locally. If this is not 
        the case, the function will exit with an error. If False, data will  
        be downloaded to the directory specified in `data_dir`. 

    file_format : string, optional, default: "feather"
       The file format for the input files. If `data_local=False`, also the file format for the 
       output files. Currently supported data formats are:
            * "cvs": return comma-separated values in a simple ASCII file
            * "feather": return a `.feather` file (required `feather` Python package!)

    """ 
    # if data_local is False, download all the necessary data
    if not data_local:
        download_partd(data_dir, output_format=file_format)
        download_puf(data_dir, all_columns=False, output_format=file_format)
        download_rxnorm(data_dir, output_format=file_format)
        download_drug_class_ids(data_dir, output_format=file_format)

    # assert that data directory and all necessary files exist.
    assert os.path.isdir(data_dir), "Data directory does not exist!"
    assert (os.path.isfile(data_dir+"drugnames.feather") | os.path.isfile(data_dir+"drugnames.csv")), \
            "Drugnames file does not exist!"
    assert (os.path.isfile(data_dir+"puf.feather") | os.path.isfile(data_dir+"puf.csv")), \
            "Prescription drug profile data file does not exist!"
    assert (os.path.isfile(data_dir+"rxnorm.feather") | os.path.isfile(data_dir+"rxnorm.csv")), \
            "RxNorm data file does not exist!"
    assert (os.path.isfile(data_dir+"drug_major_class.feather") | os.path.isfile(data_dir+"drug_major_class.csv")), \
            "Drug major class file does not exist."
    assert (os.path.isfile(data_dir+"drug_class.feather") | os.path.isfile(data_dir+"drug_class.csv")), \
            "Drug class file does not exist."

    if file_format == "feather":
        # load data files from disk
        drugnames = feather.read_dataframe(data_dir + "drugnames.feather")
        puf = feather.read_dataframe(data_dir + "puf.feather")
        rxnorm = feather.read_dataframe(data_dir + "rxnorm.feather")
        drug_major_class = feather.read_dataframe(data_dir + "drug_major_class.feather")
        drug_class = feather.read_dataframe(data_dir + "drug_class.feather")

    elif file_format == "csv":
        drugnames = pd.read_csv(data_dir + "drugnames.csv", sep="\t", header=0)
        drugnames.columns = drugnames.columns.str.strip("#")

        puf = pd.read_csv(data_dir + "puf.csv", sep="\t", header=0)
        puf.columns = puf.columns.str.strip("#")

        rxnorm = pd.read_csv(data_dir + "rxnorm.csv", sep="\t", header=0)
        rxnorm.columns = rxnorm.columns.str.strip("#")
      
        drug_major_class = pd.read_csv(data_dir + "drug_major_class.csv", sep="\t", header=0)
        drug_major_class.columns = drug_major_class.columns.str.strip("#")

        drug_class = pd.read_csv(data_dir + "drug_class.csv", sep="\t", header=0)
        drug_class.columns = drug_class.columns.str.strip("#")
        drug_class.drug_class = drug_class.drug_class.astype(str)
        drug_class.drug_class_desc = drug_class.drug_class_desc.astype(str)
 
    else:
        raise OptionUndefinedError()

    drugnames["RXCUI"] = "0.0"    

    # associate drug names with RXCUI codes
    # NOTE: THIS IS A BIT HACKY! 
 
    # loop over indices in list of drug names
    for idx in drugnames.index:

        # sometimes, we might have more than one RXCUI 
        # associated with a drug, because the names can 
        # be a bit ambivalent, so make a list
        rxcui = []

        # we are going to look for RXCUI codes for both the 
        # generic name of the drug and the brand name of the drug
        # because sometimes one might be associated and the other
        # one isn't
        for c in ["drugname_generic", "drugname_brand"]:

            # get out the correct row in the table
            d = drugnames.loc[idx, c]
            # sometimes a drug has two names, split by a slash
            # we are going to try and find RXCUI codes for both
            dsplit = d.split("/")

            # loop over drug names
            for di in dsplit:
                # sometimes, a drug has a suffix attached to it
                # since this doesn't usually exist in the RxNorm table,
                # we strip anything after a free space
                displit = di.split(" ")
                v = rxnorm[rxnorm["STR"] == displit[0]]

                # include all unique RXCUI codes in the list
                if len(v) > 0:
                    rxcui.extend(v["RXCUI"].unique())
                else:
                    continue

        # if there are more than one RXCUI identifier for a drug,
        # make a string containing all codes, separated by a '|'
        if len(rxcui) > 1:
            rxcui_str = "|".join(np.array(rxcui, dtype=str))

        elif len(rxcui) == 1:
            rxcui_str = str(rxcui[0])
        else:
            # if there is no RXCUI code associated, include a 0
            rxcui_str = '0.0'

        # associate string with RXCUI codes with the correct row
        drugnames.loc[idx, "RXCUI"] = rxcui_str

    # number of drugs that I can't find RXCUI codes for:
    n_missing = len(drugnames[drugnames["RXCUI"] == '0.0'])
 
    print("A fraction of %.2f drugs has no RxNorm entry that I can find."%(n_missing/len(drugnames)))

    # add empty columns for drug classes and associated strings
    drugnames["drug_major_class"] = ""
    drugnames["dmc_string"] = ""
    drugnames["drug_class"] = ""
    drugnames["dc_string"] = ""

    # make sure RXCUI codes are all strings:
    drugnames["RXCUI"] = drugnames["RXCUI"].astype(str)

    # loop over drug names again
    for idx in drugnames.index:

        # get out the RxCUI codes for this entry
        drug_rxcui = drugnames.loc[idx, "RXCUI"].split("|")
        
        # the same way that one drug may have multiple RXCUI codes,
        # it may also have multiple classes, so make an empty list for them
        dmc, dc = [], []

        # if there are multiple RXCUIs, we'll need to loop over them:
        for rxcui in drug_rxcui:
            # find the right entry in the prescription drug profile data for 
            # this RXCUI
            r = puf[puf["RXNORM_RXCUI"] == np.float(rxcui)]

            # there will be duplicates, so let's pick only the set of unique IDs
            rxc = r.loc[r.index, "RXNORM_RXCUI"].unique()

            # add drug classes for this RXCUI to list
            dmc.extend(r.loc[r.index, "DRUG_MAJOR_CLASS"].unique())
            dc.extend(r.loc[r.index, "DRUG_CLASS"].unique())

        # multiple RXCUIs might have the same class, and we only care
        # about unique entires
        dmc = np.unique(dmc)
        dc = np.unique(dc)

        # if there is at least one drug class associated with the drug, 
        # make a string of all associated drug classes separated by `|`
        # and store in correct row and column
        if len(dmc) != 0:
            drugnames.loc[idx, "drug_major_class"] = "|".join(dmc)
            dmc_name = np.hstack([drug_major_class.loc[drug_major_class["drug_major_class"] == d, 
                                                       "drug_major_class_desc"].values for d in dmc])
            drugnames.loc[idx, "dmc_name"] = "|".join(dmc_name)

        # if there is no class associated, this entry will be zero
        else:
            drugnames.loc[idx, "drug_major_class"] = "0"
            drugnames.loc[idx, "dmc_name"] = "0"

        # same procedure as if-statement just above
        if len(dc) != 0:
            drugnames.loc[idx, "drug_class"] = "|".join(dc)
            dc_name = np.hstack([drug_class.loc[drug_class["drug_class"] == d, 
                                                "drug_class_desc"].values for d in dc])   

            drugnames.loc[idx, "dc_name"] = "|".join(dc_name)
        else:
            drugnames.loc[idx, "drug_class"] = "0"
            drugnames.loc[idx, "dc_name"] = "0"


    if file_format == "csv":
        # get all the column names for the file header
        hdr = list(drugnames.columns)
        # add a `#` to the first element of the list so header 
        # won't be confused for data
        hdr[0] = "#" + hdr[0]
        drugnames.to_csv(data_dir + "drugnames_withclasses.csv", sep="\t", header=hdr,
                               index=False)
    elif file_format == "feather":
        # write the results to a feather file:
        feather.write_dataframe(drugnames, data_dir + 'drugnames_withclasses.feather')
    else:
        raise OptionUndefinedError()

    return


# if script is called from the command, line, code below is executed.
if __name__ == "__main__":

    # make an argument parser object to parse command line arguments
    parser = argparse.ArgumentParser(description="Download and wrangle Medicare drug use data.")

    # define possible command line arguments
    parser.add_argument("-d", "--data-dir", action="store", required=False, default="../data/",
                        dest="data_dir", help="Optional path to the data directory where data is " +
                                              "stored/retrieved. Default: '../data/'")
    parser.add_argument("-f", "--output-format", action="store", required=False, default="feather",
                        dest="output_format", help="File format for output files. {'csv' | 'feather'}")

    parser.add_argument("-a", "--download-all", action="store_true", dest="dl_all",
                        help="If this flag is set, download all data sets")
    parser.add_argument("--download-partd", action="store_true", dest="dl_partd",
                        help="If this flag is set, download Medicare Part D data set.")
    parser.add_argument("--download-rxnorm", action="store_true", dest="dl_rxnorm",
                        help="If this flag is set, download RxNorm data.")
    parser.add_argument("--download-puf", action="store_true", dest="dl_puf",
                        help="If this flag is set, download prescription drug profile data.")
    parser.add_argument("--download-drug-classes", action="store_true", dest="dl_drugclass",
                        help="If this flag is set, download drug class ID tables for PUF data.")
    parser.add_argument("--make-drug-table", action="store_true", dest="make_dtable",
                        help="If this flag is set, make a table associating drug names in "+  
                             "the Part D data with RxNorm IDs and drug classes from the PUF data.")
 
    # parse arguments
    clargs = parser.parse_args()

    if clargs.dl_all:
        print("You have chosen to download all data.")
        print("Downloading Medicare Part D data ...")
        download_partd(clargs.data_dir, output_format=clargs.output_format)
        print("Downloading Prescription Drug Profile data ...")
        download_puf(clargs.data_dir, all_columns=True, output_format=clargs.output_format)
        print("Downloading RxNorm data ...")
        download_rxnorm(clargs.data_dir, output_format=clargs.output_format)
        print("Download drug class IDs ...")
        download_drug_class_ids(clargs.data_dir, output_format=clargs.output_format)
        print("All done!")
    elif clargs.dl_partd:
        download_partd(clargs.data_dir, output_format=clargs.output_format)
    elif clargs.dl_rxnorm:
        download_rxnorm(clargs.data_dir, output_format=clargs.output_format)
    elif clargs.dl_puf:
        download_puf(clargs.data_dir, all_columns=True, output_format=clargs.output_format)
    elif clargs.dl_drugclass:
        download_drug_class_ids(clargs.data_dir, output_format=clargs.output_format)
    else:
        print("No data to be downloaded.")

    if clargs.make_dtable:
        print("Combining data sets to associate drug names with IDs and classes ...")
        make_drug_table(clargs.data_dir, data_local=True, file_format=clargs.output_format)

