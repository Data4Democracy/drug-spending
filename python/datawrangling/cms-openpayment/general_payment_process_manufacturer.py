"""
This script attempts to create a canonical name for the names of the manufacturers 
and GPOs. The script first checks whether the mapping between ID and name/state/country
information is consistent, then converts the names into a canonical form and outputs
a csv containing this information.

Inconsistency in raw data can be handled by specifying a yaml file as the dict 
parameter. This yaml file should contain a sequence of dictionaries, each dictionary
containing at least the id key. Information in this file is written directly to the 
output csv. 

Dictionary file content example:
- id: 100000000178
  name: ZOLL LIFECOR CORPORATION
  state: PA
  country: United States

Usage:
python general_payment_process_manufacturer.py input.csv output.csv --dict dict.yml

author: sangxia
"""

import pandas as pd
from unidecode import unidecode
import numpy as np
import csv
import argparse
import yaml
import re
import copy

def name_simplify(s, compare=False):
    """
    Simplify string s. If compare is True, then the simplification is used for deciding
    whether two names are the same, and in this case, all non-alphanumerics will be dropped.
    Otherwise, only duplicate whitespaces will be removed.
    """
    ret = unidecode(s).upper()
    if compare:
        ret = re.sub(' |[^A-Z0-9]', '', ret)
    else:
        ret = re.sub('  +', ' ', ret)
    return str.upper(ret.strip())

def process_manufacturers(infile, outfile,name_dict):
    df = pd.read_csv(infile)
    colid = 'Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID' 
    colname = 'Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name'
    colstate = 'Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State'
    colcountry = 'Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country'
    colcomp = 'Name_compare'  # column of normalized names for comparison, to be created
    df = df.loc[~df[colid].isin(name_dict)].drop_duplicates()   # only process ids not in name_dict, drop duplicate rows for faster processing
    print('Checking null values')  # the only field that can have nan is the State field
    for c in df.columns:
        if c != colstate:
            assert(df[c].isnull().sum()==0)
    print('Computing names for comparison')
    df[colcomp] = df[colname].apply(name_simplify, compare=True)
    df = df[[colid,colname,colstate,colcountry,colcomp]]
    for c in [colname,colstate,colcountry]:
        df.loc[df[c].notnull(),c] = df.loc[df[c].notnull(),c].apply(name_simplify, compare=False)
    # We first create a temporary dataframe used for checking consistency. We use
    # colcomp for comparing names, so we drop colname.
    df_tmp = df.drop(colname,axis=1).drop_duplicates()  
    print('Checking ID consistency')
    dup = pd.pivot_table(df_tmp,index=colid,values=colstate, aggfunc=len)
    dup = dup[dup>1]
    if dup.shape[0]>0:
        print(df_tmp[df_tmp[colid].isin(dup.index)].sort_values(colid))
        assert(False)
    print('Checking whether name has unique ID')
    dup = pd.pivot_table(df_tmp, index=colcomp, values=colid, aggfunc=len)
    dup = dup[dup>1]
    if dup.shape[0]>0:
        print('WARNING:')
        print(df_tmp[df_tmp[colcomp].isin(dup.index)].sort_values(colcomp))
    print('All checks OK')
    # We now collect all entries in a dict for output
    out_dict = {}
    for k,v in name_dict.items():
        out_dict[k] = copy.copy(v)
    for r in df.itertuples():
        if r[1] in out_dict:
            if len(r[2])<len(out_dict[r[1]]['NAME']):
                print(r[1], 'replacing {0} with {1}'.format(out_dict[r[1]]['NAME'],r[2]))
            else:
                continue
        out_dict[r[1]] = { \
                'NAME': r[2], \
                'STATE': r[3] if isinstance(r[3],str) else '', \
                'COUNTRY': r[4] if isinstance(r[4],str) else '', \
                }
    print('Writing')
    out_list = []
    for k,v in out_dict.items():
        x = {}
        x['ID'] = k
        for c in ['NAME','STATE','COUNTRY']:
            x[c] = v[c]
        out_list.append(x)
    with open(outfile,'w') as f:
        csvout = csv.DictWriter(f,['ID','NAME','STATE','COUNTRY'])
        csvout.writeheader()
        for x in out_list:
            csvout.writerow(x)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('infile', \
            help='name of input csv file containing manufacturer information')
    parser.add_argument('outfile', \
            help='name of output csv file of normalized manufacturer name information')
    parser.add_argument('--dict', default=None, help='yaml file specifying names for some manufacturers')
    arg = vars(parser.parse_args())
    infile = arg['infile']
    outfile = arg['outfile']
    name_dict = {}
    if arg['dict']:
        with open(arg['dict']) as f:
            name_list = yaml.load(f.read())
        for x in name_list:
            i = x.pop('id')
            name_dict[i] = { \
                    'NAME': name_simplify(x['name']), \
                    'STATE': name_simplify(x['state']) if 'state' in x else '', \
                    'COUNTRY': name_simplify(x['country']) if 'country' in x else '', \
                    }
        print(name_dict)
    process_manufacturers(infile, outfile, name_dict)

