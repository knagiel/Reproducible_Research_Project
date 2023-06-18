# Reproducible_Research_Project

This repository includes the contents of the project for our Reproducible Research Project. 

Team: 
Yelyzaveta Nemchynova 

Elvin Shirinov 

Kathryn Nagiel


diabetes2.csv - this csv file contains the dataset used to execute the regression models in the project and has been sourced from kaggle: https://www.kaggle.com/datasets/kandij/diabetes-dataset 

diabetics-prediction-logit-fromKaggle.ipynb - this file conains the jupyter notebook file which is referenced for the modeling. This has been sourced from kaggle: https://www.kaggle.com/code/sujithmandala/easy-diabetics-prediction-logistic-regression/notebook

logit_and_probit.R - master file which contains the model translation to R and addition of logit/probit model and visualizations in the script

logistic_reg.rds - contains logistic regression model 

probit_reg.rds - contains logit/probit model 

RR_Project_Report.Rmd - contains the report write up for the project 

RR_Project_Report.html - contains html version of rmarkdown report

Below is the list of libraries used in R: 
"gplots: 3.1.3"    "glmnet: 4.1.7"    "Matrix: 1.5.4.1"  "caret: 6.0.94"    "lattice: 0.21.8"  "lubridate: 1.9.2"
"forcats: 1.0.0"   "stringr: 1.5.0"   "dplyr: 1.1.2"     "purrr: 1.0.1"     "readr: 2.1.4"     "tidyr: 1.3.0"    
"tibble: 3.2.1"    "ggplot2: 3.4.2"   "tidyverse: 2.0.0" "stats: 4.3.1"     "graphics: 4.3.1"  "grDevices: 4.3.1"
"utils: 4.3.1"     "datasets: 4.3.1"  "methods: 4.3.1"   "base: 4.3.1"

References: 

- code to visualize the confusion matrix: https://stackoverflow.com/questions/23891140/r-how-to-visualize-confusion-matrix-using-the-caret-package
- code to build histograms and box plots: ChatGPT, prompt: 'provide code to implement in R in order to build histograms and box plots for each of the independent variable, having dataset as 'data''
