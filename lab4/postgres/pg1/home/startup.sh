#!/bin/bash
set -e

# Replicator role
psql -v ON_ERROR_STOP=1 --username "postgres" -c "CREATE ROLE replicator WITH REPLICATION PASSWORD '1234' LOGIN;"

# DB init and populate
psql -v ON_ERROR_STOP=1 --username "postgres" -f "/home/scripts/init.sql"

mkdir -p ./archive
# Copy conf files
cp /etc/postgresql/postgresql.conf "$PGDATA/postgresql.conf"
cp /etc/postgresql/pg_hba.conf "$PGDATA/pg_hba.conf"
echo "Conf files copied"