# Домашнее задание к занятию 8.1 «Введение в Ansible»

---

## Задание 1

Попробуйте запустить playbook на окружении из test.yml, зафиксируйте значение, которое имеет факт some_fact для 
указанного хоста при выполнении playbook.

Решение:

Запускаем playbook командой: ansible-playbook site.yml -i ./inventory/test.yml  
Скриншот выполнения команды:

![1.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_8%2FPractice_8.1%2F1.png)

some_fact = 12 ( Task [Print fact] )



## Задание 2

Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его 
на all default fact.

Решение:

В первом пункте some_fact = 12. Данное значение среди файлов в папке group_vars найдено в файле ./group_vars/all/examp.yml.
В нем заменено значение переменной с 12 на "all default fact".  
Ниже вывод содержимого файла.  

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ cat ./group_vars/all/examp.yml
---
  some_fact: "all default fact"(venv) 
````


## Задание 3

Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших 
испытаний.

Решение:

Для организации окружения используются:  
    - Готовый образ centos:centos7
    - Соберем самостоятельно vedernikovaa/ubuntu2004:v1

<details><summary>Содержание Dockerfile для сборки окружения Ubuntu</summary>

````
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y python3

CMD ["/bin/bash"]
````
</details>

Собираем контейнер:  
````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook/Docker$ sudo docker build -t vedernikovaa/ubuntu2004:v1 .
[+] Building 60.9s (7/7) FINISHED                                                                                                                              
 => [internal] load build definition from Dockerfile                                                                                                      0.3s
 => => transferring dockerfile: 123B                                                                                                                      0.0s
 => [internal] load .dockerignore                                                                                                                         0.2s
 => => transferring context: 2B                                                                                                                           0.0s
 => [internal] load metadata for docker.io/library/ubuntu:20.04                                                                                          17.2s
 => [auth] library/ubuntu:pull token for registry-1.docker.io                                                                                             0.0s
 => [1/2] FROM docker.io/library/ubuntu:20.04@sha256:db8bf6f4fb351aa7a26e27ba2686cf35a6a409f65603e59d4c203e58387dc6b3                                     9.6s
 => => resolve docker.io/library/ubuntu:20.04@sha256:db8bf6f4fb351aa7a26e27ba2686cf35a6a409f65603e59d4c203e58387dc6b3                                     0.2s
 => => sha256:88bd6891718934e63638d9ca0ecee018e69b638270fe04990a310e5c78ab4a92 2.30kB / 2.30kB                                                            0.0s
 => => sha256:db8bf6f4fb351aa7a26e27ba2686cf35a6a409f65603e59d4c203e58387dc6b3 1.13kB / 1.13kB                                                            0.0s
 => => sha256:b795f8e0caaaacad9859a9a38fe1c78154f8301fdaf0872eaf1520d66d9c0b98 424B / 424B                                                                0.0s
 => => sha256:ca1778b6935686ad781c27472c4668fc61ec3aeb85494f72deb1921892b9d39e 27.50MB / 27.50MB                                                          7.7s
 => => extracting sha256:ca1778b6935686ad781c27472c4668fc61ec3aeb85494f72deb1921892b9d39e                                                                 1.0s
 => [2/2] RUN apt-get update && apt-get install -y python3                                                                                               32.6s
 => exporting to image                                                                                                                                    1.0s
 => => exporting layers                                                                                                                                   1.0s
 => => writing image sha256:40985bc33b875721b95bb7fdd426b46749596a85c8fdd9d7164aa51d6be3b85a                                                              0.0s
 => => naming to docker.io/vedernikovaa/ubuntu2004:v1                                                                                                     0.0s
````

