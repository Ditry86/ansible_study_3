# README к Домашнему заданию по занятию "7.3. Основы и принцип работы Терраформ".

Данный репозиторий содержит практическое решение для заданий по занятию "7.3. Основы и принцип работы Терраформ". 

В ходе реализации проекта в облаке Yandex создаются: VPC; 3 виртуальные машины (ВМ) с сервисами Clickhouse, Vector, Lighthouse; подсеть 192.168.10.0/24.

## Оглавление

1. [Содержание проекта](#содержание-проекта)
2. [Описание проекта. Руководство по реализации проекта](#описание-проекта-руководство-по-еализации-проекта)
3. [Описание playbook](#описание-playbook)
4. [Использование make-файла](#использование-make-файла)

---

## Содержание проекта

1. Каталог `terraform`. Структура файлов terraform для создания ВМ и соответствующего окружения в облаке Yandex:
  - Файл описания создаваемых инстансов (ВМ) - `instances.tf`;
  - Файл описания переменных (входные, выходные) - `vars.tf`;
  - Файл поисания VPC - `vpc.tf`;
  - Файл описания провайдера, облачного образа установки ОС - `version.tf`.
2. Каталог `playbook`. Структура файлов ansible для настройки ВМ и установки ПО на них:
  - Основной файл playbook - `site.yml`;
  - Директория `inventory` с файлом описания рабочей инфраструктуры - `prod.yml`;
  - Директория `group_vars` с файлами описания переменных для груп хостов: clickhouse, vector, lighthouse;
  - Директория `templates` с файлами щаблонов конфигураций ПО для хостов: nginx, vector;
3. Каталог auto. Файлы bash-скриптов для автоматизации выполнения операций по реализации задач проекта:
  - `install_env_app.sh` - скрипт проверки и установки неоходимого ПО на вашем ПК (control-node);
  - `init_cloud.sh` - скрипт настройки утилиты yc, инициализации подключения к облаку, создания сервисного аккаунта для работы с облаком;
  - `tf_provider_mirror.sh` - скрипт замены конфигурации провайдера yandex для `terraform` (установка провайлера с зеркала yandex);
  - `yc_env_var.sh` - скрипт добавления переменных окружения текущей облочки терминала для настройки и конфигурации работы утилиты `yc`;
  - `get_ip.sh` - скрипт считывания и записи во временные файлы (`local_ip`, `ext_ip`) информации об ip-адресах созданных вМ из переменных `tf_output`;
  - `ip_env_var.sh` - скрипт добавления переменных окружения текущей облочки терминала для хранения информации об ip-адресах созданных ВМ.
4. Корневой каталог так же содержит:
  - `Makefile` - make-файл с инструкциями для запуска bash-скриптов и добавления env var's, необходимых для работы yc, terraform, ansible;
  - `init.conf.example` - файл-шаблон конфигурации для автоматизации шагов по решению заданий проекта;
  - `yandex_provider.example` - файл-шаблон конфигурации провайдера yandex для terraform.

[Вернуться к Оглавлению](#оглавление)

---

## Описание проекта. Руководство по еализации проекта

Для выполнения задания необходимо развернуть три ВМ в Yandex Cloud. В данном проекте создание инфрастуктуры в облаке осуществляется с помощью terraform. Установка и настройка необходимого программного обеспечения производится с помощью ansible playbook.

### **Установка необходимого ПО на ваш ПК (control-node)**

Для загрузки проекта необходимо, чтобы на ОС вашего ПК стоял `git`. Перейдите в необходимый каталог вашей ОС и скопируйте проект с репозитория:

```
git clone http://github.com/ditry86/ansible_study_3.git
```

Для работы с облаком Yandex установите утилиту `yc` ([инструкция установки](https://cloud.yandex.ru/docs/cli/operations/install-cli))

Для создания ВМ в облаке и их настроек установите:
  - `terraform` ([инструкция установки](https://cloud.yandex.com/en-ru/docs/tutorials/infrastructure-management/terraform-quickstart#from-yc-mirror));
  - пакеты, необходимые для работы `ansible`: `python 3.6`, `pip`, `netaddr`;
  - `ansible` (установка либо через менеджер пакетов, либо через `pip`).

Так же для корректной работы ansible playbook может понадобится установить `ansible utils`:

```
ansible-galaxy collection install ansible.utils
```

### **Подгатовка к работе с облаком**

Для работы с облаком необходимо:
  1. Произвести настройки утилиты `yc`, инициализировать подключение к облаку ([см. инструкцию](https://cloud.yandex.ru/docs/cli/quickstart#initialize));
  2. Изменить конфигурацию провайдера ([см. инструкцию](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#configure-provider)), инициализировать terraform:
  ```
  cd terraform && terraform init
  ```
  
### **Создание ВМ и окружения в облаке**

Для реализации проекта в облаке с помощью `terraform` создаются три ВМ (Clickhouse-01, Vector-01, Lighthouse-01), VPC, локальная подсеть. Параметры каждой ВМ, локальной подсети указаны в локальных переменных, описанных в в файле `terraform/vars`:

```
locals {
    
    lans = {
        default = ["192.168.10.0/24"]
    }

    instances = { 
        "clickhouse" = {
            platform = "standard-v2",
            cores = 4,
            memory = 4
        },
        "vector" = {
            platform = "standard-v2",
            cores = 2,
            memory = 2
        },
        "lighthouse" = {
            platform = "standard-v1",
            cores = 2,
            memory = 2
        },
    }
}
```
Обрас ОС для развертывания ВМ в облаке - Centos 7 (yandex cloud image).

Для подключения к ВМ по ssh на основе образа от Yandex Cloud необходимо создать приватный и публичный ключ (который указан в описании создания ВМ в файле instances.tf):
```
ssh-keygen -t ed25519 -N ''
```
Пользователь для подключения по ssh к ВМ на основе данного образа - `centos`.

Для установки ВМ и окружения запустите:
```
terraform plan && terraform apply
``` 

При завершении работы `terraform` должен отобразить выходные переменные (описанные в файле vars.tf) с ip-адресами для каждой ВМ. 

### **Установка и настройка сервисов на ВМ**

Перед началом развертки сервисов на ВМ необходимо добавить в окружение текщей оболочки терминала переменные с ip-алресами ВМ. Это можно сделать через bash-скрипты:
```
source get_ip.sh
source ip_env_var.sh
```
либо вручную
```
export CLICKHOUSE_EXT_IP=<внешний IP-адрес ВМ Clickhouse>
export VECTOR_EXT_IP=<внешний IP-адрес ВМ Vector>
export LIGHTHOUSE_EXT_IP=<внешний IP-адрес ВМ Lighthouse>
export CLICKHOUSE_LOCAL_IP=<внутренний IP-адрес ВМ Clickhouse>
export VECTOR_LOCAL_IP=<внутренний IP-адрес ВМ Vector>
export LIGHTHOUSE_LOCAL_IP=<внутренний IP-адрес ВМ VeLighthousector>
```
Внешние IP-адреса ВМ используются для прямогоподключения ssh. Лакальные IP-адреса. Локальные IP-адреса используются для прямого подключения между собой сервисов, поднимаемых на ВМ.
  
Так же необходимо отключить опцию ansible проверки ключей подключения к хостам через добавление переменной окружения:
```
export ANSIBLE_HOST_KEY_CHECKING=False
```

После можно произвести установку и настройку ПО на созданных ВМ:
```
ansible-playbook site.yml -i inventory/prod.yml
```
[Вернуться к Оглавлению](#оглавление)

---

## Описание playbook

Playbook состаит из 4 play:
  1. `Prepare systems`. Предварительная настройка всех ВМ.
  Таски реализуют отключение `SElinux`, установку и запуск сервиса `firewalld`. После, с помощью handler, производится перезагрузка ВМ.
  2. `Deploy Clickhouse`. Развертка сервиса - СУБД `clickhouse` на ВМ `clickhouse-01`.
  С помощью первого таска производится загрузка необходимых пакетов clickhouse (использоуется секции block, rescue для обработки ошибки при загрузке ресурса). Далее идет установка скачанных .rpm пакетов.
  После производится настройка ОС: открытие tcp порта 8123; произвдится изменение конфигураций clickhouse: user.xml - включение SQL-ориентированного управления доступом для стандартного аккаунта default ([см. инструкцию](https://clickhouse.com/docs/ru/operations/access-rights)), config.xml: прослущивание clickhouse запросов с любых хостов. Далее производится запуск сервиса clickhouse.
  Последние таски производят создание БД хранения логов(по заданию), таблицу для записи логов, пользователя для удаленного подключения к данной БД.
  3. `Deploy Vector`. Развертка сервиса - брокера сообщений `vector` yf DV `vector-01`. Производится установка, настройка сервиса `vector` с помощью шаблона конфигурации `templates/vector.yml.j2, который в свою очередь составляется с помощью jinja2.
  4. `Deploy lighthouse`. Развертка сервиса удаленного управления БД clickhouse `lighthouse`. Вначале, при помощи pre_task. производится установка git, установка и настройка web-сервера nginx, открытие порта http на ОС. После чего производится перезагрузка ВМ, при помощи handlers. 
  Далее при помощи модуля ansible git производится копирование рабочей версии lighthouse c репозитория (https://github.com/VKCOM/lighthouse) в созданный каталог web-сервера `/data/www`.

Все вводные переменные для настройки ВМ перечислены в файлах `vars.yml`, находящихся в одноименных (по названиям ВМ) подкаталогах каталога `group_vars`:
  1. `group_vars/clickhouse/vars.yml`. Переменные: необходимая версия clickhouse, названия пакетов для загрузки, имя пользователя и пароль пользователя для удаленного подключения к БД, IP-адрес, с которого будет производится удаленное подключение к БД (хоста-источника сообщений для записи в БД, в нашем случае - локальный IP-адрес ВМ `vector-01`).
  2. `group_vars/vector/vars.yml`. Переменные: необходимая версия пакетов vector, директория конфигурации, имя пользователя и пароль пользователя для удаленного подключения к БД, хост БД (локальный IP-адрес ВМ `clickhouse-01`), конфигурация `bector` в виду сложного map.
  3. `group_vars/lighthouse/vars.yml`. Переменные: каталог конфигурации nginx, адрес репозитория lighthouse. 
Вся инфраструктура описана в файле `prod.yml` каталога `inventory`.

[Вернуться к Оглавлению](#оглавление)

---

## Использование make-файла.

Для удобства работы с проектом, вышеописанные сценарии работы можно произвести при помощи утилиты make.

>**Важно!** bash-скрипты, запускаемые через make-файл, созданы и протестированы для Centos (версии 7,8), Ubuntu (версии 20.04 и выше).

### **Сценарии (комманды), осуществляемые через make**:

**1. Установка необходимого ПО на вашем ПК (control node)**

Команда установки:

```
make install
```
Скрипт проверяет наличие установленного нобходимого ПО на ПК, устонавливает отсутствующее.
После отработки скрипта необходимо выполнить ``` source ~/.bashrc ``` для инициализации установленного ПО в оболочке вашей сессии терминала в системе, либо перезагрузить терминал.

**2. Подготовка вашего облака Yandex и переменных окружения на вашем ПК**

Для работы скриптов на данном шаге реализации проекта, необходимо в корневом каталоге проекта создать и заполнить файл конфигурации проекта - `init.conf` (пример находится в корне проекта под именем `init.conf.example`). В самом файле перечислены все необходимые для работы с облаком Yandex переменные: личный токен для подключения к API облака, clour_id, folder_id, зона облака для развертки инстансов, имя для сервисного аккаунта.
Комманда подготовки:

    make prepare.

Скрипты производят настройку облака при помощи yc (yandex CLI) на основе указанных переменных в файле `init.conf`. А так же прописывают переменные окружения для работы terraform, производят изменение конфигурационных файлов terraform для устаноки провайдера yandex cloud с зеркала yandex, и проводит инициализацию самого terraform для вашего проекта (в каталоге terraform).

**3. Развертка ВМ и окружения в облаке**
Команда развертки:
    
    make deploy

Соответствует командам terraform: plan, apply. Осуществляет развертку облачной инфраструктуры для проекта: 3 ВМ (), VPC, локальная подсеть.

**4. Запуск playbook**

Команда запуска playbook:

    make apps

Производится, по необходимости, установка необходимых модулей python и ansible. Далее запускается playbook для inventory `prod`.

**5. Удаление развернутого проекта**

Команда удаления окружения:

    make destroy

Удаляются все созданные ВМ, подсети в облаке, а так же удаляются все произведенные настройки yc на вашем ПК (control node) и в облаке. Удаляются временные файлы проекта.

[Вернуться к Оглавлению](#оглавление)
