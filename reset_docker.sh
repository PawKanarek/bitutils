#!/bin/bash
source print.sh
source activate_conda.sh

activate_conda "bittensor"

print "docker rm $(docker ps -a -q)"
if [ "$(docker ps -a -q)" ]; then
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
else
    print "No containers to remove"
fi

print "docker rmi $(docker images -a -q)"
if [ "$(docker images -a -q)" ]; then
    docker rmi $(docker images -a -q)
else
    print "No images to remove"
fi

print "docker volume rm $(docker volume ls -q)"
if [ "$(docker volume ls -q)" ]; then
    docker volume rm $(docker volume ls -q)
else
    print "No volumes to remove"
fi

print "docker network prune"
docker network prune

print "docker container prune"
docker container prune

print "docker volume prune"
docker volume prune

print "docker system prune --all --volumes --force"
docker system prune --all --volumes --force