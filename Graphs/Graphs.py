from plotly import graph_objects as go
from plotly.subplots import make_subplots
import plotly.express as px
import pandas as pd
import os
from data import anno, results, accuracy, auc, sens, spec, ranking, acc2


os.chdir(
        r"C:\Users\yido6\Documents\Uni\Level 7\Research Project\fusil-ml-main")


df = pd.DataFrame.from_dict(anno)
df.rename(columns={'value': 'Number of different annotations in Dataset'},
          inplace=True)

df2 = pd.DataFrame.from_dict(results)
df2['Composite Score'] = df2['accuracy'] + df2['auc'] +\
                         df2['spec'] + df2['sens']
# df2.replace(0, np.nan, inplace=True)
df3 = pd.read_csv(r'Classification\tmp\anno_constraint.csv')
df4 = pd.read_csv(r'Classification\tmp\3 fusil.csv')
df5 = pd.read_csv(r'Classification\tmp\3 fusil New Groups.csv')

df6 = pd.DataFrame.from_dict(accuracy)
df7 = pd.DataFrame.from_dict(auc)
df8 = pd.DataFrame.from_dict(sens)
df9 = pd.DataFrame.from_dict(spec)
df10 = pd.DataFrame.from_dict(ranking)

# NOTE: Funnel Graph
fig = go.Figure(go.Funnel(
    y=["Gene Expression Annotations",
       "Gene Tolerance Annotations",
       "Gene Annotation",
       "Protein Physiochemical Property Annotations"],
    x=[297, 110, 8, 6],
    textposition="inside",
    textinfo="value+percent total",
    opacity=0.65, marker={"color": ["deepskyblue",
                                    "lightsalmon",
                                    "tan",
                                    "teal"],
                          "line": {"width": [4, 2, 2, 3, 1, 1],
                                   "color": ["wheat",
                                             "wheat",
                                             "blue",
                                             "wheat"]}},
    connector={"line": {"color": "royalblue", "dash": "dot", "width": 3}}))

# NOTE: Sunburst plot of annotations
fig2 = px.sunburst(df, path=['data', 'subdata'],
                   values='Number of different annotations in Dataset',
                   color='Number of different annotations in Dataset',
                   color_continuous_scale='BrBG',
                   branchvalues="total")

# NOTE: Barchart of Performance metrics <- add more metrics later
fig3 = go.Figure()
fig3.add_trace(go.Bar(
                      x=df2['model'],
                      y=df2['accuracy'],
                      name='Accuracy',
                      marker_color='#00A08B'
))
fig3.add_trace(go.Bar(
                      x=df2['model'],
                      y=df2['auc'],
                      name='Area under the curve',
                      marker_color='#9D755D'
))
fig3.add_trace(go.Bar(
                      x=df2['model'],
                      y=df2['spec'],
                      name='Specificity',
                      marker_color='#330C73'
))
fig3.add_trace(go.Bar(
                      x=df2['model'],
                      y=df2['sens'],
                      name='Sensivity',
                      marker_color='#EB89B5'
))
fig3.update_layout(
     title="Model Performance",
     xaxis_title="Model",
     legend_title="Metric",
     legend=dict(
        x=0,
        y=1.0,
        bgcolor='rgba(255, 255, 255, 0)',
        bordercolor='rgba(255, 255, 255, 0)'
     ),
     font=dict(size=26),
     barmode='group',
     bargap=0.15,     # gap between bars of adjacent location coordinates.
     bargroupgap=0.1  # gap between bars of the same location coordinate.
)

# NOTE: Barchart showing overall Performance
fig4 = go.Figure()
fig4.add_trace(go.Bar(
                      x=df2['model'],
                      y=df2['Composite Score'],
                      marker_color='rgb(118, 78, 159)'
))
fig4.update_layout(
     title="Model Performance",
     xaxis_title="Model",
     yaxis_title="Composite Score",
     legend_title="Model Performance",
)

# NOTE: Fusil cateogry distribution
fig6 = make_subplots(rows=2,
                     cols=2,
                     vertical_spacing=1,
                     horizontal_spacing=0.2)
trace0 = go.Histogram(x=df3['fusil'],
                      name='No grouping (DL, CL, SV, VN, VP)',
                      marker_color='#00A08B')
trace1 = go.Histogram(x=df4['fusil'],
                      name='Lethal (DL+CL), Subviable (SV), Viable (VN+VP)',
                      marker_color='#9D755D')
trace2 = go.Histogram(x=df5['fusil'],
                      name='CL, DL+SV, VN+VP',
                      marker_color='rgb(190,186,218)')

fig6.append_trace(trace0, 1, 1)
fig6.append_trace(trace1, 1, 2)
fig6.append_trace(trace2, 2, 1)