Запускаем окружение Ubuntu и Centos7

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook/Docker$ sudo docker run --name centos7 -d centos:centos7 sleep 3600
02d493e1173d3edb7ab98b9bc6b6b59112a295d696383f57034e0611b53ac81c
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook/Docker$ sudo docker run --name ubuntu -d vedernikovaa/ubuntu2004:v1 sleep 3600
91a5661fa23113ba747f5e34c4c993c55f99d581d117e7f1b29fd9b9fdec50fc
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook/Docker$ sudo docker ps
CONTAINER ID   IMAGE                        COMMAND        CREATED          STATUS          PORTS     NAMES
91a5661fa231   vedernikovaa/ubuntu2004:v1   "sleep 3600"   8 seconds ago    Up 7 seconds              ubuntu
02d493e1173d   centos:centos7               "sleep 3600"   41 seconds ago   Up 40 seconds             centos7

````


## Задание 4

Проведите запуск playbook на окружении из prod.yml. Зафиксируйте полученные значения some_fact для каждого из 
managed host.

Решение:

Запускаем playbook на окружении из prod.yml командой ansible-playbook site.yml -i ./inventory/prod.yml

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ ansible-playbook site.yml -i ./inventory/prod.yml

PLAY [Print os facts] *****************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ***********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ****************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

````


## Задание 5

Добавьте факты в group_vars каждой из групп хостов так, чтобы для some_fact получились значения: 
для deb — deb default fact, для el — el default fact.

Решение:

Заменены. Ниже содержание файлов examp.yml  

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ cat ./group_vars/deb/examp.yml
---
  some_fact: "deb default fact"(

(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ cat ./group_vars/el/examp.yml
---
  some_fact: "el default fact"(venv) 
````


## Задание 6

Повторите запуск playbook на окружении prod.yml. Убедитесь, что выдаются корректные значения для всех хостов.

Решение:

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ ansible-playbook site.yml -i ./inventory/prod.yml

PLAY [Print os facts] *****************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ***********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ****************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

````


## Задание 7

При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology.

Решение:

Шифрование файлов осуществляется командой: ansible-vault encrypt <name_file>

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ ansible-vault encrypt ./group_vars/el/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ ansible-vault encrypt ./group_vars/deb/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ 

````


## Задание 8

Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в 
работоспособности.

Решение:

Для запуска playbook нужно добавить ключ --ask-vault-pass.  
Ниже выдержка из консоли.  

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ ansible-playbook site.yml -i ./inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] *****************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ***********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ****************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

````


## Задание 9

Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node.

Решение:

Посмотреть список плагинов можнно командой:  
ansible-doc -t connection -l  

Для работы на control node подходит:  
ansible.builtin.local          execute on controller


## Задание 10

В prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.

Решение:

В файл prod.yml добавлен блок для подключения к localhost.  

<details><summary>Содержание файла prod.yml</summary>

````
---
  el:
    hosts:
      centos7:
        ansible_connection: docker

  deb:
    hosts:
      ubuntu:
        ansible_connection: docker

  local:
    hosts:
      localhost:
        ansible_connection: local
````
</details>

В директорию group_vars добавлена директория local, в которой создается examp.yml.  

<details><summary>Содержание файла prod.yml</summary>

````
---
  some_fact: "local default fact"
````
</details>

## Задание 11

Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь, что 
факты some_fact для каждого из хостов определены из верных group_vars.

Решение:

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ ansible-playbook site.yml -i ./inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] *****************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ***********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] *********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "local default fact"
}

PLAY RECAP ****************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

````



## Задание 12

Заполните README.md ответами на вопросы. Сделайте git push в ветку master. В ответе отправьте ссылку на ваш открытый 
репозиторий с изменённым playbook и заполненным README.md.

Решение:

````

1. Где расположен файл с `some_fact` из второго пункта задания?
    - group_vars/all/examp.yml

2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?
    - ansible-playbook -i inventory/test.yml site.yml

3. Какой командой можно зашифровать файл?
    - ansible-vault encrypt group_vars/el/examp.yml

4. Какой командой можно расшифровать файл?
    - ansible-vault decrypt group_vars/el/examp.yml

5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?
    - ansible-vault view group_vars/el/examp.yml

6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?
    - ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass

7. Как называется модуль подключения к host на windows?
    - winrm

8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh
    - ansible-doc -t connection ssh

