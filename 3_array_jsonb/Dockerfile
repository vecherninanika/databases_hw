FROM python:3.10.12

WORKDIR /flask_7.1

COPY array_jsonb.py .
COPY requirements.txt .
COPY ./static/index.html ./static/

RUN pip install -r requirements.txt

CMD ["python3", "-m", "flask", "--app", "array_jsonb.py", "run", "--host", "0.0.0.0"]
