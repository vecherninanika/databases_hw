FROM python:3.10.12

WORKDIR /Master

COPY main.py .
COPY requirements.txt .

RUN pip install -r requirements.txt

CMD ["python3", "-m", "flask", "--app", "main.py", "run", "--host", "0.0.0.0"]
