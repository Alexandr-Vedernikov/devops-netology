DevOps-netology-23
Vedernikov Alexandr
Домашнее задание к занятию "3.7. Компьютерные сети. Лекция 2"

**1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды 
есть для этого в Linux и в Windows?**

Решение:

В Windows в консоли узнать список сетевых интерфейсов можно узнать командой ipconfig  

В Linux можно несколькими способами.  
Можно вывести просто список интерфейсов, прочитав из файла  

> vagrant@vagrant:~$ ls /sys/class/net  
> eth0  eth1  lo

Для более подробного вывода информации можно воспользоваться следующими командами

ip link show  
ip address

>vagrant@vagrant:~$ ip address  
>1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000  
>    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00  
>    inet 127.0.0.1/8 scope host lo  
>       valid_lft forever preferred_lft forever  
>    inet6 ::1/128 scope host   
>       valid_lft forever preferred_lft forever  
>2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000  
>    link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff  
>    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0  
>       valid_lft 85808sec preferred_lft 85808sec  
>    inet6 fe80::a00:27ff:fea2:6bfd/64 scope link   
>       valid_lft forever preferred_lft forever  
>3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000  
>    link/ether 08:00:27:fc:42:48 brd ff:ff:ff:ff:ff:ff  
>    inet 192.168.1.83/24 brd 192.168.1.255 scope global dynamic eth1  
>       valid_lft 85808sec preferred_lft 85808sec  
>    inet6 fe80::a00:27ff:fefc:4248/64 scope link   
>       valid_lft forever preferred_lft forever  

**2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой 
пакет и команды есть в Linux для этого?**

Решение:

Протокол обнаружения соседей - NDP (Neighbor Discovery Protocol)  
Пакет - lldpd  

>vagrant@vagrant:~$ ip neighbor  
>10.0.2.2 dev eth0 lladdr 52:54:00:12:35:02 REACHABLE  
>10.0.2.3 dev eth0 lladdr 52:54:00:12:35:03 REACHABLE  
>192.168.1.1 dev eth1 lladdr ec:41:18:25:29:19 STALE  

**3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных 
сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.**

Решение:

   Для разделения коммутаторов на несколько виртуальных сетей используются VLAN (Virtual 
   Local Area Network)  
   Пакет vlan.   
   Команды vconfig и ip add.  
   Пример конфигурации:  

>auto eth0.20  
>iface eth0.20 inet static  
>address 10.0.2.200  
>netmask 255.255.255.0  
>vlan-raw-device eth0  

**4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки 
нагрузки? Приведите пример конфига.**

Решение:

Типы агрегации интерфейсов в Linux:

Mode-0(balance-rr) – Данный режим используется по умолчанию. Balance-rr обеспечивается 
балансировку нагрузки и отказоустойчивость. В данном режиме сетевые пакеты отправляются 
“по кругу”, от первого интерфейса к последнему. Если выходят из строя интерфейсы, пакеты 
отправляются на остальные оставшиеся. Дополнительной настройки коммутатора не требуется 
при нахождении портов в одном коммутаторе. При разностных коммутаторах требуется 
дополнительная настройка.

Mode-1(active-backup) – Один из интерфейсов работает в активном режиме, остальные в 
ожидающем. При обнаружении проблемы на активном интерфейсе производится переключение на 
ожидающий интерфейс. Не требуется поддержки от коммутатора.

Mode-2(balance-xor) – Передача пакетов распределяется по типу входящего и исходящего 
трафика по формуле ((MAC src) XOR (MAC dest)) % число интерфейсов. Режим дает 
балансировку нагрузки и отказоустойчивость. Не требуется дополнительной настройки 
коммутатора/коммутаторов.

Mode-3(broadcast) – Происходит передача во все объединенные интерфейсы, тем самым 
обеспечивая отказоустойчивость. Рекомендуется только для использования MULTICAST трафика.

