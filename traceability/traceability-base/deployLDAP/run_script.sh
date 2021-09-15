#!/bin/bash

function CheckRequireData() {
    if [ -z "$IPADDRESS" ]; then
        echo 'Error: Please add -i, --ipaddress,Try -help for more info'
        exit 1
    elif [ -z "$PORT" ]; then
        echo 'Error: Please add -p,Try -help for more info'
        exit 1
    elif [ -z "$ADMIN" ]; then
        echo 'Error: Please add --admin,Try -help for more info'
        exit 1
    elif [ -z "$ADMINPW" ]; then
        echo 'Error: Please add --adminpw,Try -help for more info'
        exit 1
    else
        scp -r docker-compose.yaml root@$IPADDRESS:docker-compose.yaml
        scp -r edit_port.py root@$IPADDRESS:edit_port.py
        ssh root@$IPADDRESS "bash -s" -- < ./deploy_ldap.sh $PORT $ADMIN $ADMINPW
        echo "hello"
    fi
}

#Flags command#
while test $# -gt 0; do
    case "$1" in
    -h | --help)
        echo "Deploy LDAP"
        echo " "
        echo "Usage:"
        echo "    ./run_script.sh [flags]"
        echo " "
        echo "Flags:"
        echo "    -h, --help                Show brief help"
        echo "    -i , --ipaddress string                droplet IP"
        echo "    -p, --port int                  open port "
        echo "    --admin string                  admin user name "
        echo "    --adminpw string                admin password "
        echo " Examples:"
        echo "   ./run_script.sh -i example.com -p 4000 --admin admin --adminpw pass"
        exit 0
        ;;
    -i | --ipaddress)
        shift
        if test $# -gt 0; then
            IPADDRESS=$1
        else
            echo "Error: droplet IP not specified"
            exit 1
        fi
        shift
        ;;
    -p | --port)
        shift
        if test $# -gt 0; then
            PORT=$1
        else
            echo "Error: droplet port1 not specified"
            exit 1
        fi
        shift
        ;;
    --admin)
        shift
        if test $# -gt 0; then
            ADMIN=$1
        else
            echo "Error: droplet port2 not specified"
            exit 1
        fi
        shift
        ;;
    --adminpw)
        shift
        if test $# -gt 0; then
            ADMINPW=$1
        else
            echo "Error: droplet port2 not specified"
            exit 1
        fi
        shift
        ;;
    *)
        echo 'Error: please try ./run_script.sh --help or ./run_script.sh -h for more info'
        exit 1
        ;;
    esac
done

#call function
CheckRequireData
