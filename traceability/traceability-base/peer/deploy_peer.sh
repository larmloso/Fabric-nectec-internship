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
    docker-compose -f docker/docker-compose-couch.yaml up -d
}


# Peer join channel
function joinPeer() {
    CORE_PEER_TLS_ENABLED=true CORE_PEER_LOCALMSPID=Org2MSP \
    CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/${volume}/peerOrganizations/org2.example.com/peers/peer0.${domain}/tls/ca.crt \
    CORE_PEER_MSPCONFIGPATH=${PWD}/${volume}/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp \
    CORE_PEER_ADDRESS=${domain}:${peerport} \
    FABRIC_CFG_PATH=./config \
    peer channel join -b \
    ./channel-artifacts/mychannel.block
}

python3 ./docker/edit_yaml.py peer ${volume} peer0.${domain} ${peerport} ${cport}

python3 ./docker/edit_yaml.py couch ${domain}

# Deploy Peer and Orderer
dockerComposeUp
sleep 2
docker ps -a
sleep 2

# Peer join channel
joinPeer

