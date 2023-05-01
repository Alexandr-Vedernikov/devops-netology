# Домашнее задание к занятию 8.2 «Работа с Playbook»

---
## Подготовка инфраструктуры

1) Создаем с помощью Vagrant 2-е ноды на базе Centos7. 
    - Clickhouse, IP:192.168.1.200
    - Vector, IP:192.168.1.201
   <details><summary>Vagrantfile</summary>

   ````
   # -*- mode: ruby -*-
   # vi: set ft=ruby :
   
   $clickhouse_name = "clickhouse"
   $clickhouse_ip = "192.168.1.200"
   $vector_name = "vector"
   $vector_ip = "192.168.1.201"
   $iso = "./centos7.box"
   
   Vagrant.configure("2") do |config|
     config.vm.define $clickhouse_name do |config|
     config.vm.network "public_network", bridge: "wlo1", ip: $clickhouse_ip
       config.vm.provider "virtualbox" do |vb|
         vb.cpus = "2"
         vb.memory = "4096"
       end
       config.vm.box = $iso
       config.vm.hostname = $clickhouse_name
   
       config.vm.provision "shell", inline: <<-SHELL
         yum install -y python3
       SHELL
   
       end
     end
   
   Vagrant.configure("2") do |config|
     config.vm.define $vector_name do |config|
       config.vm.provider "virtualbox" do |vb|
         vb.cpus = "2"
         vb.memory = "4096"
       end
       config.vm.box = $iso
       config.vm.hostname = $vector_name
       config.vm.network "public_network", bridge: "wlo1", ip: $vector_ip
   
       config.vm.provision "shell", inline: <<-SHELL
         yum install -y python3
       SHELL
   
       end
     end
   ````
   </details>


2) <details><summary>Устанавливаем/обновляем python</summary>
   
   ````
   config.vm.provision "shell", inline: <<-SHELL
     yum install -y python3
   SHELL
   ````
   </details>


3) <details><summary>Проверяем доcтупность нод для ansibl.</summary>

   ````
   home@home:~/Vagrant$ ansible -u vagrant -m ping all
   vector | SUCCESS => {
       "changed": false,
       "ping": "pong"
   }
   clickhouse | SUCCESS => {
       "changed": false,
       "ping": "pong"
   }
   ````
</details>


## Задание 1

Подготовьте свой inventory-файл prod.yml.

Решение:

В prod.yml добавлены ip адреса и ссылки на файлы с ключами 

<details><summary> Содержимое prod.yml</summary>

````
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 192.168.1.200
      ansible_ssh_private_key_file: ./.vagrant/machines/clickhouse/virtualbox/private_key
vector:
  hosts:
    vector-01:
      ansible_host: 192.168.1.201
      ansible_ssh_private_key_file: ./.vagrant/machines/vector/virtualbox/private_key
````
</details>


## Задания

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает vector.
3. При создании tasks рекомендую использовать модули: get_url, template, unarchive, file.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.

Решение:

<details><summary>__________XXXXX_________</summary>

````
- name: Install and configure Vector
    hosts: vector
    handlers:
      - name: Start Vector service
        become: true
        ansible.builtin.service:
          name: vector
          state: restarted

    tasks:
      - name: Add clickhouse addresses to /etc/hosts
        become: true
        lineinfile:
          dest: /etc/hosts
          regexp: '.*{{ item }}$'
          line: "{{ hostvars[item].ansible_host }} {{item}}"
          state: present
        when: hostvars[item].ansible_host is defined
        with_items: "{{ groups.clickhouse }}"
      - name: Get vector distrib
        ansible.builtin.get_url:
          url: "https://packages.timber.io/vector/latest/vector-{{ vector_version }}.x86_64.rpm"
          dest: "./vector-{{ vector_version }}.x86_64.rpm"

      - name: Install vector package
        become: true
        ansible.builtin.yum:
          name:
            - "./vector-{{ vector_version }}.x86_64.rpm"

      - name: Redefine vector config name
        tags: vector_config
        become: true
        ansible.builtin.lineinfile:
          path: /etc/default/vector
          regexp: 'VECTOR_CONFIG='
          line: VECTOR_CONFIG=/etc/vector/config.yaml

      - name: Create vector config
        tags: vector_config
        become: true
        ansible.builtin.copy:
          dest: /etc/vector/config.yaml
          content: |
            {{ vector_config | to_nice_yaml(indent=2) }}

        notify: Start Vector service
````
</details>


## Задания 

5. Запустите ansible-lint site.yml и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом --check.
7. Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.

Решение:

````
home@home:~/Vagrant$ ansible-playbook site.yml

PLAY [Install Clickhouse] ********************************************************************************

TASK [Gathering Facts] ***********************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib (rpm noarch package)] *******************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 3, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib (rpm package)] **************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ***********************************************************************
changed: [clickhouse-01]

TASK [Flush handlers] ************************************************************************************

RUNNING HANDLER [Start clickhouse service] ***************************************************************
changed: [clickhouse-01]

TASK [Create database] ***********************************************************************************
changed: [clickhouse-01]

PLAY [Install and configure Vector] **********************************************************************

TASK [Gathering Facts] ***********************************************************************************
ok: [vector-01]

TASK [Add clickhouse addresses to /etc/hosts] ************************************************************
changed: [vector-01] => (item=clickhouse-01)

TASK [Get vector distrib] ********************************************************************************
changed: [vector-01]

TASK [Install vector package] ****************************************************************************
changed: [vector-01]

TASK [Redefine vector config name] ***********************************************************************
changed: [vector-01]

TASK [Create vector config] ******************************************************************************
changed: [vector-01]

RUNNING HANDLER [Start Vector service] *******************************************************************
changed: [vector-01]

