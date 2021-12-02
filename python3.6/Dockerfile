FROM python:3.6-alpine

RUN apk add --no-cache --virtual .build-deps pcre-dev \
    mariadb-dev gcc libc-dev musl-dev python3-dev \
    libffi-dev openssl-dev cargo build-base linux-headers \
    busybox-initscripts \
    && apk add --no-cache mariadb-connector-c pcre \
    && pip install --no-cache-dir uwsgi \
    && pip install --no-cache-dir dumb-init \
    && pip install --no-cache-dir channels_redis==3.2.0 \
    && pip install --no-cache-dir cryptography==3.4.7 \
    && pip install --no-cache-dir mysqlclient==2.0.3 \
    && apk del --no-cache .build-deps
