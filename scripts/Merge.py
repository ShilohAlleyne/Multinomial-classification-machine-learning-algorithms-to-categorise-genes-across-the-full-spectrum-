
import os
# import terality as pd
import pandas as pd

os.chdir(
        r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main")

# NOTE: Loads data
df = pd.read_csv(r"Clustering\output data\physicochemical_enseq.csv")
utr = pd.read_csv(r"Clustering\tmp\max utr length.csv")
ids = pd.read_csv(r"Clustering\tmp\en and hg.csv")
features = pd.read_csv(r"Clustering\tmp\dumfeat.csv")
go = pd.read_csv(r"Clustering\tmp\dumGO.csv")

# NOTE: Cleans data
df = df.drop(columns='peptide')
features = features.drop(columns=['seg', 'tmhmm', 'ncoils', 'signalp'])
go = go.drop(columns='symbol')


# NOTE: Selects the Ids with the most features from duplicates
features['features'] = features['percentage_gene_gc_content'] + \
                       features['transcript_count'] + \
                       features['seg_'] + \
                       features['seg_seg'] +\
                       features['tmhmm_'] + \
                       features['tmhmm_TMhelix'] + \
                       features['ncoils_'] + \
                       features['ncoils_Coil'] + \
                       features['ncoils_Coil'] + \
                       features['signalp_'] + \
                       features['signalp_SignalP-noTM'] + \
                       features['signalp_SignalP-TM']
f_max = features.loc[features.groupby('hgnc_id')["features"].idxmax()]

go = go.groupby('hgnc_id').sum()
# go_max = go.loc[go.groupby('hgnc_id')["features"].idxmax()]

# NOTE: Merges all utr and physicochemical dfs together
df2 = pd.merge(left=utr,
               right=df,
               how='left',
               left_on='ensembl_gene_id',
               right_on='ensembl_gene_id')

# NOTE: Adds Hgnc ids to the previous dataframe
df3 = pd.merge(left=ids,
               right=df2,
               how='left',
               left_on='ensembl_gene_id',
               right_on='ensembl_gene_id')

# NOTE: Adds the GO features to the df
df4 = pd.merge(left=df3,
               right=f_max,
               how='left',
               left_on='hgnc_id',
               right_on='hgnc_id')

df4 = df4.drop(columns='features')

# NOTE: Add the top 50 GO terms to the df
df5 = pd.merge(left=df4,
               right=go,
               how='left',
               left_on='hgnc_id',
               right_on='hgnc_id')

df5 = df5.drop(columns='ensembl_gene_id')

df6 = df5.dropna()

print(len(df5.index), len(df6.index))


# df5.to_csv(r"Clustering\output data\allannotations.csv", index=False)

#df6.to_csv(r"Clustering\output data\allannotations_no_nan.csv", index=False)
