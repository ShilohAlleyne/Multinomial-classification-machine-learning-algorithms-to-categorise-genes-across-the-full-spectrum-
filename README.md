## Multinomial classification machine learning algorithms to categorise genes across the full spectrum on intolerance to variation

Some genes are essential for an organism to develop, meaning that disruption of the function of those genes leads to early lethality. For some other genes, their loss-of-function (LoF) does not compromise the organism’s normal functioning and we observe no discernible clinical impact. These are the most extreme classes of a spectrum of gene essentiality or intolerance to LoF variation. Knowing how essential a gene is provides valuable information about their potential involvement in disease processes.

In this project we aim at classifying the whole set of ~ 20.000 human protein coding genes in discrete classes according to their intolerance to LoF variation. For that we will evaluate the prediction performance of different algorithms for multiclass classification (penalised regression, random forest, gradient boosting) using various sets of gene annotations including human sequencing studies data, gene expression datasets, model organisms phenotypic screens and human cell assays.

The student will get familiar with the principles underlying machine learning and learn how to apply different algorithms and evaluate a model’s performance. The project will be conducted in R. Some previous experience in this language, as well as familiarity with Git, GitHub) and some basic statistics knowledge are required. A keen interest in human genetics and willingness to get involved in the project, good team skills, an ability to take initiative and to think critically are also desirable.


### Training dataset

As the training dataset we will be using the FUSIL categories from [Cacheiro et al. 2020](https://www.nature.com/articles/s41467-020-14284-2), available here: https://www.ebi.ac.uk/biostudies/files/S-BSST293/SourceDataFile1_FUSIL_bins.txt


### Prediction dataset

We would like to make predictions for the entire set of protein coding genes, we will use the HGNC set containing 19,220 genes and HGNC ids as stable identifiers throught the project http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/locus_types/gene_with_protein_product.txt


### Predictive features

* Gene expression across development: Human data for different organs from https://apps.kaessmannlab.org/evodevoapp/
* Protein protein interaction network features: need to compute parameteres from a ppi
* Constraint metrics from gnomAD https://gnomad.broadinstitute.org/downloads#v2-constraint
* Sequence conservation metrics
* Recombination rates
* Paralogues
* ....
