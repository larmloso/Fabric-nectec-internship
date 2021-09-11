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
PASSWORD='${PASSWORD}'
PORT='${PORT}'' > "apiauth-javascript/src/.env"


