port=$1
channel=$2
chaincode=$3
msp=$4
org=$5

echo 'PORT='${port}'
ChannelName='${channel}'
ChaincodeName='${chaincode}'
MSPOrg='${msp}'
CAorg=ca.org'${org}'.example.com
Org='${org}'
Department=org'${org}'.department1' > "chaincode/application-typescript/.env"

# ./envAPI.sh 3500 mychannel basic Org1MSP 1