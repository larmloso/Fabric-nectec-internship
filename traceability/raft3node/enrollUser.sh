#!/bin/bash

export PATH=./bin:$PATH
export FABRIC_CFG_PATH=./config

domain=$2
volume=$3
orgname=$4
admport=$5

username=$6
password=$7

IFS='.' read -r -a array <<<"$domain"

## Check Dir
function checkDir() {

    echo "create dir"
    export PEERORG=peerOrganizations/org1.example.com

    if [ ! -d "${volume}/${PEERORG}" ]; then

        ## download fabric binary
        curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.3.0 1.4.9 -d -s

        mkdir -p ${volume}/${PEERORG}
    fi
}

function enrollCAadmin() {

    export FABRIC_CA_CLIENT_HOME=${PWD}/${volume}/${PEERORG}/
    export DIR_TLS_CERT_PEEM=fabric-ca-server-tls/tls-cert.pem

    fabric-ca-client enroll -u https://${username}:${password}@${domain}:${admport} \
        --caname ${orgname}-tls --tls.certfiles "${PWD}/${volume}/${orgname}/${DIR_TLS_CERT_PEEM}"

    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
        Certificate: cacerts/'${array[0]}'-'${array[1]}'-'${admport}'-'${orgname}'-tls.pem
        OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
        Certificate: cacerts/'${array[0]}'-'${array[1]}'-'${admport}'-'${orgname}'-tls.pem
        OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
        Certificate: cacerts/'${array[0]}'-'${array[1]}'-'${admport}'-'${orgname}'-tls.pem
        OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
        Certificate: cacerts/'${array[0]}'-'${array[1]}'-'${admport}'-'${orgname}'-tls.pem
        OrganizationalUnitIdentifier: orderer' >"${PWD}/${volume}/${PEERORG}/msp/config.yaml"
}

function enrollPeer() {

    export FABRIC_CA_CLIENT_HOME=${PWD}/${volume}/${PEERORG}/
    export DIR_TLS_CERT_PEEM=fabric-ca-server-tls/tls-cert.pem

    #  "Generating the peer0 msp"
    fabric-ca-client enroll -u https://${username}:${password}@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/${PEERORG}/peers/peer0.${domain}/msp" \
        --csr.hosts peer0.${domain} --tls.certfiles "${PWD}/${volume}/${orgname}/${DIR_TLS_CERT_PEEM}"

    cp "${PWD}/${volume}/${PEERORG}/msp/config.yaml" \
        "${PWD}/${volume}/${PEERORG}/peers/peer0.${domain}/msp/config.yaml"

    #  "Generating the peer0-tls certificates"
    fabric-ca-client enroll -u https://${username}:${password}@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/${PEERORG}/peers/peer0.${domain}/tls" \
        --enrollment.profile tls --csr.hosts peer0.${domain} --csr.hosts localhost --csr.hosts ${domain} \
        --tls.certfiles "${PWD}/${volume}/${orgname}/${DIR_TLS_CERT_PEEM}"

    cp "${PWD}/${volume}/${PEERORG}/peers/peer0.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/${PEERORG}/peers/peer0.${domain}/tls/ca.crt"
    cp "${PWD}/${volume}/${PEERORG}/peers/peer0.${domain}/tls/signcerts/"* \
        "${PWD}/${volume}/${PEERORG}/peers/peer0.${domain}/tls/server.crt"
    cp "${PWD}/${volume}/${PEERORG}/peers/peer0.${domain}/tls/keystore/"* \
        "${PWD}/${volume}/${PEERORG}/peers/peer0.${domain}/tls/server.key"

    mkdir -p "${PWD}/${volume}/${PEERORG}/msp/tlscacerts"
    cp "${PWD}/${volume}/${PEERORG}/peers/peer0.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/${PEERORG}/msp/tlscacerts/ca.crt"
    mkdir -p "${PWD}/${volume}/${PEERORG}/tlsca"
    cp "${PWD}/${volume}/${PEERORG}/peers/peer0.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/${PEERORG}/tlsca/tlsca.org1.example.com-cert.pem"

    mkdir -p "${PWD}/${volume}/${PEERORG}/ca"
    cp "${PWD}/${volume}/${PEERORG}/peers/peer0.${domain}/msp/cacerts/"* \
        "${PWD}/${volume}/${PEERORG}/ca/ca.org1.example.com-cert.pem"
}

function enrollOrgUser() {

    export FABRIC_CA_CLIENT_HOME=${PWD}/${volume}/${PEERORG}/
    export DIR_TLS_CERT_PEEM=fabric-ca-server-tls/tls-cert.pem

    #  "Generating the user msp"
    fabric-ca-client enroll -u https://${username}:${password}@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/${PEERORG}/users/User1@org1.example.com/msp" \
        --tls.certfiles "${PWD}/${volume}/${orgname}/${DIR_TLS_CERT_PEEM}"

    cp "${PWD}/${volume}/${PEERORG}/msp/config.yaml" \
        "${PWD}/${volume}/${PEERORG}/users/User1@org1.example.com/msp/config.yaml"
}

function enrollOrgAdmin() {

    export FABRIC_CA_CLIENT_HOME=${PWD}/${volume}/${PEERORG}/
    export DIR_TLS_CERT_PEEM=fabric-ca-server-tls/tls-cert.pem

    #  "Generating the org admin msp"
    fabric-ca-client enroll -u https://${username}:${password}@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/${PEERORG}/users/Admin@org1.example.com/msp" \
        --tls.certfiles "${PWD}/${volume}/${orgname}/${DIR_TLS_CERT_PEEM}"

    cp "${PWD}/${volume}/${PEERORG}/msp/config.yaml" \
        "${PWD}/${volume}/${PEERORG}/users/Admin@org1.example.com/msp/config.yaml"
}

checkDir

key="$1"
case $key in
enrollCAadmin)
    echo 'enrollCAadmin'
    enrollCAadmin
    ;;
enrollPeer)
    echo 'enrollPeer'
    enrollPeer
    ;;
enrollOrgUser)
    echo 'enrollOrgUser'
    enrollOrgUser
    ;;
enrollOrgAdmin)
    echo 'enrollOrgAdmin'
    enrollOrgAdmin
    ;;
*)
    exit 1
    ;;
esac
