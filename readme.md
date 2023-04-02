# Домашнее задание к занятию 7.1 "Введение в Terraform"

---

## Чеклист готовности к домашнему заданию

1) Скачайте и установите актуальную версию terraform(не менее 1.3.7). Приложите скриншот вывода 
команды terraform --version  
2) Скачайте на свой ПК данный git репозиторий. Исходный код для выполнения задания расположен в 
директории 01/src.  
3) Убедитесь, что в вашей ОС установлен docker  

Решение:

Скриншот с пупктами из чеклиста 

![check_list.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_7%2FPractice_7.1%2Fcheck_list.png)


## Задание 1

1. Перейдите в каталог src. Скачайте все необходимые зависимости, использованные в проекте. 
2. Изучите файл .gitignore. В каком terraform файле допустимо сохранить личную, секретную информацию? 
3. Выполните код проекта. Найдите в State-файле секретное содержимое созданного ресурса random_password. Пришлите 
его в качестве ответа.   
4. Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла main.tf. Выполните команду terraform 
validate. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.   
5. Выполните код. В качестве ответа приложите вывод команды docker ps   
6. Замените имя docker-контейнера в блоке кода на hello_world, выполните команду terraform apply -auto-approve. 
Объясните своими словами, в чем может быть опасность применения ключа -auto-approve ?   
7. Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла 
terraform.tfstate.   
8. Объясните, почему при этом не был удален docker образ nginx:latest ?(Ответ найдите в коде проекта или документации)  


Решение:

1) Для скачивания и установки всех зависимостей необходимо запустить команду terraform init и дождаться успешного 
ее выполнения.   

<details><summary>Вывод консоли после ввода команды terraform init</summary>

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_7/Practice_7.1/src$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding kreuzwerker/docker versions matching "~> 3.0.1"...
- Finding latest version of hashicorp/random...
- Installing kreuzwerker/docker v3.0.2...
- Installed kreuzwerker/docker v3.0.2 (unauthenticated)
- Installing hashicorp/random v3.4.3...
- Installed hashicorp/random v3.4.3 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

╷
│ Warning: Incomplete lock file information for providers
│ 
│ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the following providers:
│   - hashicorp/random
│   - kreuzwerker/docker
│ 
│ The current .terraform.lock.hcl file only includes checksums for linux_amd64, so Terraform running on another platform will fail to install these providers.
│ 
│ To calculate additional checksums for another platform, run:
│   terraform providers lock -platform=linux_amd64
│ (where linux_amd64 is the platform to generate)
╵

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_7/Practice_7.1/src$
````

</details>

2) В файле .gitignore указываются исключения (файлы или дириктории), которые не попадают в commit и при последующем push
они не загружаются в репозиторий. Секретная личная информация хранится в файле personal.auto.tfvars

3) Выполнение кода запускается командой terraform apply.     
Секретная строка из terraform.tfstate:  
"result": "30pO4HSWuaQsli0d"

4) Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла main.tf. Выполните команду terraform 
validate. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.

   - 

````
Error: Missing name for resource
│ 
│   on main.tf line 24, in resource "docker_image":
│   24: resource "docker_image" {
│ 
│ All resource blocks must have 2 labels (type, name).
````
В загалоке ресурса указан только его тип. Нужно указать еще имя. 
Например: 
````
resource "docker_image" "my_nginx" {
  name         = "nginx:latest"
  keep_locally = true
````

   - 

````
 Error: Invalid resource name
│ 
│   on main.tf line 29, in resource "docker_container" "1nginx":
│   29: resource "docker_container" "1nginx" {
````

Имя должно начинаться с буквы или знака подчеркивания и может содержать только буквы, цифры, знаки подчеркивания 
и тире.  
Например: 
````
resource "docker_container" "my_1nginx" {
  image = docker_image.my_nginx.name # Попутно в данной строке нужно обновить привязку к ресурсу docker_image
````

   - 

А таг же необходимо заполнить блок provider "docker" {}

````
provider "docker" {
  registry_auth {
    address = var.docker_address
    username = var.docker_username
    password = var.docker_password
  }
}
````

5) Выполните код. В качестве ответа приложите вывод команды docker ps 

![5.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_7%2FPractice_7.1%2F5.png)

6) Замените имя docker-контейнера в блоке кода на hello_world, выполните команду terraform apply -auto-approve. 
Объясните своими словами, в чем может быть опасность применения ключа -auto-approve ?

Использование ключа `terraform apply -auto-approve` может быть опасным, поскольку он будет автоматически 
применять изменения к вашей инфраструктуре без запроса подтверждения. Это означает, что любые ошибки или 
неправильная конфигурация в коде Terraform могут привести к непреднамеренным изменениям в вашей инфраструктуре, 
что может стать причиной простоя или потери данных.

7) Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла 
terraform.tfstate. 
Удаление созданных ресурсов производится с помощью команды terraform destroy. Содержание файла terraform.tfstate:
````
{
  "version": 4,
  "terraform_version": "1.4.2",
  "serial": 43,
  "lineage": "f9a46cfc-c528-d292-11b5-cbc6a71c6aa7",
  "outputs": {},
  "resources": [],
  "check_results": null
}
````

8) Объясните, почему при этом не был удален docker образ nginx:latest? (Ответ найдите в коде проекта или документации)

По умолчанию Terraform destroy не удаляет образы Docker созданные вне terraform. Однако если код Terraform 
содержит инструкции по созданию или управлению образами Docker, и эти ресурсы определены как часть инфраструктуры, 
тогда Terraform destroy также удалит эти образы Docker.  

В тексте проекта создаются две сущности:  
resource "docker_image" "my_nginx" {}  
resource "docker_container" "nginx_my" {}  

При этом при выполнении команды terraform destroy удаляется контейнер "nginx_my".  
При этом docker image "my_nginx" не удаляется, т.к. в ресурсе есть деректива keep_locally = true. Если бы ее не 
было, тогда удалиться и image.