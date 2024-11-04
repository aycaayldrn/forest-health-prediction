import pandas as pd
from db_connection import connect_to_db


def load_csv_to_db(csv_path, table_name):
    connection = connect_to_db()
    if connection is None:
        print("Connection failed")
        return

    df = pd.read_csv(csv_path)

    try:
        df.to_sql(table_name, connection, if_exists='replace', index=False, method='multi')
        print(f"Data loaded successfully into table '{table_name}'")
    except Exception as e:
        print("Error loading data", e)
    finally:
        connection.close()

    if __name__ == "__main__":
        csv_path = 'data/forest_health_data.csv'
        table_name = 'forest_health'
        load_csv_to_db(csv_path, table_name)
