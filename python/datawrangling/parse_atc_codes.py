import pandas as pd
from cStringIO import StringIO
from string import ascii_uppercase

def create_row(values):
    row = []
    for l in letters:
        x = '' if values[l] is None else values[l]
        row.append(x)
    ret = '\t'.join(row) + '\n'
    return ret

def update_values(x, values, letter):
    i = letters.index(letter) + 1
    n = 0
    for l in letters:
        if n>=i:
            values[l] = None
        elif n+1==i:
            values[l] = x
        n += 1
    return None


# store stuff
letters = ascii_uppercase[:6]
row = []
s = ''
start = False
values = {}
for l in letters:
    values[l] = None

# parse file
# (downloaded from: http://www.genome.jp/kegg-bin/get_htext?br08303.keg)
f = open('data/br08303.keg', 'r')
for line in f.readlines():
    # skip until data begins
    if not start:
        start = True if line[0]=='!' else False
        continue
    
    # check for lines to skip
    l = line[0]
    if l not in letters:
        continue
    if l=='!':
        break
    
    # parse row
    x = line[2:].strip()
    update_values(x, values, l)
    s += create_row(values)
f.close()

# read string into StringIO
f = StringIO(s)
df = pd.read_table(f, names=letters)
df.to_csv('data/atc-codes.csv', header=True, index=False)
