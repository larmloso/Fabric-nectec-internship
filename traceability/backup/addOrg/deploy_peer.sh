#!/bin/bash
export PATH=./bin:$PATH
export FABRIC_CFG_PATH=./config

domain=$1
volume=$2
peerport=$3
cport=$4

# Create Peer and Orderer
function dockerComposeUp() {
    docker-compose -f docker/docker-compose.yaml -f docker/docker-compose-couch.yaml up -d
}

python3 ./docker/edit_yaml.py peer ${volume} peer0.${domain} ${peerport} ${cport}

python3 ./docker/edit_yaml.py couch ${domain}

# python3 ./docker/edit_yaml.py configtx ${volume} Org3MSP

# Deploy Peer and Orderer
dockerComposeUp
sleep 2
docker ps -a
sleep 2


