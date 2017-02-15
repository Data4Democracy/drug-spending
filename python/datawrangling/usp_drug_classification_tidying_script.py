#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Parse and tidy the USP Drug Classification data from KEGG
Raw data from http://www.genome.jp/kegg-bin/get_htext?htext=br08302.keg

Created on Sun Feb  5 13:15:04 2017

@author: claire
"""
import requests # download data from data.world
import os # check that file exists
import numpy as np, pandas as pd # data tidying 

def download_from_url(url, out_file):
    """     Download the raw USP Drug Classification data from data.world """

    resp = requests.get(url)
    resp.raise_for_status()

    with open(out_file, 'wb') as f:
        for block in resp.iter_content(1024):
            f.write(block)

    return None

def tidy_usp_dc_from_kegg(fname, fout):
    """
    Read the raw USP Drug Classification file, parse and tidy
    the data into a dataframe, and write tidy data to file.

    Parameters
    ----------
    fname : string
        Raw data file name, i.e. br08302.keg

    fout : string
        File to write tidy data to, i.e. usp_drug_classification.csv
    """

    # Check that the raw data exists.
    assert(os.path.isfile(fname))

    with open(fname, 'r') as f:
        all_lines = f.readlines()
        
    usp = []
    for line in all_lines:
        # Data is hierarchically structured: a USP_Category comes first on a
        # line that starts with 'A'. All subsequent non-'A' lines belong to that
        # category.
        if line.startswith('A'):
            current_category = line.strip()[1:]
        # Lines with USP Classes start with 'B'. All subsequent non-'B' lines
        # belong to that class.
        elif line.startswith('B'):
            current_class = line[1:].strip()
        elif line.startswith('C'):
            # Sometimes the drug has a KEGG ID after it, like
            # "C<drug> [DG:DG12345]". But drugs sometimes have spaces
            # in them, so we can't just split on white space.
            current_drug = line[1:].split('[')[0].strip()
            try:
                current_drug_id = line[1:].split(':')[1].strip(']\n')
            except:
                current_drug_id = np.nan
        elif line.startswith('D'):
            line = line[1:].strip()
            # The KEGG ID is the first 6 characters (after the 'D')
            example_drug_id = line[0:6]
            # The drug name is after the KEGG ID and before parentheses (if any)
            example_drug_name = line[6:].strip().split('(')[0].strip()
            # Some drug names are followed by the nomenclature, in parentheses
            if line.endswith(')'):
                nomenclature = '(' + line.split('(')[-1]
            else:
                nomenclature = np.nan
            # Add each drug example to our tidy data
            usp.append([current_category, current_class, current_drug,
                        current_drug_id, example_drug_name,
                        example_drug_id, nomenclature])
    
    uspdf = pd.DataFrame(usp, columns=['usp_category', 'usp_class', 'usp_drug',
                                     'kegg_id_drug', 'drug_example',
                                     'kegg_id_drug_example', 'nomenclature'])
    uspdf.to_csv('usp_drug_classification.csv', index=False)

    return None

if __name__ == "__main__":
    # data.world download link for br08302.keg
    url = 'https://query.data.world/s/5jd8dr323erk97yhr2zrr5coe'
    keg_file = 'br08302.keg'
    csv_file = 'usp_drug_classification.csv'

    # Download the data from data.world
    download_from_url(url, keg_file)

    # Read and tidy the data
    tidy_usp_dc_from_kegg(keg_file, csv_file)
