from flask import Flask, request, render_template, send_file
import psycopg2
from psycopg2.extras import RealDictCursor
from psycopg2.sql import SQL, Literal
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



@app.route("/jsonb", methods=['GET', 'POST'])
def jsonb():
    if request.method == 'POST':
        field = request.form.get('field')
        value = request.form.get('value')

        query = """
                select *
                from person_2
                where telegram @> '[{"%s": "%s"}]';
                """ % (field, value)
        try:
            with create_pg_connection() as conn, conn.cursor() as cur:
                cur.execute(query)
                person_2 = cur.fetchall()

            return person_2
        except Exception as ex:
            logging.error(ex, exc_info=True)
            return ex, 400
    return send_file('static/index.html')


@app.route("/array", methods=['GET', 'POST'])
def array():
    if request.method == 'POST':
        field = request.form.get('field')
        value = request.form.get('value')

        query = """
                select *
                from task_2
                where %s && array ['%s'];
                """ % (field, value)
        try:
            with create_pg_connection() as conn, conn.cursor() as cur:
                cur.execute(query)
                task_2 = cur.fetchall()

            return task_2
        except Exception as ex:
            logging.error(ex, exc_info=True)
            return ex, 400
    return send_file('static/index.html')