Mode-4(802.3ad) – динамическое объединение одинаковых портов. В данном режиме можно 
значительно увеличить пропускную способность входящего так и исходящего трафика. Для 
данного режима необходима поддержка и настройка коммутатора/коммутаторов.

Mode-5(balance-tlb) – Адаптивная балансировки нагрузки трафика. Входящий трафик получается
только активным интерфейсом, исходящий распределяется в зависимости от текущей загрузки 
канала каждого интерфейса. Не требуется специальной поддержки и настройки 
коммутатора/коммутаторов.

Mode-6(balance-alb) – Адаптивная балансировка нагрузки. Отличается более совершенным 
алгоритмом балансировки нагрузки чем Mode-5). Обеспечивается балансировку нагрузки как 
исходящего так и входящего трафика. Не требуется специальной поддержки и настройки 
коммутатора/коммутаторов.

Уровни балансировки

Процедура балансировки осуществляется при помощи целого комплекса алгоритмов и методов, 
соответствующим следующим уровням модели OSI:

    сетевому;  
    транспортному;  
    прикладному.  

Соединения к серверам для балансировки нагрузки могут распределяться по различным правилам.
Существуют несколько методов распределения запросов. Основные:

round-robin - используется по умолчанию. Веб сервер равномерно распределяет нагрузку на 
сервера с учетом их весов. Специально указывать этот метод в конфигурации не надо.  
least-connected - запрос отправляется к серверу с наименьшим количеством активных 
подключений. В конфигурации данный параметр распределения запросов устанавливается 
параметром least_conn.  
ip-hash - используется хэш функция, основанная на клиентском ip адресе, для определения, 
куда направить следующий запрос. Используется для привязки клиента к одному и тому же 
серверу. В предыдущих методах один и тот же клиент может попадать на разные серверы.  
hash - задаёт метод балансировки, при котором соответствие клиента серверу определяется 
при помощи хэшированного значения ключа. В качестве ключа может использоваться текст, 
переменные и их комбинации.  
random - балансировка нагрузки, при которой запрос передаётся случайно выбранному 
серверу, с учётом весов.  

Пример конфигурации. В ней upstream делится на 2-е группы в каждой из которых свои 
наборы серверов. 

>upstream backend1 {  
>    server 192.168.10.10;  
>    server 192.168.10.11;  
>}  
>
>upstream backend2 {  
>    server 192.168.10.12;  
>    server 192.168.10.13;  
>}  

**5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с 
маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.**

Решение:

Маска /29. Для записи IP адреса 32 бита отводится.   
32 - 29 = 3  
 2 ^ 3 = 8  
В сеть с маской /29 содержит 8 IP адресов, из которых:  
- 1 адрес используется для обозначения сети  
- 1 адрес - широковещательный адрес  
- 6 пользовательских адресов  

29 - 24 = 5  
 2 ^ 5 = 32  
В сети с маской /24 можно разместить 32 подсети с маской /29.  

Примеры сетей /29 внутри сети 10.10.10.0/24:  
10.10.10.0/29  
10.10.10.8/29  
10.10.10.152/29  
10.10.10.248/29  

**6. Задача: вас попросили организовать стык между 2-мя организациями. 
Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо
взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.**

Решение:

Для стыка 2-х организаций допустимо взять ip адреса из 100.64.0.0 - 100.127.255.255.  
Для сети в 40 - 50 хостов необходимо использовать маску /26.  

**7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? 
Как из ARP таблицы удалить только один нужный IP?**

Решение:

В Windows можно посмотреть с помощью команды arp -a  
в Linuх:
>vagrant@vagrant:~$ arp -n  
>Address                  HWtype  HWaddress           Flags Mask            Iface  
>10.0.2.2                 ether   52:54:00:12:35:02   C                     eth0  
>10.0.2.3                 ether   52:54:00:12:35:03   C                     eth0  
>192.168.1.1              ether   ec:41:18:25:29:19   C                     eth1  

Очистить всю таблицу ARP.

> ip -s -s neigh flush all

Для удаления записи ARP для определенного адреса, используйте следующая команда:

> arp -d <ip-address>
