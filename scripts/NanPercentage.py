import plotly.express as px
import pandas as pd
import os

os.chdir(
        r'C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main')

pd.set_option("display.max_rows", None)

df = pd.read_csv(r'Clustering\output data\allannotations_no_nan.csv')

isna = df.isna().sum().reset_index(name="n")

print(isna)
# isna.to_csv(r'Clustering\output data\variablenan.csv')
