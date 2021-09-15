orgname=$1
password=$2
volume=$3
domain=$4

Start_tls () {
    docker pull hyperledger/fabric-ca

    docker run --rm --name \
        fabric-ca-server-tls-init.${orgname} \
        -v \
        ${PWD}/${volume}/${orgname}/fabric-ca-server-tls:/root/fabric-ca-server-tls \
        hyperledger/fabric-ca:1.4.9 \
        fabric-ca-server init -b \
        admin:${password} -H \
        /root/fabric-ca-server-tls
    
    sudo chown -R $USER:$USER \
        ${volume}

    python3 ./edit_yaml.py tls ${orgname} ${volume} ${domain}


    sudo rm \
        ${volume}/${orgname}/fabric-ca-server-tls/ca-cert.pem

    sudo rm -rf \
        ${volume}/${orgname}/fabric-ca-server-tls/msp
    
    docker run -d --rm -p 7054:7054 \
        --name \
        fabric-ca-server-tls.${orgname} -v \
        ${PWD}/${volume}/${orgname}/fabric-ca-server-tls:/root/fabric-ca-server-tls \
        hyperledger/fabric-ca:1.4.9 \
        fabric-ca-server start -b \
        admin:${password} -H \
        /root/fabric-ca-server-tls
    sleep 3
}

Enroll_tls () {
    mkdir \
        ${volume}/${orgname}/fabric-ca-client
    mkdir \
        ${volume}/${orgname}/fabric-ca-client/tls-ca
    mkdir \
        ${volume}/${orgname}/fabric-ca-client/tls-root-cert

    cp \
        ${volume}/${orgname}/fabric-ca-server-tls/ca-cert.pem \
        ${volume}/${orgname}/fabric-ca-client/tls-root-cert/tls-ca-cert.pem

    docker run --rm --name \
        fabric-ca-client.${orgname} --link \
        fabric-ca-server-tls.${orgname}:fabric-ca-server-tls.${orgname} \
        -v \
        ${PWD}/${volume}/${orgname}/fabric-ca-client:/root/fabric-ca-client \
        -e \
        FABRIC_CA_CLIENT_HOME=/root/fabric-ca-client \
        hyperledger/fabric-ca:1.4.9 \
        fabric-ca-client enroll -d -u \
        https://admin:${password}@${domain}:7054 \
        --tls.certfiles \
        tls-root-cert/tls-ca-cert.pem \
        --enrollment.profile tls \
        --csr.hosts \
        ${domain}',host1,fabric-ca-server-tls.'${orgname} \
        --mspdir tls-ca/admin/msp
    docker run --rm --name \
        fabric-ca-client.${orgname} \
        --link \
        fabric-ca-server-tls.${orgname}:fabric-ca-server-tls.${orgname} \
        -v \
        ${PWD}/${volume}/${orgname}/fabric-ca-client:/root/fabric-ca-client \
        -e \
        FABRIC_CA_CLIENT_HOME=/root/fabric-ca-client \
        hyperledger/fabric-ca:1.4.9 \
        fabric-ca-client register -d \
        --id.name rcaadmin --id.secret \
        rcaadminpw -u \
        https://${domain}:7054 \
        --tls.certfiles \
        tls-root-cert/tls-ca-cert.pem \
        --mspdir tls-ca/admin/msp
    docker run --rm --name \
        fabric-ca-client.${orgname} \
        --link \
        fabric-ca-server-tls.${orgname}:fabric-ca-server-tls.${orgname} \
        -v \
        ${PWD}/${volume}/${orgname}/fabric-ca-client:/root/fabric-ca-client \
        -e \
        FABRIC_CA_CLIENT_HOME=/root/fabric-ca-client \
        hyperledger/fabric-ca:1.4.9 \
        fabric-ca-client enroll -d -u \
        https://rcaadmin:rcaadminpw@${domain}:7054 \
        --tls.certfiles \
        tls-root-cert/tls-ca-cert.pem \
        --enrollment.profile tls \
        --csr.hosts \
        ${domain}',host1,*.fabric-ca-server-org.'${orgname} \
        --mspdir tls-ca/rcaadmin/msp
}

Start_org () {
    sudo mkdir \
        ${volume}/${orgname}/fabric-ca-server-org/
    sudo mkdir \
        ${volume}/${orgname}/fabric-ca-server-org/tls
    sudo cp \
        ${volume}/${orgname}/fabric-ca-client/tls-ca/admin/msp/signcerts/cert.pem \
        ${volume}/${orgname}/fabric-ca-server-org/tls \
        && sudo cp \
        ${volume}/${orgname}/fabric-ca-client/tls-ca/admin/msp/keystore/$(sudo \
        ls \
        ${volume}/${orgname}/fabric-ca-client/tls-ca/admin/msp/keystore) \
        ${volume}/${orgname}/fabric-ca-server-org/tls/key.pem
    
    docker run --rm --name \
        fabric-ca-server-org-init.${orgname} \
        -v \
        ${PWD}/${volume}/${orgname}/fabric-ca-server-org:/root/fabric-ca-server-org \
        hyperledger/fabric-ca:1.4.9 \
        fabric-ca-server init -b \
        rcaadmin:rcaadminpw -H \
        /root/fabric-ca-server-org

    sudo chown -R $USER:$USER \
        ${volume}
        
    python3 ./edit_yaml.py org ${orgname} ${volume} ${domain}
    
    sudo rm \
        ${volume}/${orgname}/fabric-ca-server-org/ca-cert.pem
    sudo rm -rf \
        ${volume}/${orgname}/fabric-ca-server-org/msp
    
    docker run -d --rm -p 7055:7055 \
        --name \
        fabric-ca-server-org.${orgname} -v \
        ${PWD}/${volume}/${orgname}/fabric-ca-server-org:/root/fabric-ca-server-org \
        hyperledger/fabric-ca:1.4.9 \
        fabric-ca-server start -H \
        /root/fabric-ca-server-org
    sleep 3
}

Enroll_org () {
    sudo mkdir \
        ${volume}/${orgname}/fabric-ca-client/${orgname}-ca

    cp \
        ${volume}/${orgname}/fabric-ca-server-org/ca-cert.pem \
        ${volume}/${orgname}/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
    
    docker run --rm --name \
        fabric-ca-client.${orgname} --link \
        fabric-ca-server-org.${orgname}:fabric-ca-server-org.${orgname} \
        -v \
        ${PWD}/${volume}/${orgname}/fabric-ca-client:/root/fabric-ca-client \
        -e \
        FABRIC_CA_CLIENT_HOME=/root/fabric-ca-client \
        hyperledger/fabric-ca:1.4.9 \
        fabric-ca-client enroll -d -u \
        https://rcaadmin:rcaadminpw@${domain}:7055 \
        --tls.certfiles \
        tls-root-cert/tls-ca-cert.pem \
        --csr.hosts \
        ${domain}',host1,*.fabric-ca-server-org.'${orgname} \
        --mspdir ${orgname}-ca/rcaadmin/msp
}


Start_tls
Enroll_tls
Start_org
Enroll_org