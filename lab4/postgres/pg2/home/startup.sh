#!/bin/bash

set -e

# Wait for master to be ready
until pg_isready -h pg1 -p 5432 -U postgres; do
  echo "Waiting for master to be ready..."
  sleep 2
done


# Clean up the data directory
rm -rf "$PGDATA"/*
echo "Data directory cleaned up"

# Perform base backup
PGPASSWORD='1234' pg_basebackup -h pg1 -D /var/lib/postgresql/data -U replicator -v -P --wal-method=stream
echo "Base backup completed"

# Create standby.signal file
touch "$PGDATA/standby.signal"
# Set permissions
chown -R postgres:postgres "$PGDATA"

# Copy conf files
cp /etc/postgresql/postgresql.conf "$PGDATA/postgresql.conf"
cp /etc/postgresql/pg_hba.conf "$PGDATA/pg_hba.conf"

echo "Conf files copied"


pg_ctl -D "$PGDATA" restart