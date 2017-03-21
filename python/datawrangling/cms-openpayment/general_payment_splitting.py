"""
Separate the general payments table into tables for physicians, teaching hospitals,
manufacturers, drop the program year and publication date row as they are always the same
(for final publications at least)

author: sangxia
"""

import pandas as pd
import numpy as np
import csv
import argparse
from datetime import datetime

def split_csv(infile, outprefix):
    with open(infile) as fin, \
            open(outprefix + '.csv', 'w') as fout, \
            open(outprefix + '_physicians.csv', 'w') as foutp, \
            open(outprefix + '_hospitals.csv', 'w') as fouth, \
            open(outprefix + '_mf-gpo.csv', 'w') as foutm:

        df = pd.read_csv(infile, usecols=['Program_Year', 'Payment_Publication_Date'])
        s = df.isnull().sum()
        assert(s['Program_Year']==0)
        assert(s['Payment_Publication_Date']==0)
        assert(len(df['Program_Year'].unique())==1)
        assert(len(df['Payment_Publication_Date'].unique())==1)
        program_year = int(df['Program_Year'].unique()[0])
        print('Program year', program_year)
        colsout = ['Change_Type', 'Covered_Recipient_Type', 'Teaching_Hospital_ID', \
                'Physician_Profile_ID', 'Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID', \
                'Total_Amount_of_Payment_USDollars', 'Date_of_Payment', \
                'Number_of_Payments_Included_in_Total_Amount', \
                'Form_of_Payment_or_Transfer_of_Value', 'Nature_of_Payment_or_Transfer_of_Value', \
                'City_of_Travel', 'State_of_Travel', 'Country_of_Travel', 'Physician_Ownership_Indicator', \
                'Third_Party_Payment_Recipient_Indicator', \
                'Name_of_Third_Party_Entity_Receiving_Payment_or_Transfer_of_Value', \
                'Charity_Indicator', 'Third_Party_Equals_Covered_Recipient_Indicator', \
                'Contextual_Information', 'Delay_in_Publication_Indicator', 'Record_ID', \
                'Dispute_Status_for_Publication', 'Product_Indicator', \
                'Name_of_Associated_Covered_Drug_or_Biological1', \
                'Name_of_Associated_Covered_Drug_or_Biological2', \
                'Name_of_Associated_Covered_Drug_or_Biological3', \
                'Name_of_Associated_Covered_Drug_or_Biological4', \
                'Name_of_Associated_Covered_Drug_or_Biological5', \
                'NDC_of_Associated_Covered_Drug_or_Biological1', \
                'NDC_of_Associated_Covered_Drug_or_Biological2', \
                'NDC_of_Associated_Covered_Drug_or_Biological3', \
                'NDC_of_Associated_Covered_Drug_or_Biological4', \
                'NDC_of_Associated_Covered_Drug_or_Biological5', \
                'Name_of_Associated_Covered_Device_or_Medical_Supply1', \
                'Name_of_Associated_Covered_Device_or_Medical_Supply2', \
                'Name_of_Associated_Covered_Device_or_Medical_Supply3', \
                'Name_of_Associated_Covered_Device_or_Medical_Supply4', \
                'Name_of_Associated_Covered_Device_or_Medical_Supply5']
        colsp = ['Physician_Profile_ID', 'Physician_First_Name', 'Physician_Middle_Name', \
                'Physician_Last_Name', 'Physician_Name_Suffix', \
                'Recipient_Primary_Business_Street_Address_Line1', \
                'Recipient_Primary_Business_Street_Address_Line2', 'Recipient_City', \
                'Recipient_State', 'Recipient_Zip_Code', 'Recipient_Country', \
                'Recipient_Province', 'Recipient_Postal_Code', 'Physician_Primary_Type', \
                'Physician_Specialty', 'Physician_License_State_code1', \
                'Physician_License_State_code2', 'Physician_License_State_code3', \
                'Physician_License_State_code4', 'Physician_License_State_code5', \
                'Record_ID']
        colsh = ['Teaching_Hospital_CCN', 'Teaching_Hospital_ID', 'Teaching_Hospital_Name', \
                'Recipient_Primary_Business_Street_Address_Line1', \
                'Recipient_Primary_Business_Street_Address_Line2', 'Recipient_City', \
                'Recipient_State', 'Recipient_Zip_Code', 'Recipient_Country', \
                'Recipient_Province', 'Recipient_Postal_Code', 'Record_ID']
        colsm = ['Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name', \
                'Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID', \
                'Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name', \
                'Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State', \
                'Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country','Record_ID']
        rin = csv.DictReader(fin)
        rout, routp, routh, routm = [csv.DictWriter(f,fields,extrasaction='ignore') \
                for f,fields in zip([fout,foutp,fouth,foutm],[colsout,colsp,colsh,colsm])]
        for w in [rout,routp, routh, routm]:
            w.writeheader()
        lines = 0
        for r in rin:
            lines += 1
            if lines % 1000000 == 0:
                print(lines, 'lines')
            if not r['Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID']:
                print('Missing Manufacturer ID:', r)
                continue
            if 'Physician' in r['Covered_Recipient_Type']:
                if not r['Physician_Profile_ID']:
                    print('Missing Physician ID:', r)
                    continue
                if r['Teaching_Hospital_ID']:
                    print('Conflicting Hospital ID:', r)
                    continue
                for w in [rout, routp, routm]:
                    w.writerow(r)
            elif 'Hospital' in r['Covered_Recipient_Type']:
                if not r['Teaching_Hospital_ID']:
                    print('Missing Hospital ID:', r)
                    continue
                if r['Physician_Profile_ID']:
                    print('Conflicting Physician ID:', r)
                    continue
                for w in [rout, routh, routm]:
                    w.writerow(r)
            else:
                print('Unknown recipient type:', r)
                continue
            try:
                pay_date = datetime.strptime(r['Date_of_Payment'], '%m/%d/%Y')
                if pay_date > datetime.now():
                    print('future date: {0} @ id {1}, {2}'.format(r['Date_of_Payment'], r['Record_ID'], r))
                elif pay_date.year > program_year + 5:
                    print('large year diff: {0} @ id {1}, {2}'.format(r['Date_of_Payment'], r['Record_ID'], r))
                elif pay_date.year < program_year - 2:
                    print('large year diff: {0} @ id {1}, {2}'.format(r['Date_of_Payment'], r['Record_ID'], r))
            except ValueError:
                print('wrong date: {0} @ id {1}, {2}'.format(r['Date_of_Payment'], r['Record_ID'], r))
        print('total',lines,'lines')

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('infile', \
            help='input general payments full file name')
    parser.add_argument('outprefix', \
            help='output file name prefix for the payments, physicians, hospitals and manufacturer table')
    arg = vars(parser.parse_args())
    infile = arg['infile']
    outprefix = arg['outprefix']
    split_csv(infile,outprefix)

