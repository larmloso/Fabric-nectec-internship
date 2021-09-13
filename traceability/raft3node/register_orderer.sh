#!/bin/bash
export PATH=./bin:$PATH
export FABRIC_CFG_PATH=./config

domain=$1
volume=$2
orgname=$3
admport=$4

IFS='.' read -r -a array <<< "$domain"

# registerEnroll Org1
function createOrg1() {
    # "Enrolling the CA admin"
    mkdir -p ${volume}/peerOrganizations/org1.example.com/

    export FABRIC_CA_CLIENT_HOME=${PWD}/${volume}/peerOrganizations/org1.example.com/

    fabric-ca-client enroll -u https://admin:adminpw@${domain}:${admport} \
        --caname ${orgname}-tls --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"
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
        OrganizationalUnitIdentifier: orderer' > "${PWD}/${volume}/peerOrganizations/org1.example.com/msp/config.yaml"

    echo 'Registering peer0'
    # "Registering peer0"
    fabric-ca-client register --caname ${orgname}-tls --id.name peer0 --id.secret peer0pw --id.type peer \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    #  "Registering user"
    fabric-ca-client register --caname ${orgname}-tls --id.name user1 --id.secret user1pw --id.type client \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    #  "Registering the org admin"
    fabric-ca-client register --caname ${orgname}-tls --id.name org1admin --id.secret org1adminpw --id.type admin \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    #  "Generating the peer0 msp"
    fabric-ca-client enroll -u https://peer0:peer0pw@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain}/msp" \
        --csr.hosts peer0.${domain} --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    cp "${PWD}/${volume}/peerOrganizations/org1.example.com/msp/config.yaml" \
        "${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain}/msp/config.yaml"

    #  "Generating the peer0-tls certificates"
    fabric-ca-client enroll -u https://peer0:peer0pw@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain}/tls" \
        --enrollment.profile tls --csr.hosts peer0.${domain} --csr.hosts localhost --csr.hosts ${domain} \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    cp "${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain}/tls/ca.crt"
    cp "${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain}/tls/signcerts/"* \
        "${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain}/tls/server.crt"
    cp "${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain}/tls/keystore/"* \
        "${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain}/tls/server.key"

    mkdir -p "${PWD}/${volume}/peerOrganizations/org1.example.com/msp/tlscacerts"
    cp "${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/peerOrganizations/org1.example.com/msp/tlscacerts/ca.crt"
    mkdir -p "${PWD}/${volume}/peerOrganizations/org1.example.com/tlsca"
    cp "${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem"

    mkdir -p "${PWD}/${volume}/peerOrganizations/org1.example.com/ca"
    cp "${PWD}/${volume}/peerOrganizations/org1.example.com/peers/peer0.${domain}/msp/cacerts/"* \
        "${PWD}/${volume}/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem"

    #  "Generating the user msp"
    fabric-ca-client enroll -u https://user1:user1pw@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp" \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    cp "${PWD}/${volume}/peerOrganizations/org1.example.com/msp/config.yaml" \
        "${PWD}/${volume}/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/config.yaml"

    #  "Generating the org admin msp"
    fabric-ca-client enroll -u https://org1admin:org1adminpw@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    cp "${PWD}/${volume}/peerOrganizations/org1.example.com/msp/config.yaml" \
        "${PWD}/${volume}/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/config.yaml"
}

