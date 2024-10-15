CREATE TABLESPACE indexspace LOCATION 'var/db/postgres1/iat59';
createdb -p 9888 -T template1 fakebrownuser

CREATE DATABASE fakebrownuser WITH TEMPLATE = template1;
CREATE TABLE fake (id bigserial primary key, name text, type text, age int);
CREATE INDEX ON fake (name) TABLESPACE indexspace;
CREATE ROLE s367487 WITH LOGIN PASSWORD 's367487';
GRANT INSERT ON fake TO s367487;
GRANT USAGE, SELECT ON SEQUENCE fake_id_seq TO s367487;



psql -h 127.0.0.1 -p 9888 -U s367487 -d fakebrownuser

psql -h 127.0.0.1 -p 9888 -U s367487 -d fakebrownuser -f insert.sql

SELECT c.relname, t.spcname FROM pg_class c JOIN pg_tablespace t ON
c.reltablespace = t.oid;

select * from pg_tablespace;

select relname from pg_class where reltablespace in (select oid from pg_tablespace);

WITH objects AS (
    SELECT 
        COALESCE(t.spcname, 'pg_default') AS tablespace_name,
        c.relname AS object_name
    FROM pg_class c
    LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
    WHERE c.relkind IN ('r', 'i')  -- таблицы (r) и индексы (i)
),
result as (
    SELECT
    tablespace_name,
    object_name,
    ROW_NUMBER() OVER (PARTITION BY tablespace_name ORDER BY object_name) as table_number
    from objects
    ORDER BY tablespace_name, table_number
)
SELECT 
    CASE WHEN table_number = 1
    THEN tablespace_name
    ELSE ''
    END as tablespace_name,
    object_name
FROM result;


