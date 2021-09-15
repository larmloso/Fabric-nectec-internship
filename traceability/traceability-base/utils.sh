#!/bin/bash

## Color Message
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_YELLOW='\033[1;33m'

##
# Print Help
function printHelp() {
    USAGE="$1"
    if [ "$USAGE" == "deployCA" ]; then
        println "Usage: "
        println "  run.sh \033[0;32mdeployCA\033[0m [Flags]"
        println
        println "    Flags:"
        println "    Used with \033[0;32mrun.sh deployCA\033[0m:"
        println
        println "    --domain               : domain name droplet digitalocean"
        println "    --orgname              : Organizations name that you want to register and enroll"
        println "    --password             : The enrollment secret for the identity being registered"
        println "    -v, --volume           : directory"
        println
        println "    -h, --help             : Print this message"
        println
        println "   Possible Mode and flag combinations"
        println "      \033[0;32mdeployCA\033[0m --domain --volume --orgname --passowrd"
        println
        println "   Examples:"
        println "      ./run.sh deployCA --domain example.com --volume organizations --orgname fabric-ca --password adminpw"
        println
    elif [ "$USAGE" == "swarm" ]; then
        println "Usage: "
        println "  run.sh \033[0;32mswarm\033[0m [Flags]"
        println
        println "    Flags:"
        println "    Used with \033[0;32mrun.sh swarm\033[0m:"
        println
        println "    --ipaddress1           : ip address droplet digitalocean of server1"
        println "    --domain1              : domain name of server1"
        println "    --domain2              : domain name of server2"
        println
        println "    -h, --help             : Print this message"
        println
        println "   Possible Mode and flag combinations"
        println "      \033[0;32mswarm\033[0m --ipaddress1 --domain1 --domain2"
        println
        println "   Examples:"
        println "      ./run.sh swarm --ipaddress1 1.1.1.1 --domain1 example1.com --domain2 example2.com"
        println
    elif [ "$USAGE" == "registerPeer" ]; then
        println "Usage: "
        println "  run.sh \033[0;32mregister\033[0m [Flags]"
        println
        println "    Flags:"
        println "    Used with \033[0;32mrun.sh registerPeer\033[0m:"
        println
        println "    --domain               : domain name droplet digitalocean"
        println "    -v, --volume           : Directory"
        println "    --orgname              : Organizations name"
        println "    --admport              : admin port of Organizations TLS CA"
        println
        println "    -h, --help             : Print this message"
        println
        println "   Possible Mode and flag combinations"
        println "      \033[0;32mregisterPeer\033[0m --domain --volume --orgname --admport"
        println
        println "   Examples:"
        println "      ./run.sh registerPeer --domain example.com --volume organizations --orgname fabric-ca --admport 7054"
        println
    elif [ "$USAGE" == "registerOrderer" ]; then
        println "Usage: "
        println "  run.sh \033[0;32mregisterOrderer\033[0m [Flags]"
        println
        println "    Flags:"
        println "    Used with \033[0;32mrun.sh registerOrderer\033[0m:"
        println
        println "    --domain               : domain name droplet digitalocean"
        println "    -v, --volume           : Directory"
        println "    --orgname              : Organizations name"
        println "    --admport              : admin port of Organizations TLS CA"
        println
        println "    -h, --help             : Print this message"
        println
        println "   Possible Mode and flag combinations"
        println "      \033[0;32mregisterOrderer\033[0m --domain --volume --orgname --admport"
        println
        println "   Examples:"
        println "      ./run.sh registerOrderer --domain example.com --volume organizations --orgname fabric-ca --admport 7054"
        println
    elif [ "$USAGE" == "deployRaft3Node" ]; then
        println "Usage: "
        println "  run.sh \033[0;32mdeployRaft3Node\033[0m [Flags]"
        println
        println "    Flags:"
        println "    Used with \033[0;32mrun.sh deployRaft3Node\033[0m:"
        println
        println "    --domain1              : domain name of server1"
        println "    --domain2              : domain name of server2"
        println "    -v, --volume           : Directory"
        println "    --peerport1             : port for peer server1"
        println "    --peerport2             : port for peer server2"
        println
        println "    --port1                : listen port1 for orderer raft 3 node"
        println "    --port2                : lesten port2 for orderer raft 3 node"
        println "    --port3                : lesten port3 for orderer raft 3 node"
        println
        println "    --admport1             : admin port1 for orderer raft 3 node"
        println "    --admport2             : admin port2 for orderer raft 3 node"
        println "    --admport3             : admin port3 for orderer raft 3 node"
        println
        println "    -h, --help             : Print this message"
        println
        println "   Possible Mode and flag combinations"
        println "      \033[0;32mdeployRaft3Node\033[0m --domain1 --domain2 --volume --peerport1 --peerport2 --port1 --port2 --port3 --admport1 --admport2 --admport3"
        println
        println "   Examples:"
        println "      ./run.sh deployRaft3Node --domain1 example1.com --domain2 example2.com --volume organizations --peerport1 7051 --peerport2 9051 --port1 7050 --port2 8050 --port3 9050 --admport1 7053 --admport2 8053 --admport3 9053"
        println
    elif [ "$USAGE" == "deployPeer" ]; then
        println "Usage: "
        println "  run.sh \033[0;32mdeployPeer\033[0m [Flags]"
        println
        println "    Flags:"
        println "    Used with \033[0;32mrun.sh deployPeer\033[0m:"
        println
        println "    --domain               : domain name droplet digitalocean"
        println "    -v, --volume           : Directory"
        println "    --peerport             : peer port"
        println "    --cport                : chaincode port"
        println
        println "    -h, --help             : Print this message"
        println
        println "   Possible Mode and flag combinations"
        println "      \033[0;32mdeployPeer\033[0m --ipaddress --volume --orgname --peerport --cport"
        println
        println "   Examples:"
        println "      ./run.sh deployPeer --domain example.com --volume organizations --peerport 9051 --cport 9052"
        println
    else
        println "Usage: "
        println "  run.sh <Mode> [Flags]"
        println
        println "    Modes:"
        println "      \033[0;32mswarm\033[0m               - swarm Server1 and Server2"
        println "      \033[0;32mdeployCA\033[0m            - deploy CA"
        println "      \033[0;32mregisterOrderer\033[0m     - register raft 3 node and peer"
        println "      \033[0;32mregisterPeer\033[0m        - register peer"
        println "      \033[0;32mdeployRaft3Node\033[0m     - deploy orderer raft 3 node"
        println "      \033[0;32mdeployPeer\033[0m          - deploy peer"
        println
        println
        println "      \033[0;32mswarm\033[0m --ipaddress1 --domain1 --domain2"
        println "      \033[0;32mdeployCA\033[0m --domain --volume --orgname --password"
        println "      \033[0;32mregisterPeer\033[0m --domain --volume --orgname --admport"
        println "      \033[0;32mregisterOrderer\033[0m --domain --volume --orgname --admport"
        println "      \033[0;32mdeployRaft3Node\033[0m --domain1 --domain2 --volume --peerport1 --peerport2 --port1 --port2 --port3 --admport1 --admport2 --admport3"
        println "      \033[0;32mdeployPeer\033[0m --ipaddress --volume --orgname --peerport --cport"
        println
        println " Examples:"
        println "      ./network.sh [MODE] -h"
        println "      ./network.sh [MODE] --help"
        println
    fi
}

# println echos string
function println() {
    echo -e "$1"
}
# println errorln string
function errorln() {
    println "${C_RED}${1}${C_RESET}"
}