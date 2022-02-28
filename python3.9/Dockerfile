FROM python:3.9.9-slim

RUN apt update && apt install -y gcc \
    && apt install -y default-libmysqlclient-dev cron \
    && pip install --no-cache-dir uwsgi \
    && pip install --no-cache-dir dumb-init \
    && pip install --no-cache-dir cryptography==3.4.8 \
    && pip install --no-cache-dir mysqlclient==2.0.3 \
    && apt remove -y gcc && apt clean && apt autoremove --purge -y \
    && rm -rf /var/lib/apt

RUN touch /var/log/cron.log
