#!/bin/bash


DOMAIN1=$1
PORT1=$2

DOMAIN2=$3
PORT2=$4

DOMAIN3=$5
PORT3=$6


## create configxt file
function createConfigtxDir() {
    mkdir addOrg3MSP
    echo "
    Organizations:
    - 
        ID: Org3MSP
        MSPDir: ../organizations/peerOrganizations/org3.example.com/msp
        Name: Org3MSP
        Policies:
            Admins:
                Rule: OR('Org3MSP.admin')
                Type: Signature
            Endorsement:
                Rule: OR('Org3MSP.peer')
                Type: Signature
            Readers:
                Rule: OR('Org3MSP.admin', 'Org3MSP.peer', 'Org3MSP.client')
                Type: Signature
            Writers:
                Rule: OR('Org3MSP.admin', 'Org3MSP.client')
                Type: Signature" >addOrg3MSP/configtx.yaml

}



## config update channel
function configChannel() {
    export PATH=./bin:$PATH
    export FABRIC_CFG_PATH=./config

    cd addOrg3MSP

    export FABRIC_CFG_PATH=$PWD
    ../bin/configtxgen -printOrg Org3MSP >../organizations/peerOrganizations/org3.example.com/org3.json

    cd ..
    export PATH=${PWD}/./bin:$PATH
    export FABRIC_CFG_PATH=${PWD}/./config/
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.${DOMAIN1}/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=${DOMAIN1}:${PORT1}

    #### PORT ****

    peer channel fetch config channel-artifacts/config_block.pb -o ${DOMAIN1}:7050 \
        --ordererTLSHostnameOverride orderer1.${DOMAIN1} -c mychannel \
        --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.${DOMAIN1}/msp/tlscacerts/tlsca.example.com-cert.pem

    cd channel-artifacts

    configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json

    jq .data.data[0].payload.data.config config_block.json >config.json

    jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Org3MSP":.[1]}}}}}' config.json ../organizations/peerOrganizations/org3.example.com/org3.json >modified_config.json

    configtxlator proto_encode --input config.json --type common.Config --output config.pb

    configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb

    configtxlator compute_update --channel_id mychannel --original config.pb --updated modified_config.pb --output org3_update.pb

    configtxlator proto_decode --input org3_update.pb --type common.ConfigUpdate --output org3_update.json

    echo '{"payload":{"header":{"channel_header":{"channel_id":"'mychannel'", "type":2}},"data":{"config_update":'$(cat org3_update.json)'}}}' | jq . >org3_update_in_envelope.json

    configtxlator proto_encode --input org3_update_in_envelope.json --type common.Envelope --output org3_update_in_envelope.pb

    cd ..

    peer channel signconfigtx -f channel-artifacts/org3_update_in_envelope.pb

    export PATH=${PWD}/./bin:$PATH
    export FABRIC_CFG_PATH=${PWD}/./config/
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.${DOMAIN2}/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=${DOMAIN2}:${PORT2}

    peer channel update -f channel-artifacts/org3_update_in_envelope.pb -c mychannel -o ${DOMAIN1}:8050 \
        --ordererTLSHostnameOverride orderer2.${DOMAIN1} \
        --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.${DOMAIN1}/msp/tlscacerts/tlsca.example.com-cert.pem

    export PATH=${PWD}/./bin:$PATH
    export FABRIC_CFG_PATH=${PWD}/./config/
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.${DOMAIN3}/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    export CORE_PEER_ADDRESS=${DOMAIN3}:${PORT3}


    peer channel fetch 0 channel-artifacts/mychannel.block -o ${DOMAIN1}:8050 --ordererTLSHostnameOverride orderer2.${DOMAIN1} \
        -c mychannel --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.${DOMAIN1}/msp/tlscacerts/tlsca.example.com-cert.pem

    peer channel join -b channel-artifacts/mychannel.block

    sleep 2


    export CORE_PEER_GOSSIP_USELEADERELECTION=true
    export CORE_PEER_GOSSIP_ORGLEADER=false

    export PATH=./bin:$PATH
    export FABRIC_CFG_PATH=./config

    peer channel fetch config channel-artifacts/config_block.pb -o ${DOMAIN1}:7050 \
        --ordererTLSHostnameOverride orderer1.${DOMAIN1} -c mychannel --tls \
        --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.${DOMAIN1}/msp/tlscacerts/tlsca.example.com-cert.pem

    cd channel-artifacts

    export PATH=${PWD}/../bin:$PATH
    export FABRIC_CFG_PATH=${PWD}/../config/

    configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json

    jq .data.data[0].payload.data.config config_block.json >config.json

    jq '.channel_group.groups.Application.groups.Org3MSP.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "peer0.'${DOMAIN3}'","port": '${PORT3}'}]},"version": "0"}}' config.json >modified_anchor_config.json

    configtxlator proto_encode --input config.json --type common.Config --output config.pb

    configtxlator proto_encode --input modified_anchor_config.json --type common.Config --output modified_anchor_config.pb

    configtxlator compute_update --channel_id mychannel --original config.pb --updated modified_anchor_config.pb --output anchor_update.pb

    configtxlator proto_decode --input anchor_update.pb --type common.ConfigUpdate --output anchor_update.json

    echo '{"payload":{"header":{"channel_header":{"channel_id":"mychannel", "type":2}},"data":{"config_update":'$(cat anchor_update.json)'}}}' | jq . >anchor_update_in_envelope.json

    configtxlator proto_encode --input anchor_update_in_envelope.json --type common.Envelope --output anchor_update_in_envelope.pb

    cd ..

    export PATH=./bin:$PATH
    export FABRIC_CFG_PATH=./config

    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.${DOMAIN3}/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    export CORE_PEER_ADDRESS=${DOMAIN3}:${PORT3}

    peer channel update -f channel-artifacts/anchor_update_in_envelope.pb -c mychannel -o ${DOMAIN1}:7050 \
        --ordererTLSHostnameOverride orderer1.${DOMAIN1} --tls \
        --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.${DOMAIN1}/msp/tlscacerts/tlsca.example.com-cert.pem
}
createConfigtxDir
configChannel
