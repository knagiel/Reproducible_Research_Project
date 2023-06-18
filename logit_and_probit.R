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

# --- MODEL EVALUATION ---

# Predicting on the test set
predictions <- predict(logit, newdata = test, type = "response")

# Converting probabilities to class labels
predicted_classes <- ifelse(predictions > 0.5, 1, 0)

# Creating the confusion matrix
confusion_matrix <- table(predicted_classes, test$Outcome)

# Calculating accuracy
accuracy <- sum(diag(confusion_matrix)) / sum(confusion_matrix)

# Print evaluation metrics
cat("\nConfusion Matrix:\n")
print(confusion_matrix)
cat("\nAccuracy:", accuracy, "\n")
# Save the model
saveRDS(logit, file = "logistic_reg.rds")

# --- PREDICTION ON NEW DATA ---

# User-defined data
new_data <- data.frame(Pregnancies = 5, Glucose = 0, BloodPressure = 33.7, 
                       SkinThickness = 50, Insulin = 150, BMI = 74, 
                       DiabetesPedigreeFunction = 0.5, Age = 53)

# Load the saved model
loaded_model <- readRDS("logistic_reg.rds")

# Predict on new data
ourmodelprediction <- predict(loaded_model, newdata = new_data, type = 'response')
ourmodelprediction <- ifelse(ourmodelprediction > 0.5, 1, 0)

cat("\nPrediction on new data:\n")
print(ourmodelprediction)
