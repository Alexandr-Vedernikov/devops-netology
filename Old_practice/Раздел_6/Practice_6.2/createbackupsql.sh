#!/bin/sh
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

DB_USER=test-admin-user
PGPASSWORD="Password"
HOST="127.0.0.1"
export PGPASSWORD

pathB=./backup
database=test_db

find $pathB \( -name "*-1[^5].*" -o -name "*-[023]?.*" \) -ctime +61 -delete
# shellcheck disable=SC1073
pg_dump -h $HOST -U $DB_USER -d $database | gzip > $pathB/pgsql_$(date "+%Y-%m-%d").sql.gz

unset PGPASSWORD