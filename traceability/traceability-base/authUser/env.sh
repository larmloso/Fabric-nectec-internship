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


DC1=$(echo ${DOMAIN} | cut -d "." -f1)
DC2=$(echo ${DOMAIN} | cut -d "." -f2)


## generate .env file
echo 'DOMAIN='${DOMAIN}'
LDAP_PORT='${LDAP_PORT}'
ADMINUSER='${ADMINUSER}'
PASSWORD='${PASSWORD}'
DC1='${DC1}'
DC2='${DC2}'
PORT='${PORT}'' >"authUser/apiauth-javascript/src/.env"

## generate .env file
echo 'DOMAIN='${DOMAIN}'
LDAP_PORT='${LDAP_PORT}'
ADMINUSER='${ADMINUSER}'
PASSWORD='${PASSWORD}'
DC1='${DC1}'
DC2='${DC2}'
PORT='${PORT}'' >"authUser/.env"


## RUN DOCKER CONTAINER
cd authUser
docker-compose up --build -d
