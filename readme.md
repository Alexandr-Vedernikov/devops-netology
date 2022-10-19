DevOps-netology-23
Vedernikov Alexandr

1. Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа; опишите ход своих
мыслей, если считаете что она могла бы быть другого типа.
Решение:
home@home:~/Загрузки$ type cd
cd — это встроенная команда bash

2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l? man grep поможет 
в ответе на этот вопрос. Ознакомьтесь с документом о других подобных некорректных вариантах 
использования pipe.
Решение:
wc -l < <( grep <some_string> <some_file> )
Показывает количество строк в файле <some_file> содержащих <some_string>

3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине 
Ubuntu 20.04?
Решение:
Первый процесс в системе запускается при инициализации ядра. Данный процесс называется - systemd и 
имеет PID=1. Это прородитель всех процессов в системе.
vagrant@vagrant:~$ ps -A
    PID TTY          TIME CMD
      1 ?        00:00:01 systemd
      2 ?        00:00:00 kthreadd
      3 ?        00:00:00 rcu_gp
      4 ?        00:00:00 rcu_par_gp

4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?
Решение:
vagrant@vagrant:/dev/pts$ ls -l dddd.txt fff 2>/dev/pts/1

5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? 
Приведите работающий пример.
Решение:
vagrant@vagrant:~/test$ ls -l file_stdin.txt > file_stdout.txt

6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY?
Сможете ли вы наблюдать выводимые данные?
Решение:
home@home:~$ tty
/dev/pts/1
home@home:~$ echo Hello World! Send from pts1 to tty2 >/dev/tty2
Чтобы переключиться в tty2 нужно нажать "ctrl + alt + F2". Вывод в терминале.
https://drive.google.com/file/d/1j11hs-7Df6l_EiMVM1RtTwaJJ5tvhYR9/view?usp=sharing

7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните
echo netology > /proc/$$/fd/5? Почему так происходит?
Решение:
vagrant@vagrant:~$ bash 5>&1
vagrant@vagrant:~$ echo netology > /proc/$$/fd/5
netology
команда bash 5>&1 создает в текущей сессии консоли дескриптор, перенаправляя с 5 в stdout

8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв 
при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout 
команды слева от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами 
через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
Решение:
vagrant@vagrant:~$ ls -l dddd.txt test/ 2>&1 | grep such -c
1
vagrant@vagrant:~$ ls -l dddd.txt test/ | grep such -c
ls: cannot access 'dddd.txt': No such file or directory
0
vagrant@vagrant:~$ ls -l dddd.txt test/ 5>&2 2>&1 1>&5 | grep such -c
test/:
total 8
-rw-rw-r-- 1 vagrant vagrant 339 Oct 16 21:28 file_stdin.txt
-rw-rw-r-- 1 vagrant vagrant 138 Oct 17 22:11 file_stdout.txt
1
stdout перенаправляется через временный дескриптор 5 в stderr, а поток stderr передается на 
вход второй команды grep

9. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию 
вывод?
Решение:
Будут выведены переменные окружения.
Можно получить тоже самое (только с разделением по переменным по строкам):
  printenv
  env

10. Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe.
Решение:
/proc/<PID>/cmdline - этот файл содержит полную командную строку запуска процесса, кроме тех 
процессов, что полностью ушли в своппинг, а также зомби. В этих двух случаях в файле ничего нет, 
то есть чтение этого файла вернет 0 символов.
/proc/<PID>/exe - содержит ссылку до файла запущенного для процесса <PID>, запуск этого файла, 
запустит еще одну копию самого файла.
cat /proc/<PID>/exe - выведет содержимое запущенного файла, 
                        
11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с 
помощью /proc/cpuinfo.
Решение:
Оба ядра процессора поддерживают SSE4_2. 
vagrant@vagrant:~$ cat /proc/cpuinfo | grep sse
   flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush 
mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid 
tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx 
rdrand hypervisor lahf_lm abm invpcid_single pti fsgsbase avx2 invpcid md_clear flush_l1d
   flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush 
mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid
tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx 
rdrand hypervisor lahf_lm abm invpcid_single pti fsgsbase avx2 invpcid md_clear flush_l1d

12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. 
Это можно подтвердить командой tty, которая упоминалась в лекции 3.2. Однако:
vagrant@netology1:~$ ssh localhost 'tty'
not a tty
Почитайте, почему так происходит, и как изменить поведение.
Решение:
Во многих источниках предлагается решение, путем внесения изменения в Vagrantfile:
config.vm.provision "fix-no-tty", type: "shell" do |s|
   s.privileged = false
   s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
end
У меня не сработало. Единственное что помогло ssh -t localhost 'tty'

13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. 
Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, 
который вы запустили по ошибке в обычной SSH-сессии.
Решение:
- переводим процесс в фоновый режим: bg
- Устанавливаем разрешение на трасировку. Устанавливаем значение 0 в файле 
/proc/sys/kernel/yama/ptrace_scope
- disown <name_of_process> Далее вам нужно будет изолировать дочерний процесс от родительского 
процесса.
- переходим в screen. reptyr $ ( pgrep <name_of_process>) - переносим процесс в screen.
После этого можно закрывать ssh не боясь завершения процесса.

14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, 
так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем.
Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. 
Узнайте что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.
Решение:
Команда tee делает вывод в файл или файлы, указанные в качестве параметра. 
В примере команда получает вывод из stdin, перенаправленный через pipe от stdout команды echo.  
Команда tee запущена от sudo, соотвественно имеет права на запись в файл.