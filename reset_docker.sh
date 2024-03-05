#!/bin/bash

# remove all containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# remove all images 
docker rmi $(docker images -a -q)

# remove all volumes 
docker volume rm $(docker volume ls -q)

# remove networks 
docker network prune
