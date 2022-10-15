
library(fastDummies)

gc()

dumfeat <- dummy_cols(anofeature,
                      select_columns = c('seg',
                                         'tmhmm',
                                         'ncoils',
                                         'signalp'))


dumGO <- dummy_cols(gene_go_top50,
                    select_columns = 'go_id')

dumGO2 <- dummy_cols(gene_go_top50,
                     select_columns = 'symbol')

gc()
write.csv(dumGO2, "tmp\\dumGO2.csv", row.names = FALSE)
