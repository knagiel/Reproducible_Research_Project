# Load necessary libraries
library(tidyverse)
library(caret)
library(glmnet)
library(gplots)
library(readr)

# --- DATA PREPARATION ---

# Read the CSV file
csv_url <- "https://raw.githubusercontent.com/knagiel/Reproducible_Research_Project/main/diabetes2.csv"

data <- read_csv(csv_url)

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

# --- DATA VISUALIZATION ---

# Define independent variables (all except 'Outcome')
independent_vars <- names(data)[!names(data) %in% "Outcome"]

# Create histograms for each independent variable
for (var in independent_vars) {
  p <- ggplot(data, aes_string(x = var, fill = "factor(Outcome)")) +
    geom_histogram(binwidth = 1, color = "white") +
    labs(x = var, y = "Count") +
    scale_fill_manual(values = c("#69b3a2", "#e9ecef"), labels = c("No Diabetes", "Diabetes"))
  
  print(p)
}

# Create boxplots for each independent variable
for (var in independent_vars) {
  p <- ggplot(data, aes_string(x = "factor(Outcome)", y = var, fill = "factor(Outcome)")) +
    geom_boxplot() +
    labs(x = "Outcome", y = var) +
    scale_fill_manual(values = c("#69b3a2", "#e9ecef"), labels = c("No Diabetes", "Diabetes"))
  
  print(p)
}

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

# --- MODEL TRAINING --- PROBIT

# Building the probit regression model
probit <- glm(Outcome ~ ., data = train, family = binomial(link = 'probit'))

# Display the model summary
cat("\nProbit Regression Model Summary:\n")
print(summary(probit))

# --- MODEL EVALUATION ---

# Predicting on the test set
predictions <- predict(probit, newdata = test, type = "response")

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
saveRDS(probit, file = "probit_reg.rds")

# --- PREDICTION ON NEW DATA ---

# User-defined data
new_data <- data.frame(Pregnancies = 5, Glucose = 0, BloodPressure = 33.7, 
                       SkinThickness = 50, Insulin = 150, BMI = 74, 
                       DiabetesPedigreeFunction = 0.5, Age = 53)

# Load the saved model
loaded_model <- readRDS("probit_reg.rds")

# Predict on new data
ourmodelprediction <- predict(loaded_model, newdata = new_data, type = 'response')
ourmodelprediction <- ifelse(ourmodelprediction > 0.5, 1, 0)

cat("\nPrediction on new data:\n")
print(ourmodelprediction)

# Creating a confusion matrix plot

# create a function to draw the confusion matrix
draw_confusion_matrix <- function(cm) {
  layout(matrix(c(1,1,2)))
  par(mar=c(2,2,2,2))
  plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
  title('CONFUSION MATRIX', cex.main=2)
  
  # create the matrix
  rect(150, 430, 240, 370, col='#3F97D0')
  text(195, 435, '0', cex=1.2)
  rect(250, 430, 340, 370, col='#F7AD50')
  text(295, 435, '1', cex=1.2)
  text(125, 370, 'Predicted', cex=1.3, srt=90, font=2)
  text(245, 450, 'Actual', cex=1.3, font=2)
  rect(150, 305, 240, 365, col='#F7AD50')
  rect(250, 305, 340, 365, col='#3F97D0')
  text(140, 400, '0', cex=1.2, srt=90)
  text(140, 335, '1', cex=1.2, srt=90)
  
  # add in the cm results
  res <- as.numeric(cm)
  text(195, 400, res[1], cex=1.6, font=2, col='white')
  text(195, 335, res[2], cex=1.6, font=2, col='white')
  text(295, 400, res[3], cex=1.6, font=2, col='white')
  text(295, 335, res[4], cex=1.6, font=2, col='white')
}

# call the function with your confusion matrix
draw_confusion_matrix(confusion_matrix)

