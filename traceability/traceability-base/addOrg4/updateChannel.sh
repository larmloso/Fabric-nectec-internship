#!/bin/bash

function updateConfigChannel() {

    if [ -z "$DOMAIN1" ]; then
        echo 'Error: Please add --domain1, Try -help for more info'
        exit 1
    elif [ -z "$DOMAIN2" ]; then
        echo 'Error: Please add --domain2, Try -help for more info'
        exit 1
    elif [ -z "$DOMAIN3" ]; then
        echo 'Error: Please add --domain3, Try -help for more info'
        exit 1
    elif [ -z "$PORT1" ]; then
        echo 'Error: Please add --port1, Try -help for more info'
        exit 1
    elif [ -z "$PORT2" ]; then
        echo 'Error: Please add --port2, Try -help for more info'
        exit 1
    elif [ -z "$PORT3" ]; then
        echo 'Error: Please add --port3, Try -help for more info'
        exit 1
    else

        # echo $DOMAIN1 $DOMAIN2 $DOMAIN3 $PORT1 $PORT2 $PORT3

        scp -r root@$DOMAIN3:/root/organizations/peerOrganizations/org4.example.com ${PWD}/../Downloads

        ## deploy peer
        scp -r docker root@$DOMAIN3:docker
        ssh root@$DOMAIN3 "bash -s" -- $DOMAIN3 organizations $PORT3 9052 <./deploy_peer.sh

        sleep 2
        ## config and update channel
        scp -r ../Downloads/org4.example.com root@$DOMAIN1:/root/organizations/peerOrganizations/org4.example.com
        ssh root@$DOMAIN1 "bash -s" -- $DOMAIN1 $PORT1 $DOMAIN2 $PORT2 $DOMAIN3 $PORT3 <./configChannel.sh
        
        sleep 2
        ## deploy chaincode
        #ssh root@$DOMAIN1 "bash -s" -- <./deployChaincode.sh $DOMAIN1 $PORT1 $DOMAIN2 $PORT2 $DOMAIN3 $PORT3
    fi

}

while test $# -gt 0; do
    case "$1" in
    -h | --help)
        echo "Deploy LDAP"
        echo " "
        echo "Usage:"
        echo "    ./run_script.sh [flags]"
        echo " "
        echo "Flags:"
        echo "    -h, --help                 Show brief help"
        echo "    --domain1                     domain server 1"
        echo "    --domain2                     domain server 1"
        echo "    --domain3                     domain server 1"
        echo "    --port1                       port server 1"
        echo "    --port2                       port server 2"
        echo "    --port3                       port server 3"
        echo " Examples:"
        echo "   ./updateChannel.sh --domain1 example1.com --domain2 example2.com --domain3 example3.com --port1 7051 --port2 9051 --port3 11051"
        exit 0
        ;;
    --domain1)
        shift
        if test $# -gt 0; then
            DOMAIN1=$1
        else
            echo "Error: domain1  not specified"
            exit 1
        fi
        shift
        ;;
    --domain2)
        shift
        if test $# -gt 0; then
            DOMAIN2=$1
        else
            echo "Error: domain2 not specified"
            exit 1
        fi
        shift
        ;;
    --domain3)
        shift
        if test $# -gt 0; then
            DOMAIN3=$1
        else
            echo "Error: domain3  not specified"
            exit 1
        fi
        shift
        ;;
    --port1)
        shift
        if test $# -gt 0; then
            PORT1=$1
        else
            echo "Error: port1  not specified"
            exit 1
        fi
        shift
        ;;
    --port2)
        shift
        if test $# -gt 0; then
            PORT2=$1
        else
            echo "Error: port2 not specified"
            exit 1
        fi
        shift
        ;;
    --port3)
        shift
        if test $# -gt 0; then
            PORT3=$1
        else
            echo "Error: port3 not specified"
            exit 1
        fi
        shift
        ;;
    *)
        echo 'Error: please try ./updateChannel.sh --help'
        exit 1
        ;;
    esac
done

#call function
updateConfigChannel
