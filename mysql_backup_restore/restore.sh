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

if [ "${MYSQL_RESTORE_DB}" = "**None**" ]; then
  echo "You need to set the MYSQL_RESTORE_DB environment variable."
  exit 1
fi

if [ "${S3_S3V4}" = "yes" ]; then
    aws configure set default.s3.signature_version s3v4
fi

S3_URI=s3://$S3_BUCKET/$S3_PREFIX
echo "Searching last Backup in ${S3_URI} for database ${MYSQL_DB}"
S3_FILE=$(aws s3 ls ${S3_URI}/ | grep -i -E "($MYSQL_DB.sql.gz)" | sort | tail -n 1 | awk '{print $4}')
if [ "${S3_FILE}" = "" ]; then
  echo "Can not find restore file at ${S3_URI} for ${MYSQL_RESTORE_DB}"
  exit 1
fi

RESTORE_FILE="/tmp/restore_${MYSQL_DB}.sql.gz"
echo "Downloading ${S3_FILE} from S3..."
aws s3 cp $S3_URI/$S3_FILE $RESTORE_FILE

echo "Restoring from $S3_URI/$S3_FILE to ${MYSQL_RESTORE_DB}"
MYSQL_HOSTOPTS="-h $MYSQL_HOST -P $MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD"
mysql $MYSQL_HOSTOPTS -e "DROP DATABASE IF EXISTS ${MYSQL_RESTORE_DB};"
mysql $MYSQL_HOSTOPTS -e "CREATE DATABASE ${MYSQL_RESTORE_DB};"
zcat $RESTORE_FILE | mysql $MYSQL_HOSTOPTS ${MYSQL_RESTORE_DB}
rm $RESTORE_FILE
echo "MySQL restore finished"
