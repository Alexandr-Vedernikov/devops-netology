# Домашнее задание к занятию 8.4 «Работа с roles»

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачайте себе эту роль.
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---

Ответ:

1) Роль [Clickhouse](https://github.com/Alexandr-Vedernikov/clickhouse-role.git)

2) Роль [Vector](https://github.com/Alexandr-Vedernikov/vector-role.git)

3) Роль [Lighthouse](https://github.com/Alexandr-Vedernikov/lighthouse-role.git)

4) Описание requirements.yml и использование ролей в playbook

[requirements.yml](playbook%2Frequirements.yml)

<details><summary> Содержание вывода консоли ( ansible-galaxy install -r requirements.yml) </summary>

````
home@pc:~/DevOps обучение/practice/Раздел_8/Practice_8.4/playbook$ ansible-galaxy install -r requirements.yml
Starting galaxy role install process
- extracting clickhouse-role to /home/home/.ansible/roles/clickhouse-role
- clickhouse-role (main) was installed successfully
- extracting lighthouse-role to /home/home/.ansible/roles/lighthouse-role
- lighthouse-role was installed successfully
- extracting vector-role to /home/home/.ansible/roles/vector-role
- vector-role was installed successfully
````
</details>


5) [Playbook](playbook%2Fsite.yml)

<details><summary> Вывод консоли при запуске playbook ( ansible-playbook -i ./inventory/prod.yml site.yml) </summary>

````
home@pc:~/DevOps обучение/practice/Раздел_8/Practice_8.4/playbook$ ansible-playbook -i ./inventory/prod.yml site.yml

PLAY [Install ClickHouse] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [clickhouse-0]

TASK [Install ClickHouse] ***********************************************************************************************************************************************************************

TASK [clickhouse-role : Get clickhouse distrib (rpm noarch package)] ****************************************************************************************************************************
changed: [clickhouse-0] => (item=clickhouse-common-static)
changed: [clickhouse-0] => (item=clickhouse-server)
changed: [clickhouse-0] => (item=clickhouse-client)

TASK [clickhouse-role : Install clickhouse packages] ********************************************************************************************************************************************
changed: [clickhouse-0]

TASK [clickhouse-role : Flush handlers] *********************************************************************************************************************************************************

RUNNING HANDLER [clickhouse-role : Start clickhouse service] ************************************************************************************************************************************
changed: [clickhouse-0]

TASK [clickhouse-role : Flush handlers] *********************************************************************************************************************************************************

TASK [clickhouse-role : Create database] ********************************************************************************************************************************************************
changed: [clickhouse-0]

PLAY [Install Vector] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [vector-0]

TASK [Install Vector] ***************************************************************************************************************************************************************************

TASK [vector-role : Add clickhouse addresses to /etc/hosts] *************************************************************************************************************************************
changed: [vector-0] => (item=clickhouse-0)

TASK [vector-role : Get vector distrib] *********************************************************************************************************************************************************
changed: [vector-0]

TASK [vector-role : Install vector package] *****************************************************************************************************************************************************
changed: [vector-0]

TASK [vector-role : Create vector config] *******************************************************************************************************************************************************
changed: [vector-0]

RUNNING HANDLER [vector-role : Start Vector service] ********************************************************************************************************************************************
changed: [vector-0]

PLAY [Install Lighthouse] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [lighthouse-0]

TASK [Install Lighthouse] ***********************************************************************************************************************************************************************

TASK [lighthouse-role : Add clickhouse addresses to /etc/hosts] *********************************************************************************************************************************
changed: [lighthouse-0] => (item=clickhouse-0)

TASK [lighthouse-role : Install epel-release package] *******************************************************************************************************************************************
changed: [lighthouse-0]

TASK [lighthouse-role : Update repositories] ****************************************************************************************************************************************************
changed: [lighthouse-0]

TASK [lighthouse-role : Install Nginx and Unzip] ************************************************************************************************************************************************
changed: [lighthouse-0]

TASK [lighthouse-role : Get lighthouse distrib] *************************************************************************************************************************************************
changed: [lighthouse-0]

TASK [lighthouse-role : Create directory] *******************************************************************************************************************************************************
changed: [lighthouse-0]

TASK [lighthouse-role : Unpack lighthouse archive] **********************************************************************************************************************************************
changed: [lighthouse-0]

TASK [lighthouse-role : NGINX | Create file for lighthouse config] ******************************************************************************************************************************
changed: [lighthouse-0]

TASK [lighthouse-role : Lighthouse | Create lighthouse config] **********************************************************************************************************************************
changed: [lighthouse-0]

TASK [lighthouse-role : NGINX | Create general config] ******************************************************************************************************************************************
changed: [lighthouse-0]

RUNNING HANDLER [lighthouse-role : Start nginx service] *****************************************************************************************************************************************
changed: [lighthouse-0]

PLAY RECAP **************************************************************************************************************************************************************************************
clickhouse-0               : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
lighthouse-0               : ok=12   changed=11   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-0                   : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

````
</details>