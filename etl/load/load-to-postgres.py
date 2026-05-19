import json
import psycopg2
import os
from dotenv import load_dotenv
from pathlib import Path

# Load .env from project root (two levels up from this script)
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

wait_times = data['figure_91']['data']
for item in wait_times:
    cur.execute("""
        UPDATE agg_wait_times 
        SET median_wait_weeks = %s, is_significant = %s
        FROM dim_region 
        WHERE dim_region.region_id = agg_wait_times.region_id 
        AND dim_region.region_name = %s
    """, (item['median_weeks'], item['significant'], item['region']))

conn.commit()
print("Loaded wait times for", len(wait_times), "regions")

cur.close()
conn.close()