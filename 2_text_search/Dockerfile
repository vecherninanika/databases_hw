FROM python:3.10.12

WORKDIR /flask_7.1

COPY text_search.py .
COPY requirements.txt .
COPY ./static/autocomplete.html ./static/
COPY ./static/levenshtein.html ./static/

RUN pip install -r requirements.txt

CMD ["python3", "-m", "flask", "--app", "text_search.py", "run", "--host", "0.0.0.0"]
