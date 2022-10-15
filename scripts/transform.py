
import pandas as pd
import os

os.chdir(r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main")

# NOTE: Loads in the test data as a pandas df
df = pd.read_csv(r'Clustering\output datafiles\test_data.csv', index_col=0)
print(df)
groups = pd.read_csv(r'Clustering\output datafiles\test_data.csv')
groups.index += 1
groups.columns = ['HGNC_ID', 'Group']

# NOTE: This is the data without FUSIL as a factor
groups2 = pd.read_csv(r'Clustering\output datafiles\test_groups2.csv')
groups2.index += 1
groups2.columns = ['HGNC_ID', 'Group']


# NOTE: Adds the groups to each gene
test_merge = pd.merge(left=df,
                      right=groups,
                      how='left',
                      left_on='HGNC_ID',
                      right_on='HGNC_ID')

# NOTE: This is the second group data without FUSIL factor
test_merge2 = pd.merge(left=df,
                       right=groups2,
                       how='left',
                       left_on='HGNC_ID',
                       right_on='HGNC_ID')
print(test_merge2)

# NOTE: Counts the which FUSIL Groups relate to Cluster groups
count_series = test_merge.groupby(['FUSIL', 'Group']).size()
group_size = count_series.to_frame(name='size').reset_index()

# NOTE: This is the second group data without FUSIL factor
count_series2 = test_merge2.groupby(['FUSIL', 'Group']).size()
group_size2 = count_series2.to_frame(name='size').reset_index()

# NOTE: Outputs data as a csv file
# group_size.to_csv("group_size.csv", index=False)
# group_size2.to_csv("group_size2.csv", index=False)

print(group_size)
print(group_size2)
