import pandas as pd
from data_cleaning.db_connection import connect_to_db


def update_database(df, table_name, id_column):
    conn = connect_to_db()
    if conn is None:
        print("Connection failed")
        return

    try:
        cursor = conn.cursor()

        columns = [col for col in df.columns if col != id_column]
        set_clause = ", ".join([f"{col} = %s" for col in columns])

        update_query = f"UPDATE {table_name} SET {set_clause} WHERE {id_column} = %s"

        for i, row in df.iterrows():
            values = tuple(row[col] for col in columns)  # Values to update
            id_value = row[id_column]  # Unique identifier value
            cursor.execute(update_query, (*values, id_value))

        conn.commit()
        print("Database update successful.")
    except Exception as e:
        print("Error updating database:", e)
        conn.rollback()
    finally:
        cursor.close()
        conn.close()


if __name__ == "__main__":
    standardized_df = pd.read_csv("data/forest_health_data_modified.csv")
    update_database(standardized_df, "forest_health", "Plot_ID")
