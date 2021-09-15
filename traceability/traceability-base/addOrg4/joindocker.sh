#!/bin/bash

## join docker swarm

DOMAIN1=$1
DOMAIN_N=$2

export Token=$(ssh root@$DOMAIN1 docker swarm join-token manager | sed 1d)
echo $Token
ssh root@$DOMAIN_N $Token
