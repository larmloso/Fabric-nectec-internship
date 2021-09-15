#!/bin/bash

# ## Upload file to server

# ## DOMAIN SERVER
# DOMAIN=larmdev.cf
# ## LDAP PORT (defualt: 389)
# LDAP_PORT=389
# ## BACKEND API PORT (default: 3000)
# PORT=3000
# ## ADMIN USER LDAP SERVER
# ADMINUSER=admin
# ## PASSWORD LDAP SERVERF
# ADMINPW=pass

function CheckRequireData() {
    if [ -z "$DOMAIN" ]; then
        echo 'Error: Please add --domain, Try -help for more info'
        exit 1
    elif [ -z "$LDAP_PORT" ]; then
        echo 'Error: Please add --ldapport, Try -help for more info'
        exit 1
    elif [ -z "$PORT" ]; then
        echo 'Error: Please add -p, --port, Try -help for more info'
        exit 1
    elif [ -z "$ADMINUSER" ]; then
        echo 'Error: Please add --admin,Try -help for more info'
        exit 1
    elif [ -z "$ADMINPW" ]; then
        echo 'Error: Please add --adminpw,Try -help for more info'
        exit 1
    else
        ## DIR authUser
        ssh root@${DOMAIN} "mkdir authUser"
        ## UPLOADS FILE
        scp -r apiauth-javascript root@${DOMAIN}:authUser/apiauth-javascript
        ## UPLOADS DOKCER-COMPOSE FILE
        scp -r docker-compose.yaml root@${DOMAIN}:authUser
        ## SET ENV
        ssh root@${DOMAIN} "bash -s" -- ${DOMAIN} ${LDAP_PORT} ${PORT} ${ADMINUSER} ${ADMINPW} <./env.sh

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
        echo "    -h, --help                      Show brief help"
        echo "    --domain  string                droplet IP"
        echo "    --ldapport  string              ldap port"
        echo "    -p, --port int                  api auth port "
        echo "    --admin string                  admin user name "
        echo "    --adminpw string                admin password "
        echo " Examples:"
        echo "   ./run_script.sh --domain example.com --ldapport 389 --port 3000 --admin admin --adminpw pass"
        exit 0
        ;;
    --domain)
        shift
        if test $# -gt 0; then
            DOMAIN=$1
        else
            echo "Error: droplet IP not specified"
            exit 1
        fi
        shift
        ;;
    --ldapport)
        shift
        if test $# -gt 0; then
            LDAP_PORT=$1
        else
            echo "Error: droplet port1 not specified"
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
            ADMINUSER=$1
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
