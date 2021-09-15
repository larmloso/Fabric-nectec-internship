#!/bin/bash
. ./utils.sh

function swarmMode() {
    if [[ -z "$ipaddress1" || \
    -z "$domain1" || \
    -z "$domain2" ]]; then
        printHelp $MODE
    else
        echo "swarm"
        mkdir Downloads
        ssh root@$domain1 docker swarm init --advertise-addr $ipaddress1
        ssh root@$domain1 docker swarm join-token manager
        export Token=$(ssh root@$domain1 docker swarm join-token manager | sed 1d)
        echo $Token
        ssh root@$domain2 $Token
        ssh root@$domain1 docker network create --attachable --driver overlay my-net
    fi
}

function deployCAMode() {
    if [[ -z "$domain" || \
    -z "$volume" || \
    -z "$orgname" || \
    -z "$password" ]]; then
        printHelp $MODE
    else
        echo "deployCA"
        scp -r ./script_deploy_ca/edit_yaml.py root@$domain:edit_yaml.py
        ssh root@$domain "bash -s" -- < ./script_deploy_ca/deploy_ca.sh $orgname $password $volume $domain
    fi
}

function registerPeerMode() {
    if [[ -z "$domain" || \
    -z "$volume" || \
    -z "$orgname" || \
    -z "$admport" ]]; then
        printHelp $MODE
    else
        echo 'registerPeerMode'
        ssh root@$domain "bash -s" -- < ./peer/register_peer.sh $domain $volume $orgname $admport
        scp -r root@$domain:/root/$volume/peerOrganizations/org2.example.com ${PWD}/Downloads
    fi
}

function registerOrdererMode() {
    if [[ -z "$domain" || \
    -z "$volume" || \
    -z "$orgname" || \
    -z "$admport" ]]; then
        printHelp $MODE
    else
        echo 'registerOrdererMode'
        ssh root@$domain "bash -s" -- < ./raft3node/register_orderer.sh $domain $volume $orgname $admport
        scp -r root@$domain:/root/$volume/peerOrganizations/org1.example.com ${PWD}/Downloads
        scp -r root@$domain:/root/$volume/ordererOrganizations ${PWD}/Downloads
    fi
}

function deployRaft3NodeMode() {
    if [[ -z "$domain1" || \
    -z "$domain2" || \
    -z "$volume" || \
    -z "$peerport1" || \
    -z "$peerport2" || \
    -z "$port1" || \
    -z "$port2" || \
    -z "$port2" || \
    -z "$admport1" || \
    -z "$admport2" || \
    -z "$admport3" ]]; then
        printHelp $MODE
    else
        echo 'deployRaft3NodeMode'
        scp -r ./raft3node/docker root@$domain1:
        scp -r ./Downloads/org2.example.com root@$domain1:$volume/peerOrganizations/
        ssh root@$domain1 "bash -s" -- < ./raft3node/deploy_raft3node.sh \
            --domain1 $domain1 --domain2 $domain2 -v $volume --peerport1 $peerport1 --peerport2 $peerport2 \
            --port1 $port1 --port2 $port2 --port3 $port3 --admport1 $admport1 --admport2 $admport2 --admport3 $admport3
        scp -r root@$domain1:/root/channel-artifacts ${PWD}/Downloads
    fi

}

function deployPeerMode() {
    if [[ -z "$domain" || \
    -z "$volume" || \
    -z "$peerport" || \
    -z "$cport" ]]; then
        printHelp $MODE
    else
        echo 'deployPeerMode'
        scp -r ./Downloads/channel-artifacts root@$domain:
        scp -r ./Downloads/org1.example.com root@$domain:$volume/peerOrganizations/
        scp -r ./Downloads/ordererOrganizations root@$domain:$volume/
        scp -r ./peer/docker root@$domain:
        ssh root@$domain "bash -s" -- < ./peer/deploy_peer.sh $domain $volume $peerport $cport
      
    fi
    
}

# Parse mode
if [[ $# -lt 1 ]]; then
    printHelp
    exit 0
else
    MODE=$1
    shift
fi

# parse flags
while [[ $# -ge 1 ]]; do
    key="$1"
    case $key in
    -h | --help)
        printHelp $MODE
        exit 0
        ;;
    --ipaddress1)
        ipaddress1="$2"
        shift
        ;;
    --domain1)
        domain1="$2"
        shift
        ;;
    --domain2)
        domain2="$2"
        shift
        ;;
    --domain)
        domain="$2"
        shift
        ;;
    -v | --volume)
        volume="$2"
        shift
        ;;
    --orgname)
        orgname="$2"
        shift
        ;;
    --password)
        password="$2"
        shift
        ;;
    --admport)
        admport="$2"
        shift
        ;;
    --peerport)
        peerport="$2"
        shift
        ;;
    --peerport1)
        peerport1="$2"
        shift
        ;;
    --peerport2)
        peerport2="$2"
        shift
        ;;
    --cport)
        cport="$2"
        shift
        ;;
    --port1)
        port1="$2"
        shift
        ;;
    --port2)
        port2="$2"
        shift
        ;;
    --port3)
        port3="$2"
        shift
        ;;
    --admport1)
        admport1="$2"
        shift
        ;;
    --admport2)
        admport2="$2"
        shift
        ;;
    --admport3)
        admport3="$2"
        shift
        ;;
    *)
        printHelp
        errorln "Unknown flag: $key"
        println
        exit 1
        ;;
    esac
    shift
done

## MODE
if [ "${MODE}" == "deployCA" ]; then
    deployCAMode
elif [ "${MODE}" == "registerOrderer" ]; then
    registerOrdererMode
elif [ "${MODE}" == "registerPeer" ]; then
    registerPeerMode
elif [ "${MODE}" == "deployRaft3Node" ]; then
    deployRaft3NodeMode
elif [ "${MODE}" == "deployPeer" ]; then
    deployPeerMode
elif [ "${MODE}" == "swarm" ]; then
    swarmMode
else
    printHelp
    exit 1
fi