#!/bin/bash

function CheckRequireData() {
    if [ -z "$IP" ]; then
        echo 'Error: Please add --IP,Try -help for more info'
        exit 1
    elif [ -z "$DOMAINS" ]; then
        echo 'Error: Please add --DOMAINS,Try -help for more info'
        exit 1
    # elif [ -z "$PORT" ]; then
    #     echo 'Error: Please add --PORT,Try -help for more info'
    #     exit 1
    elif [ -z "$PORTLDAP" ]; then
        echo 'Error: Please add --PORTLDAP,Try -help for more info'
        exit 1
    else
        ./ldapenv.sh ${DOMAINS} ${PORTLDAP} ${PORT}
        scp -r src root@$IP:
        ssh root@$IP "bash -s" -- < ./install.sh ${PORT} ${DOMAINS} ${PORTLDAP}
    fi
}

#Flags command#
while test $# -gt 0; do
  case "$1" in
    -h|--help)
        echo "Deploy LDAP"
        echo " "
        echo "Usage:"
        echo "    ./run_script.sh [flags]"
        echo " "
        echo "Flags:"
        echo "    -h, --help                Show brief help"
        echo "    --IP string               droplet IP"
        echo "    --PORT int                open port server.js"
        echo "    --DOMAINS string          DOMAINS ldap server"
        echo "    --PORTLDAP int            PORT ldap server"
        echo " Examples:"
        echo "   ./run_script.sh --IP [IP ของ droplet or domain droplet] --DOMAINS [DOMAINS ldap server] --PORTLDAP [PORT ldap server] --PORT [open port server.js]"
        exit 0
        ;;
    -ip|--IP)
        shift
        if test $# -gt 0; then
            IP=$1
        else
            echo "Error: droplet IP not specified"
            exit 1
        fi
        shift
        ;;
    --PORT)
        shift
        if test $# -gt 0; then
            PORT=$1
        else
            echo "Error: droplet PORT not specified"
            exit 1
        fi
        shift
        ;;
     -domains|--DOMAINS)
        shift
        if test $# -gt 0; then
            DOMAINS=$1
        else
            echo "Error: droplet IP not specified"
            exit 1
        fi
        shift
        ;;
    --PORTLDAP)
        shift
        if test $# -gt 0; then
            PORTLDAP=$1
        else
            echo "Error: droplet IP not specified"
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