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



