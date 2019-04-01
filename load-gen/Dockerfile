FROM python:3.6

WORKDIR /load

COPY requirements.txt /load/

RUN pip install -r requirements.txt

COPY src/* /load/

CMD ["./entrypoint.sh"]
