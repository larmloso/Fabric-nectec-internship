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

    export ORDERERORG=ordererOrganizations/example.com

    if [ ! -d "${volume}/${ORDERERORG}" ]; then

        ## download fabric binary
        curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.3.0 1.4.9 -d -s

        mkdir -p ${volume}/${ORDERERORG}
    fi
}

#  Enrolling the CA admin
function enrollCAadmin() {

    export FABRIC_CA_CLIENT_HOME=${PWD}/${volume}/${ORDERERORG}
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
            OrganizationalUnitIdentifier: orderer' >"${PWD}/${volume}/${ORDERERORG}/msp/config.yaml"
}

function enrollIdentities() {

    echo "Creating Org Identities"

    export FABRIC_CA_CLIENT_HOME=${PWD}/${volume}/${ORDERERORG}
    export ORDERER_NODE_DIR=${PWD}/${volume}/${ORDERERORG}/orderers/${username}
    export DIR_TLS_CERT_PEEM=fabric-ca-server-tls/tls-cert.pem

    #  "Generating the orderer msp"
    fabric-ca-client enroll -u https://${username}:${password}@${domain}:${admport} --caname ${orgname}-tls \
        -M "${ORDERER_NODE_DIR}.${domain}/msp" \
        --csr.hosts ${username}.${domain} --csr.hosts localhost --csr.hosts ${domain} \
        --tls.certfiles "${PWD}/${volume}/${orgname}/${DIR_TLS_CERT_PEEM}"

    cp "${PWD}/${volume}/${ORDERERORG}/msp/config.yaml" \
        "${ORDERER_NODE_DIR}.${domain}/msp/config.yaml"

    #  "Generating the orderer-tls certificates"
    fabric-ca-client enroll -u https://${username}:${password}@${domain}:${admport} --caname ${orgname}-tls \
        -M "${ORDERER_NODE_DIR}.${domain}/tls" \
        --enrollment.profile tls --csr.hosts ${username}.${domain} --csr.hosts localhost --csr.hosts ${domain} \
        --tls.certfiles "${PWD}/${volume}/${orgname}/${DIR_TLS_CERT_PEEM}"

    cp "${ORDERER_NODE_DIR}.${domain}/tls/tlscacerts/"* \
        "${ORDERER_NODE_DIR}.${domain}/tls/ca.crt"
    cp "${ORDERER_NODE_DIR}.${domain}/tls/signcerts/"* \
        "${ORDERER_NODE_DIR}.${domain}/tls/server.crt"
    cp "${ORDERER_NODE_DIR}.${domain}/tls/keystore/"* \
        "${ORDERER_NODE_DIR}.${domain}/tls/server.key"

    mkdir -p "${ORDERER_NODE_DIR}.${domain}/msp/tlscacerts"
    cp "${ORDERER_NODE_DIR}.${domain}/tls/tlscacerts/"* \
        "${ORDERER_NODE_DIR}.${domain}/msp/tlscacerts/tlsca.example.com-cert.pem"

    mkdir -p "${PWD}/${volume}/${ORDERERORG}/msp/tlscacerts"
    cp "${ORDERER_NODE_DIR}.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/${ORDERERORG}/msp/tlscacerts/tlsca.example.com-cert.pem"

}

function enrollOrdererAdmin() {

    export FABRIC_CA_CLIENT_HOME=${PWD}/${volume}/${ORDERERORG}
    export DIR_TLS_CERT_PEEM=fabric-ca-server-tls/tls-cert.pem

    #  "Generating the admin msp"
    fabric-ca-client enroll -u https://${username}:${password}@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/${ORDERERORG}/users/Admin@example.com/msp" \
        --tls.certfiles "${PWD}/${volume}/${orgname}/${DIR_TLS_CERT_PEEM}"

    cp "${PWD}/${volume}/${ORDERERORG}/msp/config.yaml" \
        "${PWD}/${volume}/${ORDERERORG}/users/Admin@example.com/msp/config.yaml"
}

checkDir

key="$1"
case $key in
enrollCAadmin)
    echo 'enrollCAadmin'
    enrollCAadmin
    ;;
enrollIdentities)
    echo 'enrollIdentities'
    enrollIdentities
    ;;
enrollOrdererAdmin)
    echo 'enrollOrdererAdmin'
    enrollOrdererAdmin
    ;;
*)
    exit 1
    ;;
esac

# enrollOrdererAdmin
