

# Annotation distribution
anno = dict(
            subdata=['Heart data',
                     'Brain data',
                     'Cerebellum data',
                     'Kidney data',
                     'Liver data',
                     'Ovary data',
                     'Testis data',
                     'Missense Data',
                     'Probably Damaging Flags',
                     'Synonymous variants data',
                     'Probability data',
                     'No constraint metrics',
                     'Z score data',
                     'pLoF variant sites',
                     'Allele Frequency data',
                     'Exac Data',
                     'Consensus UTR lengths',
                     'Max UTR lengths',
                     'Gene Lengths',
                     'Chromosome data',
                     'Protein Physiochemical Data'],
            data=['Gene Expression Annotations',
                  'Gene Expression Annotations',
                  'Gene Expression Annotations',
                  'Gene Expression Annotations',
                  'Gene Expression Annotations',
                  'Gene Expression Annotations',
                  'Gene Expression Annotations',
                  'Constraint Annotations',
                  'Constraint Annotations',
                  'Constraint Annotations',
                  'Constraint Annotations',
                  'Constraint Annotations',
                  'Constraint Annotations',
                  'Constraint Annotations',
                  'Constraint Annotations',
                  'Constraint Annotations',
                  'Gene Annotations',
                  'Gene Annotations',
                  'Gene Annotations',
                  'Gene Annotations',
                  ''],
            value=[44,
                   53,
                   58,
                   36,
                   49,
                   18,
                   39,
                   11,
                   4,
                   7,
                   12,
                   1,
                   3,
                   1,
                   9,
                   4,
                   2,
                   2,
                   2,
                   2,
                   30]
)

# Performance Results
results = dict(
               model=['Stack', 'Boosted Trees', 'Random Forest', 'SVM',
                      'Glm LogReg', 'K-NN', 'Flexible Discriminant Analysis',
                      'Single Layer Nueral Network', 'Naive Bayes'],
               accuracy=[0.6653226,   # Stack
                         0.6683468,   # Boosted Trees
                         0.6653226,   # Random Forest
                         0.6401210,   # SVM
                         0.6381048,   # Glm
                         0.6320565,   # K-NN
                         0.6290323,   # FDA
                         0.6239919,   # SLNN
                         0.6118952],  # Naive Bayes
               auc=[0,          # Stack
                    0.7959326,   # Boosted Trees
                    0.7904210,   # Random Forest
                    0.7742784,   # SVM
                    0.7584861,   # Glm
                    0.7550010,   # K-NN
                    0.7623895,   # FDA
                    0.7157252,   # SLNN
                    0.6584832],  # Naive Bayes
               spec=[0,   # Stack
                     0.663,   # Boosted Trees
                     0.642,   # Random Forest
                     0.556,   # SVM
                     0.589,   # Glm
                     0.688,   # K-NN
                     0.640,   # FDA
                     0.647,   # SLNN
                     0.641],  # Naive Bayes
               sens=[0,   # Stack
                     0.674,   # Boosted Trees
                     0.665,   # Random Forest
                     0.640,   # SVM
                     0.638,   # Glm
                     0.632,   # K-NN
                     0.629,   # FDA
                     0.616,   # SLNN
                     0.631],  # Naive Bayes
)

accuracy = dict(
               model=['BT', 'RF', 'SVM',
                      'Glm', 'K-NN', 'FDA',
                      'SNN', 'Naive'],
               all5=[0.5669688,   # Boosted Trees
                     0.5629406,   # Random Forest
                     0.5417925,   # SVM
                     0.5407855,   # Glm
                     0.5166163,   # K-NN
                     0.5327291,   # FDA
                     0.5276939,   # SLNN
                     0.4994965],  # Naive Bayes
               lethal=[0.6942482,   # Boosted Trees
                       0.6871847,   # Random Forest
                       0.6700303,   # SVM
                       0.6639758,   # Glm
                       0.6387487,   # K-NN
                       0.6387487,   # FDA
                       0.6387487,   # SLNN
                       0.6155399],  # Naive Bayes
               cl=[0.6683468,   # Boosted Trees
                   0.6653226,   # Random Forest
                   0.6401210,   # SVM
                   0.6381048,   # Glm
                   0.6320565,   # K-NN
                   0.6290323,   # FDA
                   0.6239919,   # SLNN
                   0.6118952])  # Naive Bayes

