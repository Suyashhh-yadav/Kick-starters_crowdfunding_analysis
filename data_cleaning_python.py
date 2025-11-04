import pandas as pd
import mysql.connector

# ---------- Step 1: Load CSV ----------
input_file = r"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cf_projects_clean2.csv"

# Safe reading with quoting and skip bad lines
df = pd.read_csv(input_file, dtype=str, quoting=1, on_bad_lines='skip')
df.columns = df.columns.str.strip()

# ---------- Step 2: Ensure all expected columns ----------
expected_cols = [
    'id','state','name','country','creator_id','location_id','category_id',
    'goal','pledged','currency','usd_pledged','static_usd_rate','backers_count',
    'created_at2','deadline','Updated_at2','state_changed_at3','successful_at4','launched_at5'
]
for col in expected_cols:
    if col not in df.columns:
        df[col] = None
df = df[expected_cols]

# ---------- Step 3: Clean data ----------
# Numeric columns
numeric_cols = ['id','creator_id','location_id','category_id','goal','pledged',
                'usd_pledged','static_usd_rate','backers_count']
for col in numeric_cols:
    df[col] = pd.to_numeric(df[col].astype(str).str.replace(r'[^\d.]', '', regex=True), errors='coerce')

# Date columns (ddmmyy → YYYY-MM-DD)
date_cols = ['created_at2','deadline','Updated_at2','state_changed_at3','successful_at4','launched_at5']
for col in date_cols:
    if col in df.columns:
        df[col] = pd.to_datetime(df[col], format='%d%m%y', errors='coerce')
        df[col] = df[col].dt.strftime('%Y-%m-%d')

# Text columns
text_cols = ['state','name','country','currency']
for col in text_cols:
    df[col] = df[col].apply(lambda x: str(x).replace('\n',' ').replace('\r',' ') if pd.notnull(x) else None)

# ✅ Replace NaN with None so MySQL sees NULL instead of 'nan'
df = df.where(pd.notnull(df), None)

# ✅ Rename deadline to deadline2 (to match MySQL table column)
df.rename(columns={"deadline": "deadline2"}, inplace=True)

# ---------- Step 4: Connect to MySQL ----------
conn = mysql.connector.connect(
    host='localhost',
    user='root',           # <-- change to your MySQL username
    password='root1234',   # <-- change to your MySQL password
    database='crowdfunding_project'
)
cursor = conn.cursor()

# ---------- Step 5: Insert rows ----------
insert_query = """
INSERT INTO cf_project (
    id,state,name,country,creator_id,location_id,category_id,
    goal,pledged,currency,usd_pledged,static_usd_rate,backers_count,
    created_at2,deadline2,Updated_at2,state_changed_at3,successful_at4,launched_at5
) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
"""

batch_size = 50000
for index, row in df.iterrows():
    cursor.execute(insert_query, tuple(row))
    if index % batch_size == 0 and index > 0:
        conn.commit()
        print(f"Committed {index} rows...")

conn.commit()
cursor.close()
conn.close()
print("✅ All data inserted successfully!")


