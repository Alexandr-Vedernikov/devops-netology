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