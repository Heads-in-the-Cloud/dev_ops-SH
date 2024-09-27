#!/bin/bash

yum update -y
yum install -y vim mysql

aws s3 cp s3://sh-utopia-bucket/schema.sql .
mysql -h "${DB_ENDPOINT}" -u "${DB_USERNAME}" -p "${DB_PASSWORD}" < schema.sql

poweroff
