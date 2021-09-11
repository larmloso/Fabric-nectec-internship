#!/bin/bash

DOMAIN1=$1
DOMAIN2=$2
DOMAIN3=$3
PORT1=$4
PORT2=$5
PORT3=$6


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH=./bin:$PATH
export FABRIC_CFG_PATH=./config

cd chaincode/chaincode-javascript

npm install

cd ../..

peer lifecycle chaincode package basic.tar.gz --path ./chaincode/chaincode-javascript/ --lang node --label basic_2.0


export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.larmdev.ml/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=larmdev.ml:7051

peer lifecycle chaincode install basic.tar.gz

peer lifecycle chaincode queryinstalled

peer lifecycle chaincode queryinstalled | sed 1,2d | cut -d' ' -f3 | cut -d',' -f1

export CC_PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed 1,2d | cut -d' ' -f3 | cut -d',' -f1)

peer lifecycle chaincode \
    approveformyorg -o \
    larmdev.ml:7050 \
    --ordererTLSHostnameOverride \
    orderer1.larmdev.ml \
    --channelID mychannel --name \
    basic --version 2.0 \
    --package-id $CC_PACKAGE_ID \
    --sequence 2 --tls --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.larmdev.ml/msp/tlscacerts/tlsca.example.com-cert.pem


peer lifecycle chaincode \
    checkcommitreadiness \
    --channelID mychannel --name \
    basic --version 2.0 --sequence \
    2 --tls --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.larmdev.ml/msp/tlscacerts/tlsca.example.com-cert.pem \
    --output json


export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.larmdev.ga/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=larmdev.ga:9051

peer lifecycle chaincode install basic.tar.gz

# peer lifecycle chaincode queryinstalled

# export CC_PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed 1d | cut -d' ' -f3 | cut -d',' -f1)

peer lifecycle chaincode \
    approveformyorg -o \
    larmdev.ml:7050 \
    --ordererTLSHostnameOverride \
    orderer1.larmdev.ml \
    --channelID mychannel --name \
    basic --version 2.0 \
    --package-id $CC_PACKAGE_ID \
    --sequence 2 --tls --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.larmdev.ml/msp/tlscacerts/tlsca.example.com-cert.pem


peer lifecycle chaincode \
    checkcommitreadiness \
    --channelID mychannel --name \
    basic --version 2.0 --sequence \
    2 --tls --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.larmdev.ml/msp/tlscacerts/tlsca.example.com-cert.pem \
    --output json


export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.larmdev.cf/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
export CORE_PEER_ADDRESS=larmdev.cf:11051

peer lifecycle chaincode install basic.tar.gz

# peer lifecycle chaincode queryinstalled

# export CC_PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed 1d | cut -d' ' -f3 | cut -d',' -f1)

peer lifecycle chaincode \
    approveformyorg -o \
    larmdev.ml:7050 \
    --ordererTLSHostnameOverride \
    orderer1.larmdev.ml \
    --channelID mychannel --name \
    basic --version 2.0 \
    --package-id $CC_PACKAGE_ID \
    --sequence 2 --tls --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.larmdev.ml/msp/tlscacerts/tlsca.example.com-cert.pem


peer lifecycle chaincode \
    checkcommitreadiness \
    --channelID mychannel --name \
    basic --version 2 --sequence \
    2 --tls --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.larmdev.ml/msp/tlscacerts/tlsca.example.com-cert.pem \
    --output json

##


peer lifecycle chaincode commit -o \
    larmdev.ml:7050 \
    --ordererTLSHostnameOverride \
    orderer1.larmdev.ml \
    --channelID mychannel --name \
    basic --version 2.0 --sequence \
    2 --tls --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.larmdev.ml/msp/tlscacerts/tlsca.example.com-cert.pem \
    --peerAddresses larmdev.ml:7051 \
    --tlsRootCertFiles \
    ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.larmdev.ml/tls/ca.crt \
    --peerAddresses larmdev.ga:9051 \
    --tlsRootCertFiles \
    ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.larmdev.ga/tls/ca.crt \
    --peerAddresses larmdev.cf:11051 \
    --tlsRootCertFiles \
    ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.larmdev.cf/tls/ca.crt


peer lifecycle chaincode \
    querycommitted --channelID \
    mychannel --name basic \
    --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.larmdev.ml/msp/tlscacerts/tlsca.example.com-cert.pem

sleep 2
peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'
