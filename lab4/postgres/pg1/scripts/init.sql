-- Создание пользователя репликации
create database testdb;

\c testdb;


CREATE TABLE fake (id bigserial primary key, name text, type text, age int);
INSERT INTO fake (name, type, age)
VALUES
    ('John Doe', 'Person', 28),
    ('Jane Smith', 'Person', 34),
    ('Company A', 'Organization', 12),
    ('Alice Brown', 'Person', 45),
    ('Charlie Company', 'Organization', 8),
    ('Bob Johnson', 'Person', 22),
    ('Tech Group', 'Organization', 5),
    ('Eve White', 'Person', 30),
    ('Green Corp', 'Organization', 18),
    ('Tom Davis', 'Person', 50);

create table buildings(id bigserial primary key, name text, type text);

insert into buildings(name, type) Values ('Empire State Buil
ing', 'Office'), ('Burj Khalifa', 'Residential'), ('Eiffel Tower', 'Tourist
Attraction');
