
import pandas as pd
import os

os.chdir(
        r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main")

# NOTE: Loads data
df = pd.read_csv(r"Clustering\tmp\allenseq.csv")
print(df)

# NOTE: Cleans data
df = df[df["peptide"].str.contains("Sequence unavailable") == False]

# NOTE: Counts the number of transcripts for each gene
size = df.groupby('ensembl_gene_id').size()

# NOTE: Counts the length of each seq and filters for the longest one
df['seq_length'] = df['peptide'].str.len()
df = df.loc[df.groupby("ensembl_gene_id")["seq_length"].idxmax()]

# NOTE: Adds to the number of transcripts to the main df
df2 = pd.merge(left=df,
               right=size.rename('transcript_number'),
               how='left',
               left_on='ensembl_gene_id',
               right_on='ensembl_gene_id')

print(df2)
df2.to_csv(r"Clustering\tmp\canonical_enseq.csv", index=False)
