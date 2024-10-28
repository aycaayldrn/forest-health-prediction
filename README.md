# Forest Health Data Cleaning and Standardization

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
