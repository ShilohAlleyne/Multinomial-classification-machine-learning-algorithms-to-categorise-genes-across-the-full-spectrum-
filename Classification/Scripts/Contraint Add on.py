import pandas as pd
import os

os.chdir(
        r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main")

# pd.set_option('display.max_columns', None)

# NOTE: loads Data
data = pd.read_csv(r'Classification\Input data\trainingdata_rkpm.csv')
con = pd.read_csv(r'Classification\Input data\Contraints.csv', index_col=0)
names = pd.read_csv(r'Classification\tmp\est hg.csv', index_col=0)

# NOTE: Adds the Ensembl transcript id to the annotations
df = pd.merge(left=data,
              right=names,
              how='left',
              left_on='hgnc_id',
              right_on='hgnc_id')

# NOTE: Adds the Contraint data to the annotations
df2 = pd.merge(left=df,
               right=con,
               how='left',
               left_on='ensembl_transcript_id',
               right_on='transcript')

# NOTE: Moves the fusil group column to the end of the df
df3 = df2[[c for c in df2 if c not in ['fusil']] + ['fusil']]
df3 = df3.drop(columns=['ensembl_transcript_id',
                        'gene', 'transcript', 'gene_id',
                        'transcript_type', 'gene_type', 'cds_max',
                        'constraint_flag', 'brain_expression',
                        'chromosome'])

# NOTE: Deletes the GO dummy collumns
df3 = df3[df3.columns.drop(list(df3.filter(regex='go_id')))]

df4 = df3.dropna()
# df3 = 5279 557 rows df4 = 4958 rows df5 = 4954

df5 = df4.drop_duplicates(subset=['hgnc_id'])

# print(df5.groupby(['fusil'])['fusil'].count())

# NOTE: Compresses the 5 fusil groups into 3
df5['fusil'].replace(['CL', 'SV', 'VN', 'VP'],
                     ['CLSV', 'CLSV', 'VNVP', 'VNVP'],
                     inplace=True)

df5.to_csv(r'Classification\tmp\DL CLSV VNVP.csv', index=False)

# print(df5.groupby(['fusil'])['fusil'].count())