fig6.update_layout(
     title="Fusil Distribution",
     yaxis_title="Number of Genes in Group",
     legend_title="Fusil Groupings",
     legend=dict(
                 yanchor="bottom",
                 y=0.10,
                 xanchor="right",
                 x=0.99,
                 font=dict(size=50))
)

# NOTE: New Bar Graphs for every fusil distribution
fig7 = make_subplots(rows=2, cols=2,
                     horizontal_spacing=0.05)

# NOTE: Accuracy
fig7.add_trace(go.Bar(
                      x=df6['model'],
                      y=df6['all5'],
                      name='No grouping (DL, CL, SV, VN, VP)',
                      marker_color='#00A08B'),
               row=1,
               col=1)
fig7.add_trace(go.Bar(
                      x=df6['model'],
                      y=df6['lethal'],
                      name='Lethal (DL+CL), Subviable (SV), Viable (VN+VP)',
                      marker_color='#9D755D'),
               row=1,
               col=1)

fig7.add_trace(go.Bar(
                      x=df6['model'],
                      y=df6['cl'],
                      name='CL, DL+SV, VN+VP',
                      marker_color='#B279A2'),
               row=1,
               col=1)

# NOTE: auc
fig7.add_trace(go.Bar(
                      x=df7['model'],
                      y=df7['all5'],
                      showlegend=False,
                      marker_color='#00A08B'),
               row=1,
               col=2)
fig7.add_trace(go.Bar(
                      x=df7['model'],
                      y=df7['lethal'],
                      showlegend=False,
                      marker_color='#9D755D'),
               row=1,
               col=2)
fig7.add_trace(go.Bar(
                      x=df7['model'],
                      y=df7['cl'],
                      showlegend=False,
                      marker_color='#B279A2'),
               row=1,
               col=2)

# NOTE: Sensivity
fig7.add_trace(go.Bar(
                      x=df8['model'],
                      y=df8['all5'],
                      showlegend=False,
                      marker_color='#00A08B'),
               row=2,
               col=1)
fig7.add_trace(go.Bar(
                      x=df8['model'],
                      y=df8['lethal'],
                      showlegend=False,
                      marker_color='#9D755D'),
               row=2,
               col=1)
fig7.add_trace(go.Bar(
                      x=df8['model'],
                      y=df8['cl'],
                      showlegend=False,
                      marker_color='#B279A2'),
               row=2,
               col=1)

# NOTE: Specificity
fig7.add_trace(go.Bar(
                      x=df9['model'],
                      y=df9['all5'],
                      showlegend=False,
                      marker_color='#00A08B'),
               row=2,
               col=2)
fig7.add_trace(go.Bar(
                      x=df9['model'],
                      y=df9['lethal'],
                      showlegend=False,
                      marker_color='#9D755D'),
               row=2,
               col=2)
fig7.add_trace(go.Bar(
                      x=df9['model'],
                      y=df9['cl'],
                      showlegend=False,
                      marker_color='#B279A2'),
               row=2,
               col=2)

# NOTE: Update xaxis properties
fig7.update_xaxes(title_text="Model", row=1, col=1)
fig7.update_xaxes(title_text="Model", row=1, col=2)
fig7.update_xaxes(title_text="Model", row=2, col=1)
fig7.update_xaxes(title_text="Model", row=2, col=2)

# Update yaxis properties
fig7.update_yaxes(title_text="Accuracy", row=1, col=1)
fig7.update_yaxes(title_text="Roc AUC", row=1, col=2)
fig7.update_yaxes(title_text="Sensivity", row=2, col=1)
fig7.update_yaxes(title_text="Specificity", row=2, col=2)

# Update title and height
fig7.update_layout(
            title_text="Model Performance across different Fusil Groupings",
            height=700,
            showlegend=True,
            legend=dict(
                        orientation="h",
                        yanchor="bottom",
                        y=1.02,))

# fig7.show()

candidates = ['BT', 'SVM', 'FDA', 'NNET', 'GLm', 'RF']
prop = [13, 3, 1, 5, 4, 4]

# NOTE: Top ten Candiate distribution
fig8 = px.pie(values=prop, names=candidates,
              color_discrete_sequence=px.colors.sequential.Viridis)

# NOTE: Variable importance barcharts
df11 = pd.DataFrame.from_dict(acc2)

fig9 = go.Figure()

fig9.add_trace(go.Bar(
                      x=df11['model'],
                      y=df11['Dataset3'],
                      name='Dataset3',
                      marker_color='#00A08B'))

fig9.add_trace(go.Bar(
                      x=df11['model'],
                      y=df11['Dataset4'],
                      name='Dataset4',
                      marker_color='#9D755D'))

fig9.show()