PLAY RECAP ***********************************************************************************************
clickhouse-01              : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=6    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
````


## Задание 8

Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.

Решение:


````
home@home:~/Vagrant$ ansible-playbook site.yml --diff

PLAY [Install Clickhouse] ********************************************************************************

TASK [Gathering Facts] ***********************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib (rpm noarch package)] *******************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 3, "gid": 1000, "group": "vagrant", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "vagrant", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib (rpm package)] **************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ***********************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] ************************************************************************************

TASK [Create database] ***********************************************************************************
ok: [clickhouse-01]

PLAY [Install and configure Vector] **********************************************************************

TASK [Gathering Facts] ***********************************************************************************
ok: [vector-01]

TASK [Add clickhouse addresses to /etc/hosts] ************************************************************
ok: [vector-01] => (item=clickhouse-01)

TASK [Get vector distrib] ********************************************************************************
ok: [vector-01]

TASK [Install vector package] ****************************************************************************
ok: [vector-01]

TASK [Redefine vector config name] ***********************************************************************
ok: [vector-01]

TASK [Create vector config] ******************************************************************************
ok: [vector-01]

PLAY RECAP ***********************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

````


## Задание 9

Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть 
параметры и теги.

Решение:

После указания имени блоков, добавил комментарий (#) с описанием каждого блока. 

````
---
  - name: Install Clickhouse
    hosts: clickhouse
    handlers:
      - name: Start clickhouse service
        # Хендлер. Блок выполнение которого возможно только при явном его вызове. Он выполняется после всех tasks.
        # Здесь происходит перезагрузка серверной части сервиса Clickhouse
        become: true
        ansible.builtin.service:
          name: clickhouse-server
          state: restarted
    tasks:
    # в блоке tasks создается структура "-block: ... rescue: ... always:". Суть структуры: если задачи из block завершеются
    # с в ошибкой, тогда не происходит остановки выполнения playbook, выполнение передается в блок rescue. После него
    # выполнение задач переходит в блок always. Задачи из данного блока выполняются всегда. 
      - block:
        - name: Get clickhouse distrib (rpm noarch package)
          # Задача получает их репозитория "noarch.rpm" пакеты. Пакеты нужны подбираются для серверной, клентской и 
          # исполняемые файлы Clickhouse. Версия пакета и составные части берутся из файла переменных vars.yml
          # Название частей (клиент, сервер, исполняемые файлы) для которых производится подбор пакета произфодит в цикле  
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
        rescue:
          - name: Get clickhouse distrib (rpm package)
            # Если в предыдущем блоке возникли ошибки, тогда пытаемся подобрать для исполняемой части x86_64.rpm нужной версии.
            ansible.builtin.get_url:
              url: https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm
              dest: ./clickhouse-common-static-{{ clickhouse_version }}.rpm
        always:
          - name: Install clickhouse packages
            # Устанавливаем скаченные пакеты
            become: true
            ansible.builtin.yum:
              name:
                - clickhouse-common-static-{{ clickhouse_version }}.rpm
                - clickhouse-client-{{ clickhouse_version }}.rpm
                - clickhouse-server-{{ clickhouse_version }}.rpm
            notify: Start clickhouse service
            # Строкой выше запускаем хендлер. Перезгружаем демон clickhouse-server.
            # Строкой ниже информируем о ходе процесса перезапуски демона
          - name: Flush handlers
            meta: flush_handlers
          - name: Create database
            # Создание БД для принятия логов. ДБ создается выполнения поманды на настраиваемой ноде
            ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
            register: create_db
            failed_when: create_db.rc != 0 and create_db.rc !=82
            changed_when: create_db.rc == 0

  - name: Install and configure Vector
    hosts: vector
    handlers:
      - name: Start Vector service
        # Хендлер. Блок выполнение которого возможно только при явном его вызове. Он выполняется после всех tasks.
        # Здесь происходит перезагрузка Vector
        become: true
        ansible.builtin.service:
          name: vector
          state: restarted

    tasks:
      - name: Add clickhouse addresses to /etc/hosts
        # Добавляем связь между нодами c Vector и Clickhouse, прописывая в hosts файл имени сервер(а/ов) Сlickhouse.
        become: true
        lineinfile:
          dest: /etc/hosts
          regexp: '.*{{ item }}$'
          line: "{{ hostvars[item].ansible_host }} {{item}}"
          state: present
        when: hostvars[item].ansible_host is defined
        with_items: "{{ groups.clickhouse }}"
      - name: Get vector distrib
        # скачиваем установочный пакет vector. Версию дистрибутива берем из файла с переменными (vars.yml)
        ansible.builtin.get_url:
          url: "https://packages.timber.io/vector/latest/vector-{{ vector_version }}.x86_64.rpm"
          dest: "./vector-{{ vector_version }}.x86_64.rpm"

      - name: Install vector package
        # Установка реннее скаченного файла
        become: true
        ansible.builtin.yum:
          name:
            - "./vector-{{ vector_version }}.x86_64.rpm"

      - name: Redefine vector config name
        # Получаем путь к файлу с конфигурацией Vector
        tags: vector_config
        become: true
        ansible.builtin.lineinfile:
          path: /etc/default/vector
          regexp: 'VECTOR_CONFIG='
          line: VECTOR_CONFIG=/etc/vector/config.yaml

      - name: Create vector config
        # Правим конфииигурацию Vector. Эталонную конфигурацию берем из vars.yml. Меняем "рабочуюю" конфигурацию по строчно" 
        tags: vector_config
        become: true
        ansible.builtin.copy:
          dest: /etc/vector/config.yaml
          content: |
            {{ vector_config | to_nice_yaml(indent=2) }}

        notify: Start Vector service
````