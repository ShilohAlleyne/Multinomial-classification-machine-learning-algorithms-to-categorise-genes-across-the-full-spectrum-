import pandas as pd
import os
import re

os.chdir(
        r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main")

pd.set_option('display.max_columns', None)

scores = pd.read_csv(r'Classification\tmp\protein links.csv', index_col=0)
# scores = scores.drop(columns=['Unnamed: 0'])

# NOTE: Filters score
df = scores.query("combined_score >= 700")

ENS = df[df["protein1"] == "9606.ENSP00000000233"]

# df2 = df.pivot_table(index='protein1', columns='protein2', values='combined_score')
# df2 = df2.fillna(0)

df3 = df.groupby(['protein1'])['protein1'].count()
df3.columns = ['protein', 'num_high_conf']

print(df3)

# p = re.compile(r'^[0-9]+\.')
# df3['protein1'] = [p.sub('', x) for x in df['protein1']]

df3['protein1'] = df3['protein'].str.replace(r'\d+\.', '')

print(df3)
