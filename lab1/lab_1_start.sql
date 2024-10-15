\echo 'Введите полное имя таблицы (в формате [db_name.schema_name.]table_name): '
\prompt '' full_table_name
\set full_table_name '\'' :full_table_name '\''

select show_table_info(:full_table_name::text)