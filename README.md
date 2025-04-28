# Forest Health Data Cleaning, Standardization and Model Training

This project focuses on preparing a dataset related to forest health monitoring. The dataset sourced from Kaggle's Forest Health and Ecological Diversity dataset. 

The main goal of this task is to clean, preprocess, and standardize the data to ensure it is ready for further analysis and machine learning applications.

## How to set up the environment locally
1. Make sure you have PostgreSQL installed.

### 1. Set Up the Configuration File
- Copy `config.template.json` to create `config.json`:
  ```sh
  cp config.template.json config.json
- Open `confij.json` and enter the database credentials.It should look like this:
  ```sh
  {
    "host": "your_database_host",
    "port": 5432,
    "database": "your_database_name",
    "user": "your_username",
    "password": "your_password"
  }
### 2. Connect to the database
 - Use DataGrip or another database client:
     - Open your database tool
     - Enter credentials from `config.json` to connect to the database

### 3. Run SQL Scripts
 - In your chosen SQL editor, navigate to the `data_cleaning` folder in the project where the SQL files are stored.
 - Run the following scripts in order:
     - `create_table.sql`: This script creates the necessary tables in the database.
     - `data_cleaning_handler.sql`: This script performs data cleaning tasks, such as checking for outliers and verifying data types.
=======
# Forest Health Prediction

This project aims to predict forest health status based on environmental and tree-specific data, combining data cleaning, standardization, and machine learning techniques.

## Overview

- **Data Cleaning and Standardization:** 
    - Handled missing values and inconsistent data.
    - Automatically detected numeric, categorical, and date columns.
    - Applied Min-Max normalization to numeric features and standardized categorical values.
    - Provided a reusable data preparation script (`data_standardization.py`).

- **Machine Learning Model Training:**
    - Trained Logistic Regression, Decision Tree, and Random Forest classifiers.
    - Performed hyperparameter tuning using GridSearchCV.
    - Balanced dataset classes using SMOTE and weighted random forests.
    - Evaluated model performance with accuracy, precision, recall, F1-score, and confusion matrices.
    - Visualized feature importances and model comparison results.

- **Performance:**
    - Achieved approximately **66%** overall accuracy with optimized Random Forest.
    - SMOTE balancing and weighted classification techniques improved model robustness.

## Technologies Used

- Python (Pandas, NumPy)
- scikit-learn (Machine Learning)
- imbalanced-learn (SMOTE)
- Seaborn, Matplotlib (Visualization)

## How to Run

1. Clone this repository.

2. Standardize the data:
    ```bash
    python data_standardization/data_standardization.py
    ```

3. Load the standardized data into the database (PostgreSQL required):
    ```bash
    python data_cleaning/load_data.py
    ```

4. Train and evaluate machine learning models:
    ```bash
    python predictions/model_evaluation.py
    ```

> ⚠️ **Important:**  
> Ensure your PostgreSQL database credentials are correctly set inside `data_cleaning/config.json`.
