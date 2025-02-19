# package dependencies needed
library(tidyverse)
library(dplyr)
library(stringr)
library(fuzzyjoin)
library(readxl)

mutation_dat = read_csv("path/to/mutation_frequency_data_we_created")

# Select multiple genes
selected_genes <- c("PTEN", "TP53", "APC", "CTNNB1","EGFR", "ERBB2")
# maybe ERBB2, "SPECC1", "KRAS"

# Filter data for the chosen genes
filtered_data <- mutation_dat %>%
  filter(gene %in% selected_genes) 

# Get unique PTM positions per gene
PTM_positions_df <- filtered_data %>%
  distinct(gene, PTM_Position) %>%
  rename(xintercept = PTM_Position)

# Remove duplicate mutations at the same position
filtered_data <- filtered_data %>%
  distinct(gene, exact_position, .keep_all = TRUE)

# Create facet plot
ggplot(filtered_data, aes(x = exact_position, y = affected_cases_percentage)) +
  geom_bar(stat = "identity", fill = "steelblue", color = "darkblue") +
  # geom_vline(data = PTM_positions_df, aes(xintercept = xintercept), 
  #            linetype = "dashed", color = "red") +
  labs(
    title = "PTM Disrupting Mutation Frequency by Position",
    x = "Mutation Position",
    y = "Frequency of Mutation"
  ) +
  theme_minimal() +
  facet_wrap(~ gene, scales = "free")  # Facet by gene

# Save the plot as a PNG file
ggsave("facet_plot.png", width = 10, height = 6, dpi = 300)
