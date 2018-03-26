##THIS SCRIPT WAS WRITTEN FOR PYTHON 2.7, I HAVE NO IDEA HOW IT WILL WORK FOR 3.6

import numpy as np
import pandas as pd
import xml.etree.ElementTree as ET
import csv
import datadotworld as dw

##LOAD UP XML AND PULL OUT ALL NAMES AND SYNONYMS (KIND OF A RELATIONAL "PROJECTION" ONTO NAME AND SYNONYMS - JUST LEARNED ABOUT RELATIONAL ALGEBRA; SO COOL!)
doc = ET.parse('drugbank.xml')
root = doc.getroot()
ns = {'db':'http://www.drugbank.ca' , 'xsi':'http://www.w3.org/2001/XMLSchema-instance'}

synonyms = []
for child in root:
    for syn in child.find('db:synonyms',ns):
        synonyms.append( syn.text.lower() )

drugbank_names = set( [ child.find('db:name', ns).text.lower() for child in root ] + synonyms ) 

##LOAD UP CSV AND SET UP WRITER FOR SEMIJOIN AND ANTIJOIN CSV
drug_spending = dw.load_dataset('data4democracy/drug-spending')
part_d_spending = drug_spending.dataframes['spending_part_d_2011to2015_tidy']

semijoin_file = open('part_d_drugbank_semijoin.csv','w')
antijoin_file = open('part_d_drugbank_antijoin.csv','w')

semijoin_writer = csv.writer(semijoin_file)
antijoin_writer = csv.writer(antijoin_file)

semijoin_writer.writerow( list( part_d_spending.columns.values ) )
antijoin_writer.writerow( list( part_d_spending.columns.values ) )


##CHECK EACH ROW IN CSV FOR MATCH AGAINST DRUGBANK NAMES, WRITE TO CSV ACCORDINGLY
for i in range(0 , part_d_spending.shape[0]):
    row = part_d_spending.iloc[i]

    brand = row.brand_name
    generic = row.generic_name
    write_row = row.values.tolist()
    
    match = brand in drugbank_names or generic in drugbank_names

    if match:
        semijoin_writer.writerow( write_row )

    else:
        antijoin_writer.writerow( write_row )
        
##CLOSE NEW FILES - WE'RE DONE HERE
semijoin_file.close()
antijoin_file.close()

#!!!-------------------------------------CRUFT - READ AHEAD AT OWN PERIL--------------------------------------------!!!#
#match_names = [ name for name in part_d_names if name in drugbank_names ] 
#
#column_heads = ['name', 'drugbank-id', 'ahfs_codes', 'atc-code', 'products', 'class']
#writer.writerow(column_heads)
#
#
#match_file = open('part_d_drugbank_matches.csv','w')
#writer = csv.writer(match_file)
#column_heads = ['name', 'drugbank-id', 'ahfs_codes', 'atc-code', 'products', 'class']
#writer.writerow(column_heads)
#
#for drug in root:
#    name = drug.find('db:name', ns).text.lower()
#    syn = set([s.text.lower() for s in drug.find('db:synonyms',ns)])
#
#    name_match = name in match_names
#    syn_match = any([ s in match_names for s in syn ])
#
#    if (name_match or syn_match):
#        print name
#        
#        db_id = drug.find('db:drugbank-id', ns).text.lower()
#
#        ahfs = drug.find('db:ahfs-codes',ns)
#        print(len(ahfs))
#        if ( len(ahfs) > 0 or type(ahfs) == type(None) ):
#            ahfs = ahfs[0].text.lower()
#
#            if ahfs == '\n      ':
#                ahfs = 'NA'
#
#
#        else:
#            ahfs = 'NA'
#
#        atc = drug.find('db:atc-codes',ns).text
##        if ( len(atc) > 0 or type(atc) == type(None) ):
##            atc = atc[0].text.lower()
##            
##            if atc == '\n      ':
##                atc= 'NA'
##
##        else:
##            atc = 'NA'
##
#        prod = drug.find('db:products',ns).text
##        if len(prod) > 0:
##            prod = prod[0].text.lower()
##
##            if prod == '\n      ':
##                prod = 'NA'
##
##            else:
##                prod = 'NA'
##
#        drug_class = drug.find('db:class',ns)
#        if type(drug_class) != type(None):
#            drug_class = drug_class.text.lower() 
#
#            if drug_class == '\n      ':
#                drug_class= 'NA'
#
#        else:
#            drug_class = 'NA'
#
#        row = [ name, db_id, ahfs, atc, prod, drug_class ]
#        writer.writerow(row)
#
#match_file.close()
#
#match_spending = 0
#all_spending = 0
#
#part_d_semi = pd.DataFrame()
#part_d_anti = pd.DataFrame()
#for i in range(0,df.shape[0]):
#    row = df.iloc[i]
#
#    if row.brand_name in drugbank_names:
#        part_d_semi = part_d_semi.append(df.iloc[[i]])
#
#    else:
#        part_d_anti = part_d_anti.append(df.iloc[[i]])
