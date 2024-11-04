import json
import psycopg2
import os

config_path = os.path.join(os.path.dirname(__file__), 'config.json')
with open(config_path) as f:
    config = json.load(f)


def connect_to_db():
    try:
        conn = psycopg2.connect(
            host=config['host'],
            port=config['port'],
            database=config['database'],
            user=config['user'],
            password=config['password']
        )
        print("Connected to database successfully")
        return conn
    except Exception as e:
        print("Error connecting to the database: ", e)
        return None


if __name__ == "__main__":
    connect_to_db()