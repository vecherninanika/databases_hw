from flask import Flask, jsonify
import psycopg2
from psycopg2.extras import RealDictCursor
from psycopg2.sql import SQL, Literal
import logging
import os
from dotenv import load_dotenv

load_dotenv()

master_parameters = {
    'host': os.getenv('MASTER_HOST') or 'localhost',
    'port': os.getenv('MASTER_PORT'),
    'database': os.getenv('POSTGRES_DB'),
    'user': os.getenv('MASTER_USER'),
    'password': os.getenv('MASTER_PASSWORD')
}

for key in master_parameters:
    if master_parameters[key] is None:
        logging.error(f'{key} is None')


replica_parameters = {
    'host': os.getenv('REPL_HOST') or 'localhost',
    'port': os.getenv('REPL_PORT'),
    'database': os.getenv('POSTGRES_DB'),
    'user': os.getenv('MASTER_USER'),
    'password': os.getenv('MASTER_PASSWORD')
}

for key in replica_parameters:
    if replica_parameters[key] is None:
        logging.error(f'{key} is None')


def connect_to_master():
    conn = psycopg2.connect(**master_parameters, cursor_factory=RealDictCursor)
    conn.autocommit = True
    return conn


def connect_to_replica():
    conn = psycopg2.connect(**replica_parameters, cursor_factory=RealDictCursor)
    conn.autocommit = True
    return conn


app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False


@app.route('/replica')
def replica():
    try:
        query = SQL("select * from person")

        with connect_to_replica() as conn, conn.cursor() as cur:
            cur.execute(query)
            persons = cur.fetchall()
        return jsonify(list(map(lambda row: row['name'], persons)))
    except Exception as ex:
        logging.error(repr(ex), exc_info=True)
        return {'message': repr(ex)}, 400
