#!/bin/sh
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

DB_USER=test-admin-user
PGPASSWORD="Password"
HOST="127.0.0.1"
export PGPASSWORD

pathB=./backup
database=test

gunzip -c -f $pathB/$(ls -t $pathB | head -1) | psql -h $HOST -U $DB_USER -d $database

unset PGPASSWORD