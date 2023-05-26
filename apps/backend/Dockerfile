FROM python:3.10

EXPOSE 8000
ENV API_KEY=sample_key

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY main.py .

CMD uvicorn main:app --host 0.0.0.0