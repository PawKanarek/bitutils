#!/bin/bash
source print.sh
source activate_conda.sh

activate_conda "bittensor"

print "Remove all containers"
if [ "$(docker ps -a -q)" ]; then
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
else
    print "No containers to remove"
fi


print "Remove all images"
if [ "$(docker images -a -q)" ]; then
    docker rmi $(docker images -a -q)
else
    print "No images to remove"
fi

print "Remove all volumes"
if [ "$(docker volume ls -q)" ]; then
    docker volume rm $(docker volume ls -q)
else
    print "No volumes to remove"
fi


print "Remove networks"
docker network prune