auc = dict(
               model=['BT', 'RF', 'SVM',
                      'Glm', 'K-NN', 'FDA',
                      'SNN', 'Naive'],
               all5=[0.7170424,   # Boosted Trees
                     0.7217868,   # Random Forest
                     0.6845263,   # SVM
                     0.6988948,   # Glm
                     0.6205580,   # K-NN
                     0.6988228,   # FDA
                     0.6557353,   # SLNN
                     0.6190492],  # Naive Bayes
               lethal=[0.7197539,   # Boosted Trees
                       0.7027863,   # Random Forest
                       0.6747316,   # SVM
                       0.6684636,   # Glm
                       0.6750218,   # K-NN
                       0.6817548,   # FDA
                       0.6776823,   # SLNN
                       0.6344215],  # Naive Bayes
               cl=[0.7764802,   # Boosted Trees
                   0.7628087,   # Random Forest
                   0.7354043,   # SVM
                   0.7328297,   # Glm
                   0.7126819,   # K-NN
                   0.7512287,   # FDA
                   0.7060503,   # SLNN
                   0.6190492])  # Naive Bayes

sens = dict(
               model=['BT', 'RF', 'SVM',
                      'Glm', 'K-NN', 'FDA',
                      'SNN', 'Naive'],
               all5=[0.570,   # Boosted Trees
                     0.567,   # Random Forest
                     0.542,   # SVM
                     0.541,   # Glm
                     0.517,   # K-NN
                     0.533,   # FDA
                     0.544,   # SLNN
                     0.531],  # Naive Bayes
               lethal=[0.6912210,   # Boosted Trees
                       0.6851665,   # Random Forest
                       0.6700303,   # SVM
                       0.6639758,   # Glm
                       0.6387487,   # K-NN
                       0.6387487,   # FDA
                       0.6468214,   # SLNN
                       0.6559031],  # Naive Bayes
               cl=[0.674,   # Boosted Trees
                   0.665,   # Random Forest
                   0.640,   # SVM
                   0.638,   # Glm
                   0.632,   # K-NN
                   0.629,   # FDA
                   0.616,   # SLNN
                   0.631])  # Naive Bayes

spec = dict(
               model=['BT', 'RF', 'SVM',
                      'Glm', 'K-NN', 'FDA',
                      'SNN', 'Naive'],
               all5=[0.650,   # Boosted Trees
                     0.634,   # Random Forest
                     0.602,   # SVM
                     0.602,   # Glm
                     0.632,   # K-NN
                     0.642,   # FDA
                     0.646,   # SLNN
                     0.666],  # Naive Bayes
               lethal=[0.6666134,   # Boosted Trees
                       0.6412689,   # Random Forest
                       0.6036411,   # SVM
                       0.6143160,   # Glm
                       0.6573207,   # K-NN
                       0.6206714,   # FDA
                       0.6500026,   # SLNN
                       0.6103579],  # Naive Bayes
               cl=[0.663,   # Boosted Trees
                   0.642,   # Random Forest
                   0.556,   # SVM
                   0.589,   # Glm
                   0.688,   # K-NN
                   0.640,   # FDA
                   0.647,   # SLNN
                   0.641])  # Naive Bayes

ranking = dict(
               model=['BT', 'RF', 'SVM',
                      'Glm', 'K-NN', 'FDA',
                      'SNN', 'Naive'],
               acc=[1,   # Boosted Trees
                    2,   # Random Forest
                    3,   # SVM
                    4,   # Glm
                    7,   # K-NN
                    5,   # FDA
                    6,   # SLNN
                    8],  # Naive Bayes
               auc=[1,   # Boosted Trees
                    2,   # Random Forest
                    5,   # SVM
                    4,   # Glm
                    7,   # K-NN
                    3,   # FDA
                    6,   # SLNN
                    8],  # Naive Bayes
               sens=[1,   # Boosted Trees
                     2,   # Random Forest
                     3,   # SVM
                     4,   # Glm
                     8,   # K-NN
                     7,   # FDA
                     6,   # SLNN
                     5],
               spec=[1,   # Boosted Trees
                     5,   # Random Forest
                     8,   # SVM
                     7,   # Glm
                     2,   # K-NN
                     6,   # FDA
                     3,   # SLNN
                     4])  # Naive Bayes

acc2 = dict(
               model=['BT', 'RF', 'SVM',
                      'Glm', 'K-NN', 'FDA',
                      'SNN', 'Naive'],
               Dataset3=[0.7764802,   # Boosted Trees
                         0.7628087,   # Random Forest
                         0.7354043,   # SVM
                         0.7328297,   # Glm
                         0.7126819,   # K-NN
                         0.7512287,   # FDA
                         0.7060503,   # SLNN
                         0.6190492],  # Naive Bayes
               Dataset4=[0.7932689,   # Boosted Trees
                         0.7906773,   # Random Forest
                         0.7774880,   # SVM
                         0.7751393,   # Glm
                         0.7464607,   # K-NN
                         0.7283903,   # FDA
                         0.7016620,   # SLNN
                         0.3248161])  # Naive Bayes
