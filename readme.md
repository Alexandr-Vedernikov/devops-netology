# Домашнее задание к занятию 6.2 "SQL"

---

## Задание 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Приведите получившуюся команду или docker-compose манифест.

Решение:


````
vagrant@TestServer1:~/PostgreSQL$ sudo docker-compose -f postgresql.yml up -d
[+] Running 1/1
 ⠿ Container postgresql-postgres-1  Started                                                   0.5s

vagrant@TestServer1:~/PostgreSQL$ sudo docker-compose -f postgresql.yml ps
NAME                    COMMAND                  SERVICE             STATUS              PORTS
postgresql-postgres-1   "docker-entrypoint.s…"   postgres            running (healthy)   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp
````

````
vagrant@TestServer1:~/PostgreSQL$ cat postgresql.yml 
version: "2.5"
services:
  postgres:
    image: postgres:12.14
    environment:
      POSTGRES_DB: "test_db"
      POSTGRES_USER: "test-admin-user"
      POSTGRES_PASSWORD: "Password"
      PGDATA: "/var/lib/postgresql/data/pgdata"
    volumes:
      - ./script. Init Database:/docker-entrypoint-initdb.d
      - ./bd:/var/lib/postgresql/data
      - ./backup:/var/lib/postgresql/backup
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U test-admin-user -d test_db"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s
    restart: unless-stopped
````

## Задание 2

В БД из задачи 1:  
 - создайте пользователя test-admin-user и БД test_db  
 - в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)  
 - предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db  
 - создайте пользователя test-simple-user  
 - предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db  
 
Таблица orders:  
 - id (serial primary key)  
 - наименование (string)  
 - цена (integer)  

Таблица clients:  
 - id (serial primary key)  
 - фамилия (string)  
 - страна проживания (string, index)  
 - заказ (foreign key orders)  

Приведите:  
 - итоговый список БД после выполнения пунктов выше,  
 - описание таблиц (describe)  
 - SQL-запрос для выдачи списка пользователей с правами над таблицами test_db  
 - список пользователей с правами над таблицами test_db  

Решение:

- создайте пользователя test-admin-user и БД test_db  
![2.1.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_6%2FPractice_6.2%2F2.1.png)

- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)  
![2.2.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_6%2FPractice_6.2%2F2.2.png)
![2.3.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_6%2FPractice_6.2%2F2.3.png)
![2.4.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_6%2FPractice_6.2%2F2.4.png)

- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db   
````
mple-user | clients    | DELETE
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | orders     | DELETE
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | UPDATE
````
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db  
 - список пользователей с правами над таблицами test_db 
````
test_db=# SELECT 
    grantee, table_name, privilege_type 
FROM 
    information_schema.table_privileges 
WHERE 
    grantee in ('test-admin-user','test-simple-user')
    and table_name in ('clients','orders')
order by 
    1,2,3;
     grantee      | table_name | privilege_type 
------------------+------------+----------------
 test-admin-user  | clients    | DELETE
 test-admin-user  | clients    | INSERT
 test-admin-user  | clients    | REFERENCES
 test-admin-user  | clients    | SELECT
 test-admin-user  | clients    | TRIGGER
 test-admin-user  | clients    | TRUNCATE
 test-admin-user  | clients    | UPDATE
 test-admin-user  | orders     | DELETE
 test-admin-user  | orders     | INSERT
 test-admin-user  | orders     | REFERENCES
 test-admin-user  | orders     | SELECT
 test-admin-user  | orders     | TRIGGER
 test-admin-user  | orders     | TRUNCATE
 test-admin-user  | orders     | UPDATE
 test-simple-user | clients    | DELETE
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | orders     | DELETE
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | UPDATE
(22 строки)
````

## Задание 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

Решение:

Заполняем таблицу orders:
````
test_db=# INSERT INTO orders (Наименование, Цена) VALUES ('Шоколад', 10);
test_db=# INSERT INTO orders (Наименование, Цена) VALUES ('Принтер', 3000);
test_db=# INSERT INTO orders (Наименование, Цена) VALUES ('Книга', 500);
test_db=# INSERT INTO orders (Наименование, Цена) VALUES ('Монитор', 7000);
test_db=# INSERT INTO orders (Наименование, Цена) VALUES ('Гитара', 4000);
````
Меняем имя столбца "Фамилия" на "ФИО"
````
ALTER TABLE public.clients RENAME COLUMN "Фамилия" TO "ФИО";
````
Заполняем таблицу clients:
````
test_db=# INSERT INTO clients (ФИО, Страна_проживания) VALUES ('Иванов Иван Иванович', 'USA');
test_db=# INSERT INTO clients (ФИО, Страна_проживания) VALUES ('Петров Петр Петрович', 'Canada');
test_db=# INSERT INTO clients (ФИО, Страна_проживания) VALUES ('Иоганн Себастьян Бах', 'Japan');
test_db=# INSERT INTO clients (ФИО, Страна_проживания) VALUES ('Ронни Ждеймс Дио', 'Russia');
test_db=# INSERT INTO clients (ФИО, Страна_проживания) VALUES ('Ritchie Blackmore', 'Russia');
````
Вычисляем количество записей для каждой таблицы 
````
test_db=# SELECT COUNT(*) as count FROM orders;
 count 
