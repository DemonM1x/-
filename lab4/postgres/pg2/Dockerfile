FROM postgres:latest
COPY conf/postgresql.conf /etc/postgresql/postgresql.conf
COPY conf/pg_hba.conf /etc/postgresql/pg_hba.conf

COPY home/startup.sh /docker-entrypoint-initdb.d/startup.sh
RUN chmod +x /docker-entrypoint-initdb.d/startup.sh

RUN apt-get update && apt-get install -y iputils-ping