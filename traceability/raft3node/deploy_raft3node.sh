#!/bin/bash
export PATH=./bin:$PATH
export FABRIC_CFG_PATH=./config

while [[ $# -ge 1 ]]; do
    key="$1"
    case $key in
    --domain1)
        domain1="$2"
        shift
        ;;
    --domain2)
        domain2="$2"
        shift
        ;;
    -v | --volume)
        volume="$2"
        shift
        ;;
    --peerport1)
        peerport1="$2"
        shift
        ;;
    --peerport2)
        peerport2="$2"
        shift
        ;;
    --port1)
        port1="$2"
        shift
        ;;
    --port2)
        port2="$2"
        shift
        ;;
    --port3)
        port3="$2"
        shift
        ;;
    --admport1)
        admport1="$2"
        shift
        ;;
    --admport2)
        admport2="$2"
        shift
        ;;
    --admport3)
        admport3="$2"
        shift
        ;;
    esac
    shift
done


# Create Peer and Orderer
function dockerComposeUp() {
    docker-compose -f docker/docker-compose.yaml -f docker/docker-compose-couch.yaml up -d
    docker-compose -f docker/docker-compose-couch.yaml up -d
}

# Genesisblock Create channel
function createChannel() {
    echo 'createChannel'
    sudo rm -rf ./channel-artifacts/*
    configtxgen -profile TwoOrgsApplicationGenesis -outputBlock ./channel-artifacts/mychannel.block -channelID mychannel
}


# Orderer join channel
function joinChannelNode1() {
    osnadmin channel join --channel-id mychannel \
        --config-block ./channel-artifacts/mychannel.block \
        -o ${domain1}:${admport1} --ca-file ${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain1}/msp/tlscacerts/tlsca.example.com-cert.pem \
        --client-cert ${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain1}/tls/server.crt \
        --client-key ${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain1}/tls/server.key
}

function joinChannelNode2() {
    osnadmin channel join --channel-id mychannel \
        --config-block ./channel-artifacts/mychannel.block \
        -o ${domain1}:${admport2} --ca-file ${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain1}/msp/tlscacerts/tlsca.example.com-cert.pem \
        --client-cert ${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain1}/tls/server.crt \
        --client-key ${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain1}/tls/server.key
}

function joinChannelNode3() {
    osnadmin channel join --channel-id mychannel \
        --config-block ./channel-artifacts/mychannel.block \
        -o ${domain1}:${admport3} --ca-file ${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain1}/msp/tlscacerts/tlsca.example.com-cert.pem \
        --client-cert ${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain1}/tls/server.crt \
        --client-key ${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain1}/tls/server.key
}

# Peer join channel
function joinPeer() {
    CORE_PEER_TLS_ENABLED=true CORE_PEER_LOCALMSPID=Org1MSP \
    CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain1}/tls/ca.crt \
    CORE_PEER_MSPCONFIGPATH=${PWD}/${volume}/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
    CORE_PEER_ADDRESS=${domain1}:${peerport1} \
    FABRIC_CFG_PATH=./config \
    peer channel join -b \
    ./channel-artifacts/mychannel.block
}

python3 ./docker/edit_yaml.py configtx ${volume} ${port1} ${port2} ${port3} ${peerport1} ${peerport2} ${domain1} ${domain2}

sudo mv docker/configtx.yaml config/configtx.yaml

python3 ./docker/edit_yaml.py orderer ${volume} ${port1} ${port2} ${port3} ${admport1} ${admport2} ${admport3} ${domain1}

python3 ./docker/edit_yaml.py peer ${volume} peer0.${domain1} ${peerport1} 7052

python3 ./docker/edit_yaml.py couch ${domain1}



# Genesisblock Create channel
createChannel

# Deploy Peer and Orderer
dockerComposeUp
sleep 2
docker ps -a

# Orderer join channel
joinChannelNode1
joinChannelNode2
joinChannelNode3

sleep 2
# Peer join channel
joinPeer

