
import pandas as pd
import os

os.chdir(
        r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main")

pd.set_option('display.max_columns', None)

# NOTE: Loads data
rkpm = pd.read_csv(r"Clustering\tmp\human_rpkm.csv")
anno = pd.read_csv(r'Classification\Input Data\trainingdata.csv')
names = pd.read_csv(r'Clustering\tmp\en and hg.csv')
groups = pd.read_csv(r'Classification\tmp\anno_groups.csv')


# NOTE: Adds the Ensembl id to the annotations
df = pd.merge(left=anno,
              right=names,
              how='left',
              left_on='hgnc_id',
              right_on='hgnc_id')


df2 = pd.merge(left=df,
               right=rkpm,
               how='left',
               left_on='ensembl_gene_id',
               right_on='Unnamed: 0')


df2 = df2.drop(columns=['ensembl_gene_id', 'Unnamed: 0'])

# NOTE: Moves the fusil group column to the end of the df
df3 = df2[[c for c in df2 if c not in ['fusil']] + ['fusil']]

df3.to_csv(r'Classification\Input Data\ trainingdata_rkpm.csv', index=False)

# NOTE: Adds the cluster groups
groups.columns = ['hgnc_id', 'Group']

dfA = pd.merge(left=anno,
               right=groups,
               how='left',
               left_on='hgnc_id',
               right_on='hgnc_id')

# NOTE: Changes the cluster groups to dummy FUSIL groups
dfA['Group'].replace([1, 2, 3, 4, 5],
                     ['DL', 'VP', 'CL', 'SV', 'VN'],
                     inplace=True)

# dfA.to_csv(r'Classification\tmp\anno_cluster.csv', index=False)

print(names)
