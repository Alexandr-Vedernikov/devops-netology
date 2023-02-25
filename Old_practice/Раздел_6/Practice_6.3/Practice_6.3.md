# Домашнее задание к занятию 6.3 "MySQL"

---

## Задание 1
Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.  
Изучите бэкап БД и восстановитесь из него.  
Перейдите в управляющую консоль mysql внутри контейнера.  
Используя команду \h получите список управляющих команд.  
Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.  
Подключитесь к восстановленной БД и получите список таблиц из этой БД.  
Приведите в ответе количество записей с price > 300.  
В следующих заданиях мы будем продолжать работу с данным контейнером.  

Решение:
    - Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
````
home@home:~/mysql$ mkdir db
home@home:~/mysql$ mkdir backup
home@home:~/mysql$ ls
backup  db  docker-compose.yml
home@home:~/mysql$ ls ./backup/
test_dump.sql
home@home:~/mysql$ cat docker-compose.yml
version: '3.3'

services:
  mysql_db:
    image: mysql:8.0.32-debian
    restart: always
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: Password
      MYSQL_DATABASE: test
      MYSQL_USER: admin
      MYSQL_PASSWORD: Password
    volumes:
      - ./db:/var/lib/mysql/
      - ./backup:/var/lib/mysql_backup
````
    - Изучите бэкап БД и восстановитесь из него. Перейдите в управляющую консоль mysql внутри контейнера.
````
home@home:~/mysql$ sudo docker-compose up -d
Building with native build. Learn about native build in Compose here: https://docs.docker.com/go/compose-native-build/
Starting mysql_mysql_db_1 ... done
home@home:~/mysql$ sudo docker-compose exec mysql_db bash
root@19cf3591eac6:/# ls -la /var/lib/mysql_backup/
total 12
drwxr-xr-x 2 1000 1000 4096 Feb 23 20:30 .
drwxr-xr-x 1 root root 4096 Feb 23 20:25 ..
-rw-r--r-- 1 1000 1000 2073 Feb 23 20:30 test_dump.sql
root@19cf3591eac6:/# mysql -u root -p test < /var/lib/mysql_backup/test_dump.sqlEnter password: 
root@19cf3591eac6:/# mysqladmin -u root -p version
Enter password: 
mysqladmin  Ver 8.0.32 for Linux on x86_64 (MySQL Community Server - GPL)
Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Server version		8.0.32
Protocol version	10
Connection		Localhost via UNIX socket
UNIX socket		/var/run/mysqld/mysqld.sock
Uptime:			1 hour 1 min 47 sec

Threads: 3  Questions: 107  Slow queries: 0  Opens: 226  Flush tables: 3  Open tables: 144  Queries per second avg: 0.028
````
    - Используя команду \h получите список управляющих команд.
````
root@19cf3591eac6:/# mysql -u admin -p test                                    
Enter password: 
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 19
Server version: 8.0.32 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
ssl_session_data_print Serializes the current SSL session data to stdout or file

For server side help, type 'help contents'
````
    - Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.
````
mysql> status ;
--------------
mysql  Ver 8.0.32 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		21
Current database:	test
Current user:		admin@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.32 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			1 hour 46 min 3 sec

Threads: 3  Questions: 123  Slow queries: 0  Opens: 249  Flush tables: 3  Open tables: 167  Queries per second avg: 0.019
--------------
````
    - Подключитесь к восстановленной БД и получите список таблиц из этой БД.  
````
mysql> SHOW TABLES;
+----------------+
| Tables_in_test |
+----------------+
| orders         |
+----------------+
1 row in set (0.01 sec)
````
    - Приведите в ответе количество записей с price > 300. Строго больше 300 одно значение. Вывел всю таблицу для проверки. 
````
mysql> SELECT * FROM orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)

mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.01 sec)

````

## Задание 2  

Создайте пользователя test в БД c паролем test-pass, используя:  
  * плагин авторизации mysql_native_password  
  * срок истечения пароля - 180 дней  
  * количество попыток авторизации - 3  
  * максимальное количество запросов в час - 100  
  * аттрибуты пользователя:  
      - Фамилия "Pretty"  
      - Имя "James"  

Предоставьте привелегии пользователю test на операции SELECT базы test_db.  
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.  

Решение:

Создать пользователя "test" используя плагин авторизации mysql_native_password с паролем "test-pass", и с применением 
параметров указанных в задании. Описание каждого пункта приведена ниже.
````
mysql> CREATE USER "test"@"localhost" IDENTIFIED WITH mysql_native_password BY "test-pass" 
PASSWORD EXPIRE INTERVAL 180 DAY FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2 
ATTRIBUTE '{"Familia": "Pretty", "Name": "James"}';
```` 
за описание аттрибутов срок истечения пароля - 180 дней, отвечает следующая часть команды
````
PASSWORD EXPIRE INTERVAL 180 DAY
````
за описание аттрибутов количество попыток авторизации - 3, отвечает следующая часть команды
````
FAILED_LOGIN_ATTEMPTS 3
````
за описание аттрибутов пользователей (Фамилия "Pretty", Имя "James"), отвечает следующая часть команды
````
ATTRIBUTE '{"Familia": "Pretty", "Name": "James"}'
````
за добавление аттрибутов максимальное количество запросов в час - 100 отвечает команда
````
mysql> ALTER USER 'test'@'localhost' WITH MAX_USER_CONNECTIONS 100;
````

Предоставьте привелегии пользователю test на операции SELECT базы test_db. 
````
mysql> GRANT SELECT ON test_db.* TO 'test'@'localhost';
````

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.
````
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test' AND HOST='localhost';
+------+-----------+----------------------------------------+
| USER | HOST      | ATTRIBUTE                              |
+------+-----------+----------------------------------------+
| test | localhost | {"Name": "James", "Familia": "Pretty"} |
+------+-----------+----------------------------------------+
mysql> SHOW GRANTS FOR 'test'@'localhost';
+---------------------------------------------------+
| Grants for test@localhost                         |
+---------------------------------------------------+
| GRANT USAGE ON *.* TO `test`@`localhost`          |
| GRANT SELECT ON `test_db`.* TO `test`@`localhost` |
+---------------------------------------------------+
````

## Задание 3

Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES.  
Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.  
Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:  
  - на MyISAM  
  - на InnoDB  

Решение:

````
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.92 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.68 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.00018050 | SET profiling = 1                  |
|        2 | 0.91864350 | ALTER TABLE orders ENGINE = MyISAM |
|        3 | 0.68427650 | ALTER TABLE orders ENGINE = InnoDB |
+----------+------------+------------------------------------+
3 rows in set, 1 warning (0.00 sec)
````

## Задание 4

Изучите файл my.cnf в директории /etc/mysql.  
Измените его согласно ТЗ (движок InnoDB):  
  * Скорость IO важнее сохранности данных  
  * Нужна компрессия таблиц для экономии места на диске  
  * Размер буффера с незакомиченными транзакциями 1 Мб  
  * Буффер кеширования 30% от ОЗУ  
  * Размер файла логов операций 100 Мб  

Приведите в ответе измененный файл my.cnf.  

Решение:

Текущее содержание файла /etc/mysql/my.cnf
````
root@9bd075ba5b19:/# cat /etc/mysql/my.cnf

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/
````
Содержание файла после корректировок
````
root@9bd075ba5b19:/# nano /etc/mysql/my.cnf
root@9bd075ba5b19:/# cat /etc/mysql/my.cnf

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/
innodb_flush_log_at_trx_commit = 0
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 1G
innodb_log_file_size = 100M
````