domain=$1
portApi=$2
caname=$3
ORG=$4
PORT=$5

function createImage() {
    cp -r organizations/ chaincode/application-typescript/
    cd chaincode/application-typescript/
    docker build -t api .
    docker run -d -p ${portApi}:${portApi} --name api -t api 
}

echo "create generate ccp..."
chmod +x ./ccp/*
./ccp/ccp-generate.sh ${domain} ${caname} ${ORG} ${PORT}

ls ./organizations/peerOrganizations/org1.example.com
ls ./organizations/peerOrganizations/org2.example.com
echo "ccp generate success"

createImage

