# Load necessary libraries
library(tidyverse)
library(caret)
library(glmnet)
library(gplots)

# --- DATA PREPARATION ---

# Read the CSV file
data <- read_csv("diabetes2.csv")

# Display the structure of the dataframe
str(data)

# Check for missing values and provide a summary
cat("Missing values per column:\n")
print(colSums(is.na(data)))
cat("\nData Summary:\n")
print(summary(data))

# Correlation matrix
cat("\nCorrelation matrix:\n")
print(cor(data))
