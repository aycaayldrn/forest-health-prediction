import pandas as pd
from data_cleaning.db_connection import connect_to_db


# updates table with data from a df by matching rows based on id column.
# dynamically constructs an update sql query to modify only specified columns in each row
# rollback changes if an issue occurs, ensuring data integrity
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
            try:
                values = tuple(row[col] for col in columns)
                id_value = row[id_column]
                cursor.execute(update_query, (*values, id_value))
            except Exception as e:
                print(f"Error updating row with {id_column}={id_value}: {e}")
                conn.rollback()
        conn.commit()
        print("Database update successful.")
    except Exception as ex:
        print(f"Error updating database: {ex}")
        conn.rollback()
    finally:
        try:
            cursor.close()
            conn.close()
        except Exception as e:
            print(f"Error closing database connection: {e}")


if __name__ == "__main__":
    try:
        standardized_df = pd.read_csv("data/forest_health_data_standardized.csv")
        update_database(standardized_df, "forest_health", "Plot_ID")
    except FileNotFoundError as e:
        print(f"File not found: {e}")
    except Exception as e:
        print(f"Error occured: {e}")