-------
     5
(1 строка)
                                        ^
test_db=# SELECT COUNT(*) as count FROM clients;
 count 
-------
     5
(1 строка)

````

## Задание 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.    
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.  
Подсказка - используйте директиву `UPDATE`.    

Решение:

SQL-запросы оформления заказов:
````
test_db=# update clients set Заказ = (select order_id from orders where Наименование = 'Книга') where ФИО = 'Иванов Иван Иванович';
test_db=# update clients set Заказ = (select order_id from orders where Наименование = 'Монитор') where ФИО = 'Петров Петр Петрович';
test_db=# update clients set Заказ = (select order_id from orders where Наименование = 'Гитара') where ФИО = 'Иоганн Себастьян Бах';
````
SQL-запрос для выдачи всех пользователей, которые совершили заказ:
````                                                               
test_db=# select c.* from clients c join orders o on c.Заказ = o.order_id;
 client_id |         ФИО          | Страна_проживания | Заказ 
-----------+----------------------+-------------------+-------
         1 | Иванов Иван Иванович | USA               |     3
         2 | Петров Петр Петрович | Canada            |     4
         3 | Иоганн Себастьян Бах | Japan             |     5
(3 строки)
````

## Задание 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).  
Приведите получившийся результат и объясните, что значат полученные значения.  

Решение:

````
test_db=# explain select c.* from clients c join orders o on c.Заказ = o.order_id;
                              QUERY PLAN                               
-----------------------------------------------------------------------
 Hash Join  (cost=21.93..34.58 rows=210 width=344)
   Hash Cond: (c."Заказ" = o.order_id)
   ->  Seq Scan on clients c  (cost=0.00..12.10 rows=210 width=344)
   ->  Hash  (cost=15.30..15.30 rows=530 width=4)
         ->  Seq Scan on orders o  (cost=0.00..15.30 rows=530 width=4)
(5 строк)
````
1. Сначала будет полностью построчно прочитана таблица `orders` 
2. Для неё будет создан хэш по полю `id`
3. После будет прочитана таблица `clients`, 
4. Для каждой строки по полю `заказ` будет проверено, соответствует ли она чему-то в кеше `orders`
   - Если ничему не соответствует - строка будет пропущена
   - Если соответствует, то на основе этой строки и всех подходящих строках хеша СУБД сформирует вывод 

При запуске просто `explain`, Postgres напишет только примерный план выполнения запроса и для каждой операции предположит:
- сколько роцессорного времени уйдёт на поиск первой записи и сбор всей выборки: `cost`=`первая_запись`..`вся_выборка`
- сколько примерно будет строк: `rows`
- какой будет средняя длина строки в байтах: `width`

Postgres делает предположения на основе статистики, которую собирает периодический выполня `analyze` запросы на выборку данных из служебных таблиц.  

Если запустить `explain analyze`, то запрос будет выполнен и к плану добавятся уже точные данные по времени и объёму данных.

`explain verbose` и `explain analyze verbose` то для каждой операции выборки будут написаны поля таблиц, которые в выборку попали.

## Задание 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).  
Остановите контейнер с PostgreSQL (но не удаляйте volumes).  
Поднимите новый пустой контейнер с PostgreSQL.  
Восстановите БД test_db в новом контейнере.  
Приведите список операций, который вы применяли для бэкапа данных и восстановления.  

Решение:
- На основе "docker-compose.yml.old" запущен вариант БД, которую будем архивировать. [docker-compose.yml.old](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_6%2FPractice_6.2%2Fdocker-compose.yml.old)   
- Создаем скрипт для создания BackUp базы test_db по расписанию Cron. Фал скрипта расположен с папке с *.yml - файлом.    
[createbackupsql.sh](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_6%2FPractice_6.2%2Fcreatebackupsql.sh)  
Нужно убедиться:
    * Что скрипт является исполняемым. "chmod +x createbackupsql.sh"  
    * У пользователя под которым запускается скрипт, имеет права на запись в папку "./backup"  
- Создаем в Crontab правило для автоматического запуска скрипта. В примере скрипт запускается ежедневно в 01:00 'crontab -e'  
1 0 * * * /postgresql/createbackupsql.sh  
- Останавливаем контейнер.  
- Запускаем новый контейнер с Postresql на основе файла "postgres2.yml". В данном варианте Volume "backup" общая. 
 Лучше чтобы каждый инстанс имел свой Volume. И при этом есть механизм копирования backup между volume.  [postgres2.yml](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_6%2FPractice_6.2%2Fpostgres2.yml)  
- Восстановить можно из полного дампа с помощью скрипта. Файл дампа не удаляется. В скрипте нужно поправить исходные 
данные. Скрипт "restoresql.sh" тоже расположен в папке с *.yml.  
[restoresql.sh](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_6%2FPractice_6.2%2Frestoresql.sh)