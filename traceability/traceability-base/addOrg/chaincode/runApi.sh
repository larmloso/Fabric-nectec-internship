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

# docker stop api
# docker rm api

echo "create generate ccp..."
chmod +x ./ccp/*
./ccp/ccp-generate.sh ${domain} ${caname} ${ORG} ${PORT}

echo "ccp generate success"

createImage

