FROM python:3.9.9-slim

# TA-lib is required by the python TA-lib wrapper. This provides analysis.
COPY ta-lib-0.4.0-src.tar.gz /tmp/ta-lib-0.4.0-src.tar.gz

RUN apt update \
    && apt install -y gcc python3-dev default-libmysqlclient-dev build-essential make cron \
    && cd /tmp && tar -xvzf ta-lib-0.4.0-src.tar.gz && cd ta-lib/ \
    && ./configure --prefix=/usr && make && make install \
    && pip install --no-cache-dir uwsgi \
    && pip install --no-cache-dir dumb-init \
    && pip install --no-cache-dir cryptography==3.4.8 \
    && pip install --no-cache-dir mysqlclient==2.0.3 \
    && pip install --no-cache-dir numpy==1.21.4 \
    && pip install --no-cache-dir pandas==1.3.4 \
    && pip install --no-cache-dir TA-Lib==0.4.21 \
    && pip install --no-cache-dir matplotlib==3.5.0
