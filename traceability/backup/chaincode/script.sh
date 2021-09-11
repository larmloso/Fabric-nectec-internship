
domain1=$1
domain2=$2
portApi=$3
org1=$4
org2=$5
ChannelName=mychannel
chaincodeName=basic

./envAPI.sh ${portApi} ${ChannelName} ${chaincodeName} Org1MSP 1 
scp -r ./chaincode root@${domain1}:

./envAPI.sh ${portApi} ${ChannelName} ${chaincodeName} Org2MSP 2 
scp -r ./chaincode root@${domain2}:

cd ccp
dos2unix *
cd ..

scp -r ./ccp root@${domain1}:
scp -r ./ccp root@${domain2}:


echo "Deploy chaincode"
ssh root@${domain2} "bash -s" -- < ./chaincode.sh ${domain1} ${domain2} ${chaincodeName}

echo "setting Api Server1"
ssh root@${domain1} "bash -s" -- < ./runApi.sh ${domain1} ${portApi} ${org1} 1 7051

echo "setting Api Server2"
ssh root@${domain2} "bash -s" -- < ./runApi.sh ${domain2} ${portApi} ${org2} 2 9051
