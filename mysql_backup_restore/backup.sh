#!/bin/bash
set -e

if [ "${S3_ACCESSKEYID}" = "**None**" ]; then
  echo "Warning: You did not set the S3_ACCESSKEYID environment variable."
  exit 1
fi

if [ "${S3_SECRETACCESSKEY}" = "**None**" ]; then
  echo "Warning: You did not set the S3_SECRETACCESSKEY environment variable."
  exit 1
fi

if [ "${S3_REGION}" = "**None**" ]; then
  echo "Warning: You did not set the S3_REGION environment variable."
  exit 1
fi

if [ "${S3_BUCKET}" = "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ "${S3_PREFIX}" = "**None**" ]; then
  echo "You need to set the S3_PREFIX environment variable."
  exit 1
fi

export AWS_ACCESS_KEY_ID=$S3_ACCESSKEYID
export AWS_SECRET_ACCESS_KEY=$S3_SECRETACCESSKEY
export AWS_DEFAULT_REGION=$S3_REGION

if [ "${MYSQL_HOST}" = "**None**" ]; then
  echo "You need to set the MYSQL_HOST environment variable."
  exit 1
fi

if [ "${MYSQL_USER}" = "**None**" ]; then
  echo "You need to set the MYSQL_USER environment variable."
  exit 1
fi

if [ "${MYSQL_PASSWORD}" = "**None**" ]; then
  echo "You need to set the MYSQL_PASSWORD environment variable."
  exit 1
fi

if [ "${MYSQL_DB}" = "**None**" ]; then
  echo "You need to set the MYSQL_DB environment variable."
  exit 1
fi

if [ "${S3_S3V4}" = "yes" ]; then
    aws configure set default.s3.signature_version s3v4
fi

MYSQL_HOSTOPTS="-h $MYSQL_HOST -P $MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD"
DUMPTIME=$(date +"%Y-%m-%dT%H%M%SZ")
echo "Creating dump for ${MYSQL_DB} from ${MYSQL_HOST}..."

DUMP_FILE="/tmp/dump_${MYSQL_DB}.sql.gz"
#run mysql dump
mysqldump $MYSQL_HOSTOPTS $MYSQLDUMP_OPTIONS $MYSQL_DB | gzip > $DUMP_FILE

# upload to s3
S3_FILE="${DUMPTIME}.${MYSQL_DB}.sql.gz"
S3_URI=s3://$S3_BUCKET/$S3_PREFIX/$S3_FILE
echo "Uploading ${S3_FILE} on S3..."
cat $DUMP_FILE | aws $AWS_ARGS s3 cp - $S3_URI
if [ $? != 0 ]; then
  >&2 echo "Error uploading ${S3_FILE} on S3"
fi
rm $DUMP_FILE
echo "MySQL backup finished"
