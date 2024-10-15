create or replace function input(schema text) returns void – создаем функцию,которая реализует аноним блок
as $$ - соединение двух языков
DECLARE
r RECORD;
checked int; - проверка существования схемы
schema_name text := schema;
count_removed int := 0;
BEGIN
  SELECT COUNT(DISTINCT nspname) INTO checked FROM pg_class class_tab
  JOIN pg_namespace namespace ON class_tab.relnamespace = namespace.oid
  WHERE namespace.nspname = schema_name;
  IF checked < 1 THEN 
         RAISE EXCEPTION 'Схема % не найдена' , schema_name;
  ELSE
RAISE NOTICE 'Схема: %', schema_name;
FOR r IN
SELECT tab.oid, tab.relname, att.attname, att.attnotnull
FROM pg_class tab
join pg_namespace space on tab.relnamespace = space.oid
join pg_attribute att on att.attrelid = tab.oid
where att.attnotnull = 't' and space.nspname = schema_name – в запросе получить строки с ограничением 
LOOP – цикл выполнеяется до тех пор пока не будут удалены все ограничения
BEGIN
EXECUTE 'ALTER TABLE ' || quote_ident(r.relname) || ' ALTER COLUMN ' || quote_ident(r.attname) || ' DROP NOT NULL';
count_removed := count_removed + 1;
EXCEPTION
WHEN OTHERS THEN
CONTINUE; - след интеррация
END;
END LOOP;
RAISE NOTICE 'Всего удалено ограничений NOT NULL: %', count_removed;
END IF;
END;
$$
LANGUAGE 'plpgsql';
