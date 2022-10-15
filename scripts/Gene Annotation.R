
# Installs needed packages
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install()

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("biomaRt")
library("biomaRt")

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("sequencing")

install.packages("tidyverse")
library(tidyverse)

install.packages("Peptides")
library(Peptides)

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("EDASeq")
library(EDASeq)

install.packages("biomartr")
library(biomartr)

library(plyr)

install.packages("fastDummies")
library(fastDummies)

# Connects the ensembl
ensembl <- useDataset("hsapiens_gene_ensembl",mart=ensembl)
mart <- useMart("ensembl", dataset="hsapiens_gene_ensembl")

# Loads the gene list
genes <- read.csv("tmp\\subset_groups_fusil.csv", row.names="X")
en_ids <- read.csv("tmp\\ensembl and hgnc idsb.csv")



# Splits the df into sizable chunks to avoid ensemble timout
chunk <- 100
n <- nrow(genes)
r  <- rep(1:ceiling(n/chunk),each=chunk)[1:n]
E <- split(subset_groups_df,r)

# Makes a df of genes and their sequences
enseq <- lapply(E, function(s)getSequence(id = s$X,
              type = "ensembl_gene_id",
              seqType = "peptide",
              mart = ensembl))

# Joins all seq dfs to a mega df
allSeqs <- rbind(seq, seq2, seq3, seq4, seq5,
                 seq6, seq7, seq8, seq9, seq10)

# combines all of the df in the enseq list
allenseq <- ldply(enseq)[,-1]


# Calculates peptide stats for each canonical seq


canonical_enseq$aindex <- aIndex(seq = canonical_enseq$peptide)

# boman score
canonical_enseq$boman <- boman(seq = canonical_enseq$peptide)

# charge of the protein
canonical_enseq$charge <- charge(canonical_enseq$peptide, pH = 7, pKscale = "Lehninger")

# hmonent score
canonical_enseq$hmoment <- hmoment(canonical_enseq$peptide, angle = 100, window = 11)

# hydrophobicity of the protein
canonical_enseq$GRAVY <- hydrophobicity(canonical_enseq$peptide, scale = "KyteDoolittle")

# instability index
canonical_enseq$instaIndex <- instaIndex(canonical_enseq$peptide) 

# isoelectric point
canonical_enseq$pI <- pI(canonical_enseq$peptide, pKscale = "EMBOSS") 

# Sequence comp
physicochemical_enseq$AA_comp <- aaComp(physicochemical_enseq$peptide)
physicochemical_enseq <- physicochemical_enseq %>% unnest_wider(AA_comp)

# outputs data
write.csv(canonical_enseq, "output data\\physicochemical_enseq.csv", row.names = FALSE)


# Gene annotation

# Gene annotation from the feature page of ensemble
anofeature <- getBM(attributes = c('hgnc_id',
                                   "ensembl_gene_id",
                                   'percentage_gene_gc_content',
                                   'seg', # low complexity tag
                                   'tmhmm', # Transmembrane Helices
                                   'transcript_count',
                                   'ncoils',
                                   'signalp'), # Signal peptide 
             filters = "ensembl_gene_id",
             values = subset_groups_df$X,
             mart = mart)

en.hg <- getBM(attributes = c('hgnc_id',
                              'ensembl_gene_id'),
               filters = "ensembl_gene_id",
               values = subset_groups_df$X,
               mart = mart)


# Gene Go features
gofeature <- lapply(E, function(s) getBM(attributes = c('hgnc_id',
                                  'go_id',
                                  'name_1006',
                                  'namespace_1003',
                                  'goslim_goa_accession',
                                  'goslim_goa_description'), 
                    filters = "ensembl_gene_id",
                    values = s$X,
                    mart = mart))

# combines all 47 dfs into a mega df
allgofeatures <- ldply(gofeature)[,-1]

# combines all go df to big df
allgo <- rbind(gofeature, gofeature2, gofeature3, gofeature4, gofeature5,
               gofeature6, gofeature7, gofeature8, gofeature9, gofeature10)


# Gene structural features
anostruct <- getBM(attributes = c('ensembl_gene_id',
                                  '5_utr_start',
                                  '5_utr_end',
                                  '3_utr_start',
                                  '3_utr_end',
                                  'cds_length'), 
                     filters = "ensembl_gene_id",
                     values = subset_groups_df$X,
                     mart = mart)

listFilters(ensembl)


write.csv(anostruct, "tmp\\enanostruct.csv", row.names = FALSE)
write.csv(allgo, "output data\\allgo.csv", row.names = FALSE)
write.csv(physicochemical_enseq, "output data\\physicochemical_enseq.csv", row.names = FALSE)
