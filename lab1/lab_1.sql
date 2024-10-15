CREATE OR REPLACE FUNCTION show_table_info(full_table_name text) RETURNS void
AS $$
DECLARE
    col RECORD;
    schema_name TEXT; 
    table_name TEXT;  
    db_name TEXT;    
    table_count INT;  
    first_dot_position INT; 
    second_dot_position INT;
BEGIN
    -- Определяем позиции первой и второй точки
    first_dot_position := strpos(full_table_name, '.');
    second_dot_position :=   strpos(substring(full_table_name FROM strpos(full_table_name, '.') + 1), '.');

    -- Разбор полного имени таблицы на составляющие
    IF first_dot_position = 0 THEN
        -- Если точек нет
        schema_name := current_schema();
        table_name := full_table_name;
    ELSIF second_dot_position = 0 THEN
        -- Если одна точка
        schema_name := split_part(full_table_name, '.', 1);
        table_name := split_part(full_table_name, '.', 2);
    ELSE
        -- Если две точки
        db_name := split_part(full_table_name, '.', 1);  
        schema_name := split_part(full_table_name, '.', 2);
        table_name := split_part(full_table_name, '.', 3);
    END IF;

    -- Проверка существования схемы и таблицы
    SELECT COUNT(DISTINCT nspname) INTO table_count
    FROM pg_class tab
    JOIN pg_namespace space ON tab.relnamespace = space.oid
    WHERE relname = table_name AND space.nspname = schema_name;

    IF table_count < 1 THEN
        RAISE EXCEPTION 'Таблица "%" не найдена в схеме "%"!', table_name, schema_name;
    ELSE
        RAISE NOTICE ' ';
        RAISE NOTICE 'Таблица: %', table_name;
        RAISE NOTICE 'No. Имя столбца.   Атрибуты';
        RAISE NOTICE '--- ------------   -----------------------------------------';
        RAISE NOTICE ' ';

        -- Вывод информации по колонкам таблицы
        FOR col IN 
        SELECT tab.relname,
            attr.attnum,
            attr.attname,
            typ.typname,
            space.nspname,
            constr.contype,
            ref_table.relname AS ref_table,
            ref_attr.attname AS ref_column
        FROM pg_class tab
        JOIN pg_namespace space ON tab.relnamespace = space.oid
        JOIN pg_attribute attr ON attr.attrelid = tab.oid
        JOIN pg_type typ ON attr.atttypid = typ.oid
        LEFT JOIN pg_constraint constr ON tab.oid = constr.conrelid 
            AND constr.contype = 'f'
            AND attr.attnum = ANY(constr.conkey)
        LEFT JOIN pg_class ref_table ON constr.confrelid = ref_table.oid
        LEFT JOIN pg_attribute ref_attr ON ref_attr.attrelid = constr.confrelid
            AND ref_attr.attnum = ANY(constr.confkey)
        WHERE tab.relname = table_name
        AND attr.attnum > 0
        AND space.nspname = schema_name
        ORDER BY attr.attnum
     LOOP
            RAISE NOTICE '% % Type    :  %', RPAD(col.attnum::text, 5, ' '), RPAD(col.attname, 16, ' '), col.typname;
            IF col.contype = 'f' THEN
                RAISE NOTICE '% Constr  :  % References %(%)', RPAD(' ', 22, ' '), col.attname, col.ref_table, col.ref_column;
            END IF;
        END LOOP;
    END IF;
END;
$$
LANGUAGE 'plpgsql';
