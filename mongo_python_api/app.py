from flask import Flask
from pymongo import MongoClient

client = MongoClient('mongodb://mongo@mongo:localhost:37112/')

@app.route('/')
def hello_world():
    movie_details = client.sirius;