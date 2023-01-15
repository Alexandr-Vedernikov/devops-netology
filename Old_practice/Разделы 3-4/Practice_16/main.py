#!/usr/bin/env python3

import yaml
import json
import socket
import time as t
import datetime as dt

wait = 3   #задержка между проверки IP
srv = { "drive.google.com" : "0.0.0.0", "mail.google.com" : "0.0.0.0", "google.com" : "0.0.0.0" }

# Формируем словарь текущих значений ip адресов
for host in srv:
    srv[host] = socket.gethostbyname(host)

# Функция записи текущих IP в YAML файл
def wr_yaml (name_file):
    with open(name_file, 'wb') as fw:
        yaml.safe_dump(srv, fw, default_flow_style=False, explicit_start=True, explicit_end=True,
                       allow_unicode=True, encoding='utf-8', indent=2)

# Функция записи текущих IP в JSON файл
def wr_json (name_file):
    with open(name_file, 'w', encoding='utf-8') as f:
        json.dump(srv, f, ensure_ascii=False, indent=4)

wr_yaml('test.yaml')
wr_json('test.json')

out_while = 1
while out_while == 1:
    for host in srv:
        ip = socket.gethostbyname(host)
        if ip != srv[host]:
            print(str(dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) + ' [ERROR] ' + str(host) + \
                  ' IP mistmatch: ' + srv[host] + ' ' + ip)
            srv[host] = ip
            wr_yaml('test.yaml')
            wr_json('test.json')
            #out_while = 0  # Если раскомментировать, тогда бесконечный цикл будет прерываться при изменении ip любого
                            # из адресов серверов.
            break
    t.sleep(wait)
