#!/bin/bash

## Set Var .env

## DOMAIN SERVER
DOMAIN=$1
## LDAP PORT (defualt: 389)
LDAP_PORT=$2
## BACKEND API PORT (default: 3000)
PORT=$3
## ADMIN USER LDAP SERVER
ADMINUSER=$4
## PASSWORD LDAP SERVER
PASSWORD=$5

## generate .env file
echo 'DOMAIN='${DOMAIN}'
LDAP_PORT='${LDAP_PORT}'
ADMINUSER='${ADMINUSER}'
PASSWORD='${PASSWORD}'
PORT='${PORT}'' >"authUser/apiauth-javascript/src/.env"

## generate .env file
echo 'DOMAIN='${DOMAIN}'
LDAP_PORT='${LDAP_PORT}'
ADMINUSER='${ADMINUSER}'
PASSWORD='${PASSWORD}'
PORT='${PORT}'' >"authUser/.env"


## run docker container 
function runContainer() {

    ## docker compose up container
    echo "Docker pull redis"
    docker pull redis

    echo "run docker redis"
    docker run -d --name redis -p 6379:6379 redis

    # docker-compose -f ./authUser/docker-compose.yaml up -d

}

runContainer

cd authUser
docker-compose up -d
