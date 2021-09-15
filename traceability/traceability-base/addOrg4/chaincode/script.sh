
# domain1=$1
# portApi=$2
# org1=$4
# ChannelName=mychannel
# chaincodeName=basic

DOMAIN1=larmdev.ml
DOMAIN2=larmdev.ga
DOMAIN3=larmdev.cf
PORT1=7051
PORT2=9051
PORT3=11051
portApi=3500
ChannelName=mychannel
chaincodeName=basic
org=fabric-ca

endpoint=http://larmdev.cf:3000


./envAPI.sh ${portApi} ${ChannelName} ${chaincodeName} Org3MSP 3 ${endpoint}
scp -r ./chaincode root@${DOMAIN3}:


cd ccp
dos2unix *
cd ..

scp -r ./ccp root@${DOMAIN3}:


echo "Deploy chaincode"
ssh root@${DOMAIN1} "bash -s" -- < ./chaincode.sh ${DOMAIN1} ${DOMAIN2} ${DOMAIN3} ${PORT1} ${PORT2} ${PORT3}


echo "setting Api Server 3"
ssh root@${DOMAIN3} "bash -s" -- < ./runApi.sh ${DOMAIN3} ${portApi} ${org} 3 11051



