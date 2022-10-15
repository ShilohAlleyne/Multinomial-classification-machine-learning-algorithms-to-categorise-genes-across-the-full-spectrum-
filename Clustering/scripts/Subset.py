
import pandas as pd
import os

os.chdir(
        r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main")

# NOTE: Loads in the data
df = pd.read_csv(r"Clustering\tmp\protein_coding.csv",
                 index_col=0, low_memory=False)
dfA = pd.read_csv(r"Clustering\tmp\human_rpkm.csv", index_col=0)
groups = pd.read_csv(r"Clustering\tmp\subset_groups_df.csv")
fusil = pd.read_csv(r"Clustering\tmp\test_data.csv", index_col=0)

# Makes a list of each protien coding gene ID
glist = pd.Series(list(df['ensembl_gene_id']))

# NOTE: Subsets the human_rpkm data
good_keys = dfA.index.intersection(glist)  # checks if gene is in rkpm data
subset = dfA.loc[good_keys]

# Cleans human_rpkm subset group data and reformats the test data
groups.columns = ["ensembl_gene_id", "Group"]
df2 = df[['hgnc_id', 'ensembl_gene_id']]

# NOTE: Coverts Ensembl ids to Hgnc ids
df3 = pd.merge(left=df2,
               right=groups,
               how='left',
               left_on='ensembl_gene_id',
               right_on='ensembl_gene_id')

# NOTE: Adds the fusil group to each gene
dfB = fusil[['HGNC_ID', 'FUSIL']]
dfB.columns = ['hgnc_id', 'FUSIL']
df4 = pd.merge(left=df3,
               right=dfB,
               how='left',
               left_on='hgnc_id',
               right_on='hgnc_id')
df4.dropna(inplace=True)
df4. drop('ensembl_gene_id', axis=1, inplace=True)

# NOTE: Counts the which FUSIL Groups relate to Cluster groups
count_series = df4.groupby(['FUSIL', 'Group']).size()
group_size = count_series.to_frame(name='size').reset_index()

# group_size.to_csv(r"Clustering\tmp\rpkm_group_size.csv", index=False)
# df4.to_csv(r"Clustering\tmp\ensembl and hgnc idsb.csv", index=False)
print(df3)
print(df4)
