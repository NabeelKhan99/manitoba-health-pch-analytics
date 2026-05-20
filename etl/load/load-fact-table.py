import json
import psycopg2
import os
from dotenv import load_dotenv
from pathlib import Path

env_path = Path(__file__).parent.parent.parent / '.env'
load_dotenv(dotenv_path=env_path)

conn = psycopg2.connect(
    host=os.getenv('POSTGRES_HOST'),
    port=os.getenv('POSTGRES_PORT'),
    database=os.getenv('POSTGRES_DB'),
    user=os.getenv('POSTGRES_USER'),
    password=os.getenv('POSTGRES_PASSWORD')
)
cur = conn.cursor()

with open('etl/extract/figures-89-92.json', 'r') as f:
    data = json.load(f)

region_map = {}
cur.execute("SELECT region_id, region_name FROM dim_region")
for row in cur.fetchall():
    region_map[row[1]] = row[0]

care_level_map = {
    'Level_2N': 1,
    'Level_2Y': 2,
    'Level_3N': 3,
    'Level_3Y': 4,
    'Level_4': 5
}

cur.execute("SELECT time_id FROM dim_time WHERE fiscal_year = '2019-2020'")
time_id = cur.fetchone()[0]

figure_90_data = data['figure_90']['data']

for region_data in figure_90_data:
    region_name = region_data['region']
    if region_name not in region_map:
        print(f"Region {region_name} not found in dim_region, skipping")
        continue
    
    region_id = region_map[region_name]
    
    for level_code, percentage in region_data.items():
        if level_code == 'region':
            continue
        
        if level_code not in care_level_map:
            print(f"Care level {level_code} not recognized, skipping")
            continue
            
        percentage_value = percentage
        care_level_id = care_level_map[level_code]
        
        cur.execute("SELECT population_75_plus FROM dim_region WHERE region_id = %s", (region_id,))
        result = cur.fetchone()
        if result is None:
            continue
        population = result[0]
        
        admission_rate = 2.9
        for item in data['figure_89']['data']:
            if item['region'] == region_name:
                admission_rate = item['admission_rate']
                break
        
        total_admissions = int(round(population * (admission_rate / 100)))
        
        cur.execute("""
            INSERT INTO fact_pch_admissions 
            (region_id, care_level_id, time_id, admission_source, total_admissions, percentage_of_region)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (region_id, care_level_id, time_id, 'All sources', total_admissions, percentage_value))

conn.commit()

cur.execute("SELECT COUNT(*) FROM fact_pch_admissions")
count = cur.fetchone()[0]
print(f"Loaded {count} rows into fact_pch_admissions")

cur.close()
conn.close()