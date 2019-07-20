#!/bin/bash

function docker_ip(){
  docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
}

MASTER_IP=$(docker_ip redis-master)
SLAVE_1_IP=$(docker_ip redis-slave-1)
SLAVE_2_IP=$(docker_ip redis-slave-2)

#echo 'init status:ip---container':
#echo $MASTER_IP---redis-master
#echo $SLAVE_1_IP---redis-slave-1
#echo $SLAVE_2_IP---redis-slave-2
echo ------------------------------------------------
echo Now status of sentinel
echo ------------------------------------------------
docker exec redis-sentinel-1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redis-sentinel-1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
echo ------------------------------------------------

echo Stop redis master
echo $MASTER_IP---redis-master
echo $SLAVE_1_IP---redis-slave-1
echo $SLAVE_2_IP---redis-slave-2
read -p "Which container do you want to restart?" -e CONTAINER
docker pause $CONTAINER
echo Wait for 10 seconds
sleep 10
echo Current infomation of sentinel
docker exec redis-sentinel-1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redis-sentinel-1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster


echo ------------------------------------------------
echo Restart Redis master
docker unpause $CONTAINER
sleep 5
echo Current infomation of sentinel
docker exec redis-sentinel-1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redis-sentinel-1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
