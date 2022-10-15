
import pandas as pd
import os

os.chdir(
        r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main")

pd.set_option("display.max_columns", None)

# NOTE: Loads data
df = pd.read_csv(r"Clustering\tmp\enanostruct.csv")

# NOTE: Calculates the length of each isoforms utrs
df['5_utr_length'] = df['5_utr_end'] - df['5_utr_start']
df['3_utr_length'] = df['3_utr_end'] - df['3_utr_start']

# NOTE: Replaces the nan value with 0
df['5_utr_length'] = df['5_utr_length'].fillna(0)
df['3_utr_length'] = df['3_utr_length'].fillna(0)
df['cds_length'] = df['cds_length'].fillna(0)

# NOTE: Takes the largest UTR in each direction
max5 = df.loc[df.groupby("ensembl_gene_id")["5_utr_length"].idxmax()]
max5 = max5.drop(columns=['5_utr_start', '5_utr_end',
                          '3_utr_start', '3_utr_end',
                          '3_utr_length', 'cds_length'])
max5.columns = ['ensembl_gene_id', '5_utr_max']

max3 = df.loc[df.groupby("ensembl_gene_id")["3_utr_length"].idxmax()]
max3 = max3.drop(columns=['5_utr_start', '5_utr_end',
                          '3_utr_start', '3_utr_end',
                          '5_utr_length', 'cds_length'])
max3.columns = ['ensembl_gene_id', '3_utr_max']

# NOTE: Takes the longest cds length for each gene
cds_max = df.loc[df.groupby('ensembl_gene_id')["cds_length"].idxmax()]
cds_max = cds_max.drop(columns=['5_utr_start', '5_utr_end',
                                '3_utr_start', '3_utr_end',
                                '3_utr_length', '5_utr_length'])
cds_max.columns = ['ensembl_gene_id', 'cds_max']

# NOTE: Merges all dataframes together
df2 = pd.merge(left=cds_max,
               right=max5,
               how='left',
               left_on='ensembl_gene_id',
               right_on='ensembl_gene_id')

df3 = pd.merge(left=df2,
               right=max3,
               how='left',
               left_on='ensembl_gene_id',
               right_on='ensembl_gene_id')

df3.to_csv(r"Clustering\tmp\max utr length.csv", index=False)
