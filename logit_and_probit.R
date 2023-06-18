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

# --- MODEL TRAINING --- LOGIT

# Define features and target variables
features <- c('Pregnancies', 'Glucose', 'BloodPressure', 'SkinThickness', 'Insulin', 'BMI', 'DiabetesPedigreeFunction', 'Age')
x <- data[features]
y <- data$Outcome

# Split the dataset into training and testing sets
# Setting seed for reproducibility
set.seed(0)

# Splitting the data
splitIndex <- createDataPartition(data$Outcome, p = .90, list = FALSE, times = 1)
train <- data[splitIndex,]
test  <- data[-splitIndex,]

# Fitting the logistic regression model
logit <- glm(Outcome ~ ., data = train, family = binomial())

# Display the model summary
cat("\nLogistic Regression Model Summary:\n")
print(summary(logit))

