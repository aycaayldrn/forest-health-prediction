import os
import pandas as pd
from sklearn.preprocessing import StandardScaler, MinMaxScaler


def detect_column_types(df):
    numeric_columns = df.select_dtypes(include=['float64', 'int64']).columns.tolist()
    categorical_columns = df.select_dtypes(include=['object']).columns.tolist()

    date_columns = []
    for col in categorical_columns:
        try:
            pd.to_datetime(df[col])
            date_columns.append(col)
        except (ValueError, TypeError):
            pass

    categorical_columns = [col for col in categorical_columns if col not in date_columns]

    return numeric_columns, categorical_columns, date_columns


def normalize_numeric(df, columns, method="minmax"):
    if method == "minmax":
        scaler = MinMaxScaler()
        df[columns] = scaler.fit_transform(df[columns])
        print(f"Min-Max scaling applied to columns: {columns}")
    elif method == "zscore":
        scaler = StandardScaler()
        df[columns] = scaler.fit_transform(df[columns])
        print(f"Z-score normalization applied to columns: {columns}")
    else:
        print(f"Unknown method '{method}'. Please use 'minmax' or 'zscore'.")

    return df


def standardize_categorical(df, columns):
    for col in columns:
        df[col] = df[col].str.lower().str.strip()
        print(f"Categorical column '{col}' standardized to lowercase.")

    return df


# I don't have date column in my dataset, but I added it anyway just in case
def format_date_column(df, columns, date_format="%Y-%m-%d"):
    for col in columns:
        df[col] = pd.to_datetime(df[col], errors='coerce').df.strftime(date_format)
        print(f"Date column '{col}' formatted to {date_format}")

    return df


data_path = os.path.join(os.path.dirname(__file__), "../data/forest_health_data_modified.csv")

if __name__ == "__main__":
    df = pd.read_csv(data_path)

    numeric_columns, categorical_columns, date_columns = detect_column_types(df)
    print("Detected numeric columns:", numeric_columns)
    print("Detected categorical columns:", categorical_columns)
    print("Detected date columns:", date_columns)

    df = normalize_numeric(df, numeric_columns, method="minmax")
    df = standardize_categorical(df, categorical_columns)
    df = format_date_column(df, date_columns)

    standardized_data_path = os.path.join(os.path.dirname(__file__), "../data/forest_health_data_standardized.csv")
    df.to_csv(standardized_data_path, index=False)
    print("Data standardization completed and saved.")
