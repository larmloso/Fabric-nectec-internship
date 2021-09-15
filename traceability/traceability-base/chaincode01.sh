export PATH=./bin:$PATH
export FABRIC_CFG_PATH=./config

domain1=$1
domain2=$2

cd docker/chaincode-typescript

npm install

npm run build

cd ../..

peer version

peer lifecycle chaincode package \
    basic.tar.gz --path \
    docker/chaincode-typescript/ \
    --lang node --label basic_1.0
# Org1
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.${domain1}/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=${domain1}:7051

peer lifecycle chaincode install basic.tar.gz
# org2

export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.${domain2}/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=${domain2}:9051

peer lifecycle chaincode install basic.tar.gz
# all
peer lifecycle chaincode queryinstalled

export CC_PACKAGE_ID=$(peer \
    lifecycle chaincode \
    queryinstalled | sed 1d | cut \
    -d' ' -f3 | cut -d',' -f1)

peer lifecycle chaincode \
    approveformyorg -o \
    ${domain1}:7050 \
    --ordererTLSHostnameOverride \
    orderer1.${domain1} \
    --channelID mychannel --name \
    basic --version 1.0 \
    --package-id $CC_PACKAGE_ID \
    --sequence 1 --tls --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.${domain1}/msp/tlscacerts/tlsca.example.com-cert.pem

# org1
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.${domain1}/tls/ca.crt
export CORE_PEER_ADDRESS=${domain1}:7051

peer lifecycle chaincode \
    approveformyorg -o \
    ${domain1}:7050 \
    --ordererTLSHostnameOverride \
    orderer1.${domain1} \
    --channelID mychannel --name \
    basic --version 1.0 \
    --package-id $CC_PACKAGE_ID \
    --sequence 1 --tls --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.${domain1}/msp/tlscacerts/tlsca.example.com-cert.pem


# all
peer lifecycle chaincode \
    checkcommitreadiness \
    --channelID mychannel --name \
    basic --version 1.0 --sequence \
    1 --tls --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.${domain1}/msp/tlscacerts/tlsca.example.com-cert.pem \
    --output json

peer lifecycle chaincode commit -o \
    ${domain1}:7050 \
    --ordererTLSHostnameOverride \
    orderer1.${domain1} \
    --channelID mychannel --name \
    basic --version 1.0 --sequence \
    1 --tls --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.${domain1}/msp/tlscacerts/tlsca.example.com-cert.pem \
    --peerAddresses ${domain1}:7051 \
    --tlsRootCertFiles \
    ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.${domain1}/tls/ca.crt \
    --peerAddresses ${domain2}:9051 \
    --tlsRootCertFiles \
    ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.${domain2}/tls/ca.crt

peer lifecycle chaincode \
    querycommitted --channelID \
    mychannel --name basic \
    --cafile \
    ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.${domain1}/msp/tlscacerts/tlsca.example.com-cert.pem
