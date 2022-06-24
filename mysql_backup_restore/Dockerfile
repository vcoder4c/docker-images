FROM python:3.9-alpine

RUN apk add --no-cache --virtual .build-deps musl-dev gcc \
    && apk add --no-cache bash tzdata mysql-client \
    && pip install --no-cache-dir awscli \
    && pip install --no-cache-dir dumb-init \
    && apk del --no-cache .build-deps

ENV MYSQLDUMP_OPTIONS --quote-names --quick --add-drop-table --add-locks --allow-keywords --disable-keys --extended-insert --single-transaction --create-options --comments --net_buffer_length=16384
ENV MYSQL_HOST **None**
ENV MYSQL_PORT 3306
ENV MYSQL_USER **None**
ENV MYSQL_PASSWORD **None**
ENV MYSQL_DB **None**
ENV MYSQL_RESTORE_DB **None**

ENV S3_ACCESSKEYID **None**
ENV S3_SECRETACCESSKEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION **None**
ENV S3_S3V4 no
ENV S3_PREFIX 'backup'

ENV CRON_PATTERN '* * * * *'
ENV TIMEZONE 'Asia/Ho_Chi_Minh'

ADD backup.sh /bin/backup.sh
ADD restore.sh /bin/restore.sh
ADD docker-entrypoint.sh /bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["cron"]
