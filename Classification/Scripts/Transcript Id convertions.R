# Loads Dependancies -----------------------------------------------------------

library(biomaRt)

# Runs Query -------------------------------------------------------------------

mart <- useMart("ensembl", dataset="hsapiens_gene_ensembl")

id_convert <- getBM(attributes = c('ensembl_peptide_id',
                                   'hgnc_id'),
                    filters = "ensembl_transcript_id",
                    values = constraints$transcript,
                    mart = mart)


write.csv(id_convert, "tmp\\est hg.csv")

listAttributes(mart = mart)
