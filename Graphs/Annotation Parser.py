import pandas as pd
import os

os.chdir(
        r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main"
)

data = pd.read_csv(r"Classification\tmp\3 fusil.csv")

# NOTE: Gets the name of all columns
cols = []
for col in data.columns:
    cols.append(col)

# NOTE: Counts the number of each collumns for each sub cateogry
counter = 0
for i in cols:
    if "mu_" in i:
        counter += 1

imp = ['rain.4wpc.3', 'oe_lof_upper', 'Liver.8wpc.16',
       'Testis.18wpc.26', 'Brain.4wpc.2', 'Tiny.2',
       'Liver.18wpc.31', 'Heart.5wpc.4', 'Heart.5wpc.4',
       'Cerebellum.16wpc.32',  'gene_length']

df = data[['hgnc_id', 'Brain.4wpc.3', 'oe_lof_upper', 'Liver.8wpc.16',
           'Testis.18wpc.26', 'Brain.4wpc.2', 'Tiny.2',
           'Liver.18wpc.31', 'Heart.5wpc.4', 'Heart.5wpc.4',
           'Cerebellum.16wpc.32',  'gene_length', 'Liver.4wpc.3',
           'Brain.newborn.34', 'Cerebellum.7wpc.11', 'Testis.19wpc.27',
           'Heart.teenager.48', 'Ovary.9wpc.9', 'Brain.newborn.33',
           'Cerebellum.4wpc.3', 'oe_lof_upper_rank', 'Liver.8wpc.16',
           'Liver.18wpc.31', 'Cerebellum.13wpc.29',
           'Brain.4wpc.2', 'fusil']]
df.to_csv(r"Classification\tmp\dataset 2 imp.csv", index=False)

print(df)
