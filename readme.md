DevOps-netology-23
Vedernikov Alexandr
Домашнее задание к занятию "3.3. Операционные системы. Лекция 1"

1. Какой системный вызов делает команда `cd`?
   В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной программой, это
   `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем
   не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы
   увидите полный список системных вызовов, которые делает сам `bash` при старте.
   Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание,
   что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.

   Решение:
   Ближе к концу списка системных вызова есть chdir("/tmp"). Этот вызов относится к cd.
2. Попробуйте использовать команду `file` на объекты разных типов в файловой системе.
   Например:

   ```shell notranslate position-relative overflow-auto
   vagrant@netology1:~$ file /dev/tty
   /dev/tty: character special (5/0)
   vagrant@netology1:~$ file /dev/sda
   /dev/sda: block special (8/0)
   vagrant@netology1:~$ file /bin/bash
   /bin/bash: ELF 64-bit LSB shared object, x86-64
   ```
   Используя `strace` выясните, где находится база данных `file`, на основании которой
   она делает свои догадки.

   Решение:
   vagrant@vagrant:~/test$ strace file /dev/tty 1>tty.txt 2>&1
   vagrant@vagrant:~/test$ strace file /dev/sda 1>sda.txt 2>&1
   vagrant@vagrant:~/test$ strace file /bin/bash 1>bash.txt 2>&1
   vagrant@vagrant:~/test$ grep -F -f tty.txt sda.txt > 3.txt
   vagrant@vagrant:~/test$ grep -F -f 3.txt bash.txt > 3_1.txt
   vagrant@vagrant:~/test$ nano 3_1.txt
   Проанализировав файл получается все команды file пытаются открыть файл magic.mgc в двух
   местах. Это файл базы типов файлов.
   openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
   openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
   
3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален
   (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или
   просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный
   файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении
   потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место
   на файловой системе).

   Решение:
   vagrant@vagrant:~/test$ lsof -p 1126
   ...
   vi 1378 vagrant 4u REG 253,0 12288  526898 /home/vagrant/test/.tst_bash.swp (deleted)
   vagrant@vagrant:~/test$ echo '' >/proc/1378/fd/4
   где 1378 - PID процесса vi
   4 - дескриптор файла, который предварительно удалил.
4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

   Решение:
Процесс-зомби также известен как недействующий процесс, потому что он представлен в
таблице процессов только под этим именем. Хотя процесс-зомби не использует никаких
системных ресурсов, но сохраняет свою запись (PID) в таблице процессов системы.
   Отобразить зомби-процессы: ps aux | grep defunct
   Необходимо найти PID родителя: ps -xal | grep defunct
   Для завершения зомби нужно родителю послать сигнал: kill -s SIGCHLD <PID родителя>

5. В iovisor BCC есть утилита `opensnoop`:
   ```shell notranslate position-relative overflow-auto
   root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
   /usr/sbin/opensnoop-bpfcc
   ```
   На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? 
Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. 
Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

   Решение:
   vagrant@vagrant:~/test$ sudo apt install bpfcc-tools
   Reading package lists... Done
   Building dependency tree
   Reading state information... Done
   bpfcc-tools is already the newest version (0.12.0-2).
   0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
   vagrant@vagrant:~/test$ dpkg -L bpfcc-tools | grep sbin/opensnoop
   /usr/sbin/opensnoop-bpfcc
   vagrant@vagrant:~/test$ sudo /usr/sbin/opensnoop-bpfcc
   PID    COMM               FD ERR PATH
   904    vminfo              4   0 /var/run/utmp
   635    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
   635    dbus-daemon        20   0 /usr/share/dbus-1/system-services
   635    dbus-daemon        -1   2 /lib/dbus-1/system-services
   635    dbus-daemon        20   0 /var/lib/snapd/dbus-1/system-services/

6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
   
   Решение:
для чтения полного man нужно проверить установку пакета manpages-dev.
   vagrant@vagrant:~/test$ sudo apt install manpages-dev
   vagrant@vagrant:~/test$ man 2 uname
   Выдержка из man:
Part  of the utsname information is also accessible via /proc/sys/kernel/{ostype, 
hostname, osrelease, version, domainname}.

7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
   ```shell notranslate position-relative overflow-auto
   root@netology1:~# test -d /tmp/some_dir; echo Hi
   Hi
   root@netology1:~# test -d /tmp/some_dir && echo Hi
   root@netology1:~#
   ```
   Есть ли смысл использовать в bash `&&`, если применить `set -e`?

   Решение:
`&&` - выполнить команду, следующую за ней`&&`, только если первая команда выполнена 
успешно. Не все программы имеют одинаковое поведение, поэтому, чтобы это работало, 
нужно понять, что программа считает «сбоем» и как она с этим справляется.
   vagrant@vagrant:~/test$ true && echo "This will always run"
   This will always run
   vagrant@vagrant:~/test$ false && echo "This will always run"
   vagrant@vagrant:~/test$
`;` - просто разделитель, который не заботится о том, что произошло с командой раньше. 
Вторая команда выполняется вне зависимости от того как завершилась первая.
   vagrant@vagrant:~/test$ false ; echo "This will always run"
   This will always run
   vagrant@vagrant:~/test$ true ; echo "This will always run"
   This will always run
set -e - прерывает сессию при любом ненулевом значении исполняемых команд в конвеере 
кроме последней.    
В случае &&  вместе с set -e- вероятно не имеет смысла, так как при ошибке, выполнение 
команд прекратиться.

8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы 
   использовать в сценариях?

   Решение:
   -е - немедленный выход, если выходное состояние команды ненулевое
   -u - во время замещения рассматривает не заданную переменную как ошибку
   -x - выводит команды и их аргументы по мере выполнения команд.
   -o pipefail - этот параметр предотвращает маскирование ошибок в конвейере. В случае 
сбоя какой-либо команды в конвейере этот код возврата будет использоваться как код 
возврата для всего конвейера.

9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус 
у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат 
дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать 
при расчете (считать S, Ss или Ssl равнозначными).

   Решение:
   S*(S,S+,Ss,Ssl,Ss+) - Процессы ожидающие завершения (спящие с прерыванием "сна").
   I*(I,I<) - фоновые(бездействующие) процессы ядра.
   доп символы это доп характеристики, например приоритет.
