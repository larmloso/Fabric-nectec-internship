
###
docker run --rm hyperledger/fabric-ca:1.4.9 fabric-ca-server --help

docker run --rm --name fabric-ca-server-tls-init.org1 \
-v ${PWD}/Organizations/org1/fabric-ca-server-tls:/root/fabric-ca-server-tls \
hyperledger/fabric-ca:1.4.9 \
fabric-ca-server init -b tls-admin:tls-adminpw \
-H /root/fabric-ca-server-tls



docker run --rm -p 7054:7054 --name fabric-ca-server-tls.org1 \
-v ${PWD}/Organizations/org1/fabric-ca-server-tls:/root/fabric-ca-server-tls \
hyperledger/fabric-ca:1.4.9 \
fabric-ca-server start -b tls-admin:tls-adminpw \
--csr.hosts fabric-ca-server-tls.org1 \
--tls.enabled \
--ldap.enabled \
--ldap.url ldap://cn=admin,dc=example,dc=com:admin_pass@larmdev.tech:389/ou=users,dc=example,dc=com \
--ldap.attribute.names "[converters: [value: attr('uid') =~ 'revoker*'" \
--ldap.userfilter uid=%s \
-H /root/fabric-ca-server-tls


docker run --rm --name fabric-ca-client.org1 \
--link fabric-ca-server-tls.org1:fabric-ca-server-tls.org1 \
-v ${PWD}/Organizations/org1/fabric-ca-client:/root/fabric-ca-client \
-e FABRIC_CA_CLIENT_HOME=/root/fabric-ca-client \
hyperledger/fabric-ca:1.4.9 fabric-ca-client \
enroll -d -u https://admin:pass@fabric-ca-server-tls.org1:7054 \
--tls.certfiles tls-root-cert/tls-ca-cert.pem \
--enrollment.profile tls --csr.hosts 'host1,fabric-ca-server-tls.org1' \
--mspdir tls-ca/tlsadmin1/msp

docker run --rm --name fabric-ca-client.org1 \
--link fabric-ca-server-tls.org1:fabric-ca-server-tls.org1 \
-v ${PWD}/Organizations/org1/fabric-ca-client:/root/fabric-ca-client \
-e FABRIC_CA_CLIENT_HOME=/root/fabric-ca-client \
hyperledger/fabric-ca:1.4.9 fabric-ca-client \
enroll -d -u https://admin:pass@fabric-ca-server-tls.org1:7054 \
--tls.certfiles tls-root-cert/tls-ca-cert.pem \
--enrollment.profile tls \
--csr.hosts 'host1,fabric-ca-server-tls.org1' \
--mspdir tls-ca/tlsadmin1/msp

