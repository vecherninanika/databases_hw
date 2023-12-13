FROM python:3.10.12

WORKDIR /flask_7.1

COPY materialized_view.py .
COPY requirements.txt .

RUN pip install -r requirements.txt

CMD ["python3", "-m", "flask", "--app", "materialized_view.py", "run", "--host", "0.0.0.0"]