# registerEnroll Orderer
function createOrderer() {
    #  "Enrolling the CA admin"
    mkdir -p ${volume}/ordererOrganizations/example.com

    export FABRIC_CA_CLIENT_HOME=${PWD}/${volume}/ordererOrganizations/example.com

    fabric-ca-client enroll -u https://admin:adminpw@${domain}:${admport} \
        --caname ${orgname}-tls --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

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
        OrganizationalUnitIdentifier: orderer' > "${PWD}/${volume}/ordererOrganizations/example.com/msp/config.yaml"


    #  "Registering orderer"
    fabric-ca-client register --caname ${orgname}-tls --id.name orderer1 --id.secret ordererpw --id.type orderer \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"
    
    fabric-ca-client register --caname ${orgname}-tls --id.name orderer2 --id.secret ordererpw --id.type orderer \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"
    
    fabric-ca-client register --caname ${orgname}-tls --id.name orderer3 --id.secret ordererpw --id.type orderer \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    #  "Registering the orderer admin"
    fabric-ca-client register --caname ${orgname}-tls --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    #  "Generating the orderer msp"
    fabric-ca-client enroll -u https://orderer1:ordererpw@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/msp" \
        --csr.hosts orderer1.${domain} --csr.hosts localhost --csr.hosts ${domain} \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    cp "${PWD}/${volume}/ordererOrganizations/example.com/msp/config.yaml" \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/msp/config.yaml"

    #  "Generating the orderer-tls certificates"
    fabric-ca-client enroll -u https://orderer1:ordererpw@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/tls" \
        --enrollment.profile tls --csr.hosts orderer1.${domain} --csr.hosts localhost --csr.hosts ${domain} \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/tls/ca.crt"
    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/tls/signcerts/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/tls/server.crt"
    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/tls/keystore/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/tls/server.key"

    mkdir -p "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/msp/tlscacerts"
    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/msp/tlscacerts/tlsca.example.com-cert.pem"

    mkdir -p "${PWD}/${volume}/ordererOrganizations/example.com/msp/tlscacerts"
    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer1.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
    

    # ------------------------------------------------
    #  "Generating the orderer msp"
    fabric-ca-client enroll -u https://orderer2:ordererpw@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/msp" \
        --csr.hosts orderer2.${domain} --csr.hosts localhost --csr.hosts ${domain} \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    cp "${PWD}/${volume}/ordererOrganizations/example.com/msp/config.yaml" \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/msp/config.yaml"

    #  "Generating the orderer-tls certificates"
    fabric-ca-client enroll -u https://orderer2:ordererpw@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/tls" \
        --enrollment.profile tls --csr.hosts orderer2.${domain} --csr.hosts localhost --csr.hosts ${domain} \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/tls/ca.crt"
    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/tls/signcerts/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/tls/server.crt"
    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/tls/keystore/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/tls/server.key"

    mkdir -p "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/msp/tlscacerts"
    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/msp/tlscacerts/tlsca.example.com-cert.pem"

    mkdir -p "${PWD}/${volume}/ordererOrganizations/example.com/msp/tlscacerts"
    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer2.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
    # ------------------------------------------------

    # ------------------------------------------------
    #  "Generating the orderer msp"
    fabric-ca-client enroll -u https://orderer3:ordererpw@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/msp" \
        --csr.hosts orderer3.${domain} --csr.hosts localhost --csr.hosts ${domain} \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    cp "${PWD}/${volume}/ordererOrganizations/example.com/msp/config.yaml" \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/msp/config.yaml"

    #  "Generating the orderer-tls certificates"
    fabric-ca-client enroll -u https://orderer3:ordererpw@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/tls" \
        --enrollment.profile tls --csr.hosts orderer3.${domain} --csr.hosts localhost --csr.hosts ${domain} \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/tls/ca.crt"
    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/tls/signcerts/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/tls/server.crt"
    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/tls/keystore/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/tls/server.key"

    mkdir -p "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/msp/tlscacerts"
    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/msp/tlscacerts/tlsca.example.com-cert.pem"

    mkdir -p "${PWD}/${volume}/ordererOrganizations/example.com/msp/tlscacerts"
    cp "${PWD}/${volume}/ordererOrganizations/example.com/orderers/orderer3.${domain}/tls/tlscacerts/"* \
        "${PWD}/${volume}/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
    # ------------------------------------------------

    #  "Generating the admin msp"
    fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@${domain}:${admport} --caname ${orgname}-tls \
        -M "${PWD}/${volume}/ordererOrganizations/example.com/users/Admin@example.com/msp" \
        --tls.certfiles "${PWD}/${volume}/${orgname}/fabric-ca-server-tls/tls-cert.pem"

    cp "${PWD}/${volume}/ordererOrganizations/example.com/msp/config.yaml" \
        "${PWD}/${volume}/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml"
}

curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.3.0 1.4.9 -d -s

createOrg1

createOrderer
