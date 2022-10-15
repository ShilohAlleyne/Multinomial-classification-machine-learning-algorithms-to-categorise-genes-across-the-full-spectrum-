
import pandas as pd
import os

os.chdir(
        r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main")

# NOTE: Loads data
df = pd.read_csv(r"Clustering\tmp\enanostruct.csv")
hgnc = pd.read_csv(r"Clustering\tmp\ensembl and hgnc idsb.csv")

# NOTE: Calculates the length of each isoforms utrs
df['5_utr_length'] = df['5_utr_end'] - df['5_utr_start']
df['3_utr_length'] = df['3_utr_end'] - df['3_utr_start']

df.to_csv(r"Clustering\output data\en utr length.csv", index=False)
