FROM postgres:latest
COPY conf/postgresql.conf /etc/postgresql/postgresql.conf
COPY conf/pg_hba.conf /etc/postgresql/pg_hba.conf
COPY home/startup.sh /home/init/startup.sh
COPY scripts/init.sql /home/scripts/init.sql
RUN chmod +x /home/init/startup.sh
RUN apt-get update && apt-get install -y iputils-ping 