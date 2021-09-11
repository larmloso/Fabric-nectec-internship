domain=$1
portApi=$3
MSP=$4
caname=$5
org=$6
ChannelName=mychannel
chaincodeName=basic_2

./envAPI.sh ${portApi} ${ChannelName} ${chaincodeName} ${MSP} ${org}

./envAPI.sh ${portApi} ${ChannelName} ${chaincodeName} ${MSP} ${org} 
scp -r ./chaincode root@${domain}:

cd ccp
dos2unix *
cd ..

scp -r ./ccp root@${domain}:

echo "setting Api Server${org}"
ssh root@${domain} "bash -s" -- < ./runApi.sh ${domain} ${portApi} ${caname} ${org} 


# ./addAPI.sh example.com 3500 Org3MSP fabric-ca 3