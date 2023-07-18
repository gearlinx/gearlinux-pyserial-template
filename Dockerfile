FROM python:3.9-alpine

WORKDIR /usr/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py ./

CMD [ "python", "-u", "./main.py" ]
