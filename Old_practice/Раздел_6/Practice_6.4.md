# Домашнее задание к занятию 6.4 "PostgreSQL"

---

## Задание 1
Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
Подключитесь к БД PostgreSQL используя psql.
Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.
Найдите и приведите управляющие команды для:
    - вывода списка БД
    - подключения к БД
    - вывода списка таблиц
    - вывода описания содержимого таблиц
    - выхода из psql 

Решение:

    - вывода списка БД
````
test-# \l
                                             List of databases
   Name    |      Owner      | Encoding |  Collate   |   Ctype    |            Access privileges            
-----------+-----------------+----------+------------+------------+-----------------------------------------
 postgres  | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
 template1 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
 test      | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

test-# 
````    
    - подключения к БД
````
root@97550bf7a8e9:/# psql -h 127.0.0.1 -U test-admin-user -d test
psql (13.10 (Debian 13.10-1.pgdg110+1))
Type "help" for help.
test=#
````
    - вывода списка таблиц
````
test-# \dt *.
Did not find any relations.
````
    - вывода описания содержимого таблиц
````
test=# Stest_database=# \dS+;
````
    - выхода из psql 
````
test=# exit
root@97550bf7a8e9:/# 
````

## Задание 2  

Используя psql создайте БД test_database.
Изучите бэкап БД.
Восстановите бэкап БД в test_database.
Перейдите в управляющую консоль psql внутри контейнера.
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.

Решение:

    - Используя psql создайте БД test_database.
````
test=# CREATE DATABASE test_database;
CREATE DATABASE
test=# \l
                                               List of databases
     Name      |      Owner      | Encoding |  Collate   |   Ctype    |            Access privileges            
---------------+-----------------+----------+------------+------------+-----------------------------------------
 postgres      | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0     | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +
               |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
 template1     | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +
               |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
 test          | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | 
 test_database | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | 
(5 rows)
````
    - Изучите бэкап БД. Восстановите бэкап БД в test_database. Восстановление провожу с помощью скрипта, который 
писался два занятия назад. Текст скрипта ниже.
````
home@home:~/postgresql$ sudo sh restoresql.sh
[sudo] пароль для home: 
Попробуйте ещё раз.
[sudo] пароль для home: 
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 строка)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ERROR:  role "postgres" does not exist
CREATE SEQUENCE
ERROR:  role "postgres" does not exist
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 строка)

ALTER TABLE
````
Содержание скрипта.
````
home@home:~/postgresql$ cat restoresql.sh 
#!/bin/sh
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

DB_USER=test-admin-user
PGPASSWORD="Password"
HOST="127.0.0.1"
export PGPASSWORD

pathB=./backup
database=test_database
gunzip -c -f $pathB/$(ls -t $pathB | head -1) | psql -h $HOST -U $DB_USER -d $database
unset PGPASSWORD
home@home:~/postgresql$

````
    - Перейдите в управляющую консоль psql внутри контейнера. 
С начала нужно выйти из текущей БД. А после войти в новую ДБ.
````
test=# \q
root@97550bf7a8e9:/# psql -h 127.0.0.1 -U test-admin-user -d test_database
psql (13.10 (Debian 13.10-1.pgdg110+1))
Type "help" for help.
````
    - Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
````
test_database=# ANALYZE;
ANALYZE
````
    - Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
````
test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width 
-----------
         4
        16
         4
(3 rows)
````

## Задание 3  

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней 
занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение 
таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).
Предложите SQL-транзакцию для проведения данной операции.
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Решение:

Для начала посмотрим содержимое таблицы orders.
````
test_database=# SELECT * FROM orders;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)
````
Проводим разделение таблицы в соответствии с условиями. 
````
test_database=# BEGIN TRANSACTION;
CREATE TABLE orders_1 AS SELECT * FROM orders WHERE price > 499;
CREATE TABLE orders_2 AS SELECT * FROM orders WHERE price <= 499;
COMMIT;
BEGIN
SELECT 3
SELECT 5
COMMIT
````
Проверяем новые таблицы: orders_1 и orders_2.
````
test_database=# SELECT * FROM orders_1;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# SELECT * FROM orders_2;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)
````
Мне кажется, что "ручное" управление можно было исключить при проведении проектирования базы данных.
Как раз изначально для проектирования таблицы orders нужно было понимать скорость поступления новых записей в единицу 
времени. А также нужно было понимать распределение количества новых записей в единицу времени в зависимости от значения 
price. И какие дальнейшие производятся действия с записями в зависимости от значения.  

## Задание 4  

Используя утилиту pg_dump создайте бекап БД test_database.
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

Решение:

Чтобы обеспечить уникальность значений столбца title в таблицах test_database, при использовании утилиты pg_dump, нужно 
использовать команду ALTER TABLE ONLY:
Для уникальности значения столбца title добавим строку в бэкап
ALTER TABLE ONLY public.orders ADD CONSTRAINT title_unique UNIQUE (title);

Пример скрипта для создания бэкап-файла.
````
home@home:~/postgresql$ cat createbackupsql.sh
#!/bin/sh
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# Объявление локальных переменных
DB_USER=test-admin-user
PGPASSWORD="Password"
#Объявление глобальной переменной. Для того чтобы не вводить пароль при подключении в database. 
export PGPASSWORD 
pathB=./backup
database=test_database

# удаление бэкап-файлов старше 60 дней за усключением бэкапов середены месяца.
find $pathB \( -name "*-1[^5].*" -o -name "*-[023]?.*" \) -ctime +61 -delete

psql -h 127.0.0.1 -U $DB_USER -d $database -c "ALTER TABLE ONLY public.orders ADD CONSTRAINT title_unique UNIQUE (title)"

# создание backup и последующее архивирование с указанием даты бэкап-а
pg_dump -h 127.0.0.1 -U $DB_USER -d $database | gzip > $pathB/pgsql_$(date "+%Y-%m-%d").sql.gz

#Вывод из глобальной переменной пароль. Чтобы не была доступным после завершения выполнения скрапта.
unset PGPASSWORD
````