9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?
    - remote_user
````

## Задание 13

При помощи ansible-vault расшифруйте все зашифрованные файлы с переменными.

Решение:

Для расшифровывания файла нужно воспользоваться командой: ansible-vault decrypt ./group_vars/el/examp.yml

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ ansible-vault decrypt ./group_vars/el/examp.yml
Vault password: 
Decryption successful
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ ansible-vault decrypt ./group_vars/deb/examp.yml
Vault password: 
Decryption successful

````


## Задание 14

Зашифруйте отдельное значение PaSSw0rd для переменной some_fact паролем netology. Добавьте полученное значение 
в group_vars/all/examp.yml.

Решение:

Создаем файл test.yml с одним значением PaSSw0rd. Далее запускаем шифрование файла:  
````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ ansible-vault encrypt ./group_vars/secret.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful

````

Далее содержимое файла переносим в group_vars/all/examp.yml

<details><summary>Содержимое файла ./group_vars/all/examp.yml</summary>

````
---
  some_fact: !vault |
    $ANSIBLE_VAULT;1.1;AES256
    37356231653138613237643765336332326630336133333262313030386163323932616339623664
    3763626164373538623737386233373131643765376266330a373939363161623037613163616136
    35396437323962346565616363376666666662363034353064373338626561663933353636393832
    3938363234633838300a333364656136306262393636626233346165356134343765313535386437
    3435
````
</details>


## Задание 15

Запустите playbook, убедитесь, что для нужных хостов применился новый fact.

Решение:

Для проверки запускаем playbook с использованием ./inventory/test.yml

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ ansible-playbook site.yml -i ./inventory/test.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] *****************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ***********************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] *********************************************************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP ****************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

````


## Задание 16

Добавьте новую группу хостов fedora, самостоятельно придумайте для неё переменную. В качестве образа можно 
использовать этот [вариант](https://hub.docker.com/r/pycontribs/fedora).

Решение:

В файле Prod.yml добавляем описание группы fedora.  

<details><summary>Содержимое файла Prod.yml</summary>

````
---
  el:
    hosts:
      centos7:
        ansible_connection: docker

  deb:
    hosts:
      ubuntu:
        ansible_connection: docker

  local:
    hosts:
      localhost:
        ansible_connection: local

  fed:
    hosts:
      fedora:
        ansible_connection: docker
````
</details>

Создаем директорию ./group_vars/fed и так же файл examp.yml с переменной.  
Запускаем докер контейнер с Fedora.  
Запускаем Playbook в окружении Prod. Ниже результат запуска.  

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.1/playbook$ ansible-playbook site.yml -i ./inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] *****************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [fedora]
ok: [centos7]

TASK [Print OS] ***********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Debian"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] *********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "local default fact"
}
ok: [fedora] => {
    "msg": "fed default fact"
}

PLAY RECAP ****************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
````


## Задание 17

Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

Решение:

В файле организована проверка на статус docker контейнера. С соотвествующим сценарием запуска контейнера. 

<details><summary>Ниже содержимое скрипта [Started_Ansible_Prod.sh]</summary>

````
#!/bin/bash

Started_docker ()
{
# Проверка выполнения контейнера
  if [ $( docker inspect -f {{.State.Running}} $1) = "true" ];
  then
    echo "Container '$1' is already running."
  else
    if [ $( docker inspect -f {{.State.Status}} $1) = "exited" ]
    then
      docker start $1
      echo "Container '$1' started successfully."
    else
      docker run --name $1 -d $2 sleep 3600
      echo "Container '$1' started successfully."
    fi
  fi
}


Started_docker "ubuntu" "vedernikovaa/ubuntu2004:v1"
Started_docker "centos7" "centos:centos7"
Started_docker "fedora" "pycontribs/fedora:latest"
sleep 8
ansible-playbook site.yml -i ./inventory/prod.yml --ask-vault-pass
docker stop "ubuntu"
docker stop "centos7"
docker stop "fedora"
````
</details>

