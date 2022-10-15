
import pandas as pd
import os

os.chdir(
        r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main")


ids = pd.read_csv(r'Classification\tmp\gene_with_protein_product.csv',
                  index_col=0)
data = pd.read_csv(r'Classification\tmp\anno_constraint.csv')

hgnc = data['hgnc_id']
symbol = ids[['hgnc_id', 'symbol']]

df = pd.merge(left=hgnc,
              right=symbol,
              how='left',
              left_on='hgnc_id',
              right_on='hgnc_id')

df2 = df['symbol']

# df2.to_csv(r'Classification\tmp\genelist.csv', index=False)
