from flask import Flask
import psycopg2
from psycopg2.extras import RealDictCursor
import logging
import os
from dotenv import load_dotenv
load_dotenv()


pg_connection_parameters = {
    'host': os.getenv('POSTGRES_HOST') or 'localhost',
    'port': os.getenv('POSTGRES_PORT'),
    'database': os.getenv('POSTGRES_DB'),
    'user': os.getenv('POSTGRES_USER'),
    'password': os.getenv('POSTGRES_PASSWORD')
}


for key in pg_connection_parameters:
    if pg_connection_parameters[key] is None:
        logging.error(f'{key} is None')


def create_pg_connection():
    conn = psycopg2.connect(**pg_connection_parameters,
                            cursor_factory=RealDictCursor)
    conn.autocommit = True
    return conn


app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False



@app.route("/topic_with_tasks")
def get_topic_with_tasks():
    try:
        query = "select * from tasks_view"
        with create_pg_connection() as conn, conn.cursor() as cur:
            cur.execute(query)
            topic_with_tasks = cur.fetchall()

        return topic_with_tasks
    except Exception as ex:
        logging.error(ex, exc_info=True)
        return '', 400
