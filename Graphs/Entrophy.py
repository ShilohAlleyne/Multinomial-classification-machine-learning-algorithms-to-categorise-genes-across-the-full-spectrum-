import scipy.stats
import os
import pandas as pd

os.chdir(
        r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main")

df3 = pd.read_csv(r'Classification\tmp\anno_constraint.csv')
df4 = pd.read_csv(r'Classification\tmp\3 fusil.csv')
df5 = pd.read_csv(r'Classification\tmp\3 fusil New Groups.csv')


def ent(data):
    """Calculates entropy of the passed `pd.Series`
    """
    p_data = data.value_counts()           # counts occurrence of each value
    entropy = scipy.stats.entropy(p_data)  # get entropy from counts
    return entropy


ent(df3.value_counts(fusil)/sum(df3.value_counts(fusil).values)
