#!/bin/bash 

## Upload file to server

ssh root@larmdev.ga "mkdir authUser"
scp -r apiauth-javascript root@larmdev.ga:authUser/apiauth-javascript
scp -r docker-compose.yaml root@larmdev.ga:authUser
ssh root@larmdev.ga "bash -s" -- <./env.sh larmdev.ga 389 3000 admin pass

