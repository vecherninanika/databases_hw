from flask import Flask, jsonify, request, send_file
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
    conn = psycopg2.connect(**pg_connection_parameters, cursor_factory=RealDictCursor)
    conn.autocommit = True
    return conn


app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False


@app.route('/')
def autocomplete_page():
    try:
        return send_file('static/autocomplete.html')
    except Exception as ex:
        logging.error(repr(ex), exc_info=True)
        return {'message': 'Bad Request'}, 400


@app.route('/autocomplete')
def autocomplete():
    word = request.args.get('word')
    try:
        query = SQL("select * from task where task %> {word}").format(word=Literal(word))

        with create_pg_connection() as conn, conn.cursor() as cur:
            cur.execute(query)
            tasks = cur.fetchall()
        return jsonify(list(map(lambda row: row['task'], tasks)))
    except Exception as ex:
        logging.error(repr(ex), exc_info=True)
        return {'message': 'Bad Request'}, 400


@app.route('/levenshtein', methods=['GET', 'POST'])
def levenshtein():
    if request.method == 'POST':
        word = request.form.get('word')
        try:
            query = SQL('select * from task where levenshtein(task, {word}) <=2').format(word=Literal(word))

            with create_pg_connection() as conn, conn.cursor() as cur:
                cur.execute(query)
                tasks = cur.fetchall()
            return jsonify(list(map(lambda row: row['task'], tasks)))
        except Exception as ex:
            logging.error(repr(ex), exc_info=True)
            return {'message': 'Bad Request'}, 400
    return send_file('static/levenshtein.html')
