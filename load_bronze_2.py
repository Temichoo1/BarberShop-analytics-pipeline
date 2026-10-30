import os

import pandas as pd
import pyodbc
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

SQL_SERVER = os.getenv("SQL_SERVER", r"TEMITOPE\SQLEXPRESS")
SQL_DATABASE = os.getenv("SQL_DATABASE", "BarberShopAnalytics")
SQL_DRIVER = os.getenv("SQL_DRIVER", "ODBC Driver 17 for SQL Server")


# Files to be loaded into the database
DATA_FILES = {
    "customers": {
        "file_path": "data/raw/customers.csv",
        "table_name": "bronze.customers_raw",
    },
    "barbers": {
        "file_path": "data/raw/barbers.csv",
        "table_name": "bronze.barbers_raw",
    },
    "branches": {
        "file_path": "data/raw/branches.csv",
        "table_name": "bronze.branches_raw",
    },
    "services": {
        "file_path": "data/raw/services.csv",
        "table_name": "bronze.services_raw",
    },
    "bookings": {
        "file_path": "data/raw/bookings.csv",
        "table_name": "bronze.bookings_raw",
    },
    "payments": {
        "file_path": "data/raw/payments.csv",
        "table_name": "bronze.payments_raw",
    },
}


def get_connection():
    connection_string = (
        f"DRIVER={{{SQL_DRIVER}}};"
        f"SERVER={SQL_SERVER};"
        f"DATABASE={SQL_DATABASE};"
        "Trusted_Connection=yes;"
    )
    return pyodbc.connect(connection_string)

def truncate_table(table_name: str):
    print(f"Truncating table: {table_name}")
    with get_connection() as conn:
        cursor = conn.cursor()
        cursor.execute(f"TRUNCATE TABLE {table_name}")
        conn.commit()


def load_csv_to_bronze(file_path, table_name):
    print(f"Loading {file_path} into {table_name}")

    df = pd.read_csv(file_path, dtype=str)

    df["source_file_name"] = os.path.basename(file_path)
    
    # Convert missing values to SQL NULL-compatible Python values
    df = df.astype(object).where(pd.notna(df), None)

    rows = list(df.itertuples(index=False, name=None))

    df = df.where(pd.notnull(df), None)

    columns = list(df.columns)
    column_list = ", ".join(columns)
    placeholders = ", ".join(["?"] * len(columns))

    insert_sql = f"""
        INSERT INTO {table_name} ({column_list})
        VALUES ({placeholders})
    """

    rows = df.values.tolist()

    with get_connection() as conn:
        cursor = conn.cursor()
        #cursor.fast_executemany = True
        #cursor.executemany(insert_sql, rows) 
        #conn.commit()
        cursor.fast_executemany = False

    for row_number, row in enumerate(rows, start=1):
        try:
            

            cursor.execute(insert_sql, row)
        except Exception as e:
            print(f"\nFailed at CSV data row: {row_number}")
            print(f"Error: {e}")

            for position, (column, value) in enumerate(
                zip(columns, row), start=1
            ):
                print(f"Parameter {position}: {column} = {value!r}")

            raise

    conn.commit()

        
        

    print(f"Loaded {len(df)} rows into {table_name}")


def main():
    for source_name, config in DATA_FILES.items():
        truncate_table(config["table_name"])
        load_csv_to_bronze(
            file_path=config["file_path"],
            table_name=config["table_name"],
        )


if __name__ == "__main__":
    main()
