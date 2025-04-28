import pandas as pd
from scipy.stats import zscore
from db_connection import connect_to_db


def fetch_data(table_name):
    conn = connect_to_db()
    if conn is None:
        print("Connection failed")
        return None

    query = f"SELECT * FROM {table_name};"
    try:
        df = pd.read_sql(query, conn)
        print("Data fetched successfully")
        return df
    except Exception as e:
        print("Error fetching data: ", e)
        return None
    finally:
        conn.close()


# delete the rows with duplicates
def detect_duplicates(df):
    duplicate_count = df.duplicated().sum()
    print(f"\nNumber of duplicate rows detected: {duplicate_count}")
    if duplicate_count > 0:
        print("Duplicates will be removed.")
        df.drop_duplicates(inplace=True)
    else:
        print("No duplicate rows found.")


# detects outliers with 2 methods: iqr and z-score
def detect_outliers(df, method='iqr'):
    print("\nDetecting outliers:")
    outliers_info = {}
    for column in df.select_dtypes(include=['float64', 'int64']).columns:
        if method == 'iqr':
            Q1 = df[column].quantile(0.25)
            Q3 = df[column].quantile(0.75)
            IQR = Q3 - Q1

            lower_bound = Q1 - 1.5 * IQR
            upper_bound = Q3 + 1.5 * IQR

            lower_outliers = df[df[column] < lower_bound].shape[0]
            upper_outliers = df[df[column] > upper_bound].shape[0]
            total_outliers = lower_outliers + upper_outliers

            outliers_info[column] = {'lower_outliers': lower_outliers,
                                     'upper_outliers': upper_outliers,
                                     'total_outliers': total_outliers}

            print(f"Column '{column}': {total_outliers} outliers detected "
                  f"({lower_outliers} below, {upper_outliers} above the thresholds).")

        elif method == 'zscore':
            z_scores = zscore(df[column].dropna())
            outliers = (z_scores > 3) | (z_scores < -3)
            total_outliers = outliers.sum()

            outliers_info[column] = {
                'method': 'Z-score',
                'total_outliers': total_outliers
            }
            print(f"Column '{column}' (Z-score): {total_outliers} outliers detected.")

    return outliers_info


# checks if column can be converted to numeric, then if fails checks for type datetime,
# if fails it assumed to be categorical
def check_data_types(df):
    print("\nAutomatically checking and correcting data types:")

    for column in df.columns:
        current_type = df[column].dtype

        if pd.api.types.is_object_dtype(current_type):
            try:
                df[column] = pd.to_numeric(df[column], errors='raise')
                print(f"Column '{column}' converted to numeric type ({df[column].dtype}).")
            except ValueError:
                try:
                    df[column] = pd.to_datetime(df[column], errors='raise')
                    print(f"Column '{column}' converted to datetime.")
                except ValueError:
                    unique_values = df[column].nunique()
                    total_values = len(df[column])

                    if unique_values / total_values < 0.1:
                        df[column] = df[column].astype('category')
                        print(f"Column '{column}' converted to categorical type.")
                    else:
                        print(f"Column '{column}' left as object/string type.")
        elif pd.api.types.is_float_dtype(current_type):
            if (df[column] == df[column].astype(int)).all():
                df[column] = df[column].astype(int)
                print(f"Column '{column}' converted from float to integer type.")

    return df


# deletes the rows with missing values and runs outlier, duplicate, type checking methods respectively
def clean_data(df, outlier_method='iqr'):
    missing_count = df.isnull().sum().sum()
    print(f"Total missing values in the dataset: {missing_count}")

    if missing_count > 0:
        print("Rows with missing values will be removed.")

        rows_before = df.shape[0]
        df.dropna(inplace=True)
        rows_after = df.shape[0]
        rows_removed = rows_before - rows_after

        print(f"Number of rows removed: {rows_removed}")
        print(f"Data shape after removing rows with missing values: {df.shape}")
    else:
        print("No missing values found.")

    outliers_info = detect_outliers(df, method=outlier_method)
    print("\nOutliers summary:", outliers_info)

    detect_duplicates(df)
    df = check_data_types(df)

    return df


if __name__ == "__main__":
    table_name = 'forest_health'
    df = fetch_data(table_name)

    if df is not None:
        cleaned_df = clean_data(df, outlier_method='zscore')
        print("Cleaned data preview:")
        print(cleaned_df.head())
