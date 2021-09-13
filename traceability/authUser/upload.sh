#!/bin/bash 

## Upload file to server

## DOMAIN SERVER
DOMAIN=larmdev.ml
## LDAP PORT (defualt: 389)
LDAP_PORT=389
## BACKEND API PORT (default: 3000)
PORT=3000
## ADMIN USER LDAP SERVER
ADMINUSER=admin
## PASSWORD LDAP SERVERF
PASSWORD=pass

## DIR authUser
ssh root@${DOMAIN} "mkdir authUser"
## UPLOADS FILE 
scp -r apiauth-javascript root@${DOMAIN}:authUser/apiauth-javascript
## UPLOADS DOKCER-COMPOSE FILE
scp -r docker-compose.yaml root@${DOMAIN}:authUser
## SET ENV
ssh root@${DOMAIN} "bash -s" -- <./env.sh ${DOMAIN} ${LDAP_PORT} ${PORT} ${ADMINUSER} ${PASSWORD}

