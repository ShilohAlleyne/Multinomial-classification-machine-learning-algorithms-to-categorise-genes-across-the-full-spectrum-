if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

# install/load packages ---------------------------------------------------


BiocManager::install("GO.db")
BiocManager::install("org.Hs.eg.db")

library(tidiverse)



# import datasets ---------------------------------------------------------



hgnc <- read_delim("http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/locus_types/gene_with_protein_product.txt") %>%
  dplyr::select(hgnc_id, symbol)


head(toTable(org.Hs.egGO))
head(toTable(org.Hs.egSYMBOL))


# merge gene symbol info with entrez ids and get GO -----------------------



gene_ids <- toTable(org.Hs.egSYMBOL) %>%
  filter(symbol %in% hgnc$symbol)

gene_go <- toTable(org.Hs.egGO) %>%
  inner_join(gene_ids)


## select the more frequent terms (top 50) for each class: CC, BP and MF

gene_go_bp <- gene_go %>%
  filter(Ontology == "BP") %>%
  dplyr::select(symbol, go_id) %>%
  distinct() %>%
  group_by(go_id) %>%
  tally() %>%
  arrange(-n) %>%
  dplyr::slice(1:50)

top50_go_bp_terms <- gene_go_bp$go_id

gene_go_mf <- gene_go %>%
  filter(Ontology == "MF")%>%
  dplyr::select(symbol, go_id) %>%
  distinct() %>%
  group_by(go_id) %>%
  tally() %>%
  arrange(-n) %>%
  dplyr::slice(1:50)

top50_go_mf_terms <- gene_go_mf$go_id

gene_go_cc <- gene_go %>%
  filter(Ontology == "CC") %>%
  dplyr::select(symbol, go_id) %>%
  distinct() %>%
  group_by(go_id) %>%
  tally() %>%
  arrange(-n) %>%
  dplyr::slice(1:50)

top50_go_cc_terms <- gene_go_cc$go_id

### filter these annotations and merge with hgnc ids

gene_go_top50 <- gene_go %>%
  filter(go_id %in% c(top50_go_bp_terms,
                      top50_go_mf_terms,
                      top50_go_cc_terms)) %>%
  dplyr::select(symbol, go_id) %>%
  distinct() %>%
  inner_join(hgnc) %>%
  dplyr::select(hgnc_id, symbol, go_id)
