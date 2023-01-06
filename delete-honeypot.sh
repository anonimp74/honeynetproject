#!/bin/bash
sudo docker-compose down
sudo docker image rm -f $(sudo docker image ls -q)
sudo docker volume rm -f $(sudo docker volume ls -q)
exit 0
