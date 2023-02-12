# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами."

---

## Задание 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

Решение:

- Паттерн "Инфраструктура как код" - это подход к конфигурированию инфраструктуры как процессу программирования. Такой 
подход обеспечивает повторяемость, идентичность результатов и ускорение процесса настройки инфраструктуры.  
Основные преимущества:  
    -- Сокращение времени от идеи до внедрения в продакшн. Автоматизация сборки, настройки среды для тестирования и 
внедрения в продакшн.  
    -- Стабильность конфигураций. Результат развертываемой среды всегда одинаков.  
    -- Сокращение сроков разработки. Автоматизация процессов различных этапов разработки (тестирования, интеграции и 
внедрения).  
- Идемпотентность - это св-во объекта или операции, при котором получаемый результат идентичен результатам при любой 
выполнения количестве их выполнения.      

## Задание 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

Решение:

- Ansible отличается от других систем управления конфигурациями:  
    * Конфигурации пишутся используя Python, что обеспечивает низкий порог входа.  
    * Метод развертывания - Push и нет агента. Конфигурация серверу отправляется управляющим сервером.  
- На мой взгляд более надежный вариант конфигурации систем - Push. 
    * Единый центр управления конфигурациями.  
    * Метод Pull требует наличия агента на конфигурируемом сервере. Доп. ПО это всегда возможная точка отказа.   

## Задача 3

Установить на личный компьютер:

- VirtualBox  
- Vagrant  
- Ansible  

Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.  

Решение:
- VirtualBox
````
home@home:~/Vagrant$ virtualbox -h
Oracle VM VirtualBox VM Selector v6.1.38
(C) 2005-2022 Oracle Corporation
All rights reserved.
No special options.
If you are looking for --startvm and related options, you need to use VirtualBoxVM.
````
- Vagrant
````
home@home:~/Vagrant$ vagrant version
Installed Version: 2.3.4

Vagrant was unable to check for the latest version of Vagrant.
Please check manually at https://www.vagrantup.com
````
- Ansible
```
home@home:~/Vagrant$ ansible --version
ansible [core 2.14.1]
  config file = None
  configured module search path = ['/home/home/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/home/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.10.9 (main, Dec  7 2022, 13:47:07) [GCC 12.2.0] (/usr/bin/python3)
  jinja version = 3.0.3
  libyaml = True
```
## Задача 4

Воспроизвести практическую часть лекции самостоятельно:  
- Создать виртуальную машину.  
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды docker ps  

Решение:

Файлы настроек:  
    - [Vagrantfile](Vagrantfile)  
    - [playbook.yml](playbook.yml)  
    - [ansible.cfg](ansible.cfg)  
    - [./inventory/hosts](inventory/hosts)  

Вывод при запуске VM и проверка выполнения сценария ansible  
````
home@home:~/Vagrant$ vagrant up
Bringing machine 'TestServer1' up with 'virtualbox' provider...
==> TestServer1: Checking if box 'bento/ubuntu-20.04' version '202206.03.0' is up to date...
==> TestServer1: Clearing any previously set forwarded ports...
==> TestServer1: Clearing any previously set network interfaces...
==> TestServer1: Preparing network interfaces based on configuration...
    TestServer1: Adapter 1: nat
    TestServer1: Adapter 2: bridged
==> TestServer1: Forwarding ports...
    TestServer1: 22 (guest) => 20000 (host) (adapter 1)
    TestServer1: 22 (guest) => 2222 (host) (adapter 1)
==> TestServer1: Running 'pre-boot' VM customizations...
==> TestServer1: Booting VM...
==> TestServer1: Waiting for machine to boot. This may take a few minutes...
    TestServer1: SSH address: 127.0.0.1:2222
    TestServer1: SSH username: vagrant
    TestServer1: SSH auth method: private key
    TestServer1: Warning: Remote connection disconnect. Retrying...
    TestServer1: Warning: Connection reset. Retrying...
==> TestServer1: Machine booted and ready!
==> TestServer1: Checking for guest additions in VM...
==> TestServer1: Setting hostname...
==> TestServer1: Configuring and enabling network interfaces...
==> TestServer1: Mounting shared folders...
    TestServer1: /vagrant => /home/home/Vagrant
==> TestServer1: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> TestServer1: flag to force provisioning. Provisioners marked to run always will still run.
home@home:~/Vagrant$ vagrant provision 
==> TestServer1: Running provisioner: ansible...
    TestServer1: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [TestServer1]

TASK [Create directory for ssh-key] ********************************************
ok: [TestServer1]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
ok: [TestServer1]

TASK [Checking DNS] ************************************************************
changed: [TestServer1]

TASK [Installing tools] ********************************************************
ok: [TestServer1] => (item=git)
ok: [TestServer1] => (item=curl)
changed: [TestServer1] => (item=mc)

TASK [Installing docker] *******************************************************
changed: [TestServer1]

TASK [Add the current user to docker group] ************************************
ok: [TestServer1]

PLAY RECAP *********************************************************************
TestServer1                : ok=7    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

home@home:~/Vagrant$ vagrant ssh
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-110-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Tue 17 Jan 2023 10:07:00 PM UTC

  System load:  1.11               Users logged in:          0
  Usage of /:   13.8% of 30.63GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 12%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.1.30
  Processes:    134


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Tue Jan 17 22:06:44 2023 from 10.0.2.2
vagrant@TestServer1:~$ mc

vagrant@TestServer1:~$ docker version
Client: Docker Engine - Community
 Version:           20.10.22
 API version:       1.41
 Go version:        go1.18.9
 Git commit:        3a2c30b
 Built:             Thu Dec 15 22:28:08 2022
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.22
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.18.9
  Git commit:       42c8b31
  Built:            Thu Dec 15 22:25:58 2022
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.15
  GitCommit:        5b842e528e99d4d4c1686467debf2bd4b88ecd86
 runc:
  Version:          1.1.4
  GitCommit:        v1.1.4-0-g5fd4c4d
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
  
vagrant@TestServer1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
````