domain=$1
portldap=$2
port=$3

echo 'domain='${domain}'
portldap='${portldap}'
port='${port}'' > "src/.env"

# ./envAPI.sh 3500 mychannel basic Org1MSP 1