import pandas as pd

df = pd.read_csv(r"data\raw\bookings.csv", dtype=str)



# Convert booking_datetime to a proper datetime object
if "booking_datetime" in df.columns:
    df["booking_datetime"] = pd.to_datetime(
        df["booking_datetime"],
        errors="coerce"
    )

# Convert pandas missing values (NaN/NaT) to Python None
df = df.astype(object).where(pd.notna(df), None)

# Prepare column names and SQL placeholders
columns = list(df.columns)

column_list = ", ".join(
    f"[{column.replace(']', ']]')}]"
    for column in columns
)

placeholders = ", ".join(["?"] * len(columns))

insert_sql = f"""
    INSERT INTO {table_name} ({column_list})
    VALUES ({placeholders})
"""

rows = list(df.itertuples(index=False, name=None))