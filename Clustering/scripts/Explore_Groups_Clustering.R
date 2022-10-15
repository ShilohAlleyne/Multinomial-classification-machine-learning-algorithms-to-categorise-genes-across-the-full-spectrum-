## Explore groups idenfied through clustering and 
## the correlation with FUSIL categories

# load packages -----------------------------------------------------------

if (!require("tidyverse")) install.packages("tidyverse")
library("tidyverse")


# import data -------------------------------------------------------------


groups <- read.csv("./tmp/subset_groups_fusil.csv", header = TRUE, sep = ",",
                     row.names = 1) %>%
  filter(FUSIL != "-")



# explore groups ----------------------------------------------------------


fusil_count <- groups %>%
  group_by(FUSIL) %>%
  tally() %>%
  rename(n_fusil = n)


groups_fusil <- groups %>%
  group_by(FUSIL, Group) %>%
  tally() %>%
  inner_join(fusil_count) %>%
  mutate(group_prop = (n/n_fusil) * 100) %>%
  mutate(FUSIL = factor(FUSIL, levels = c("CL","DL","SV","VP","VN"))) %>%
  mutate(Group = as.factor(Group))
  


# plot and export plot ----------------------------------------------------


plot_groups_fusil <- ggplot(groups_fusil, aes(x = FUSIL, y = group_prop, fill = Group)) + 
  geom_bar(position="dodge", stat="identity") 


ggsave("./plots/plot_groups_fusil.png", plot = plot_groups_fusil,
       width = 8, height = 8, units = "cm")

