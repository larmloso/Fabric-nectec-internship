#!/bin/bash


# domain=larmdev.ml
# volume=organizations
# orgname=fabric-ca
# admport=7054

# username=orderer1
# password=pass

## enroll ca admin
##ssh root@larmdev.ml "bash -s" -- <./enroll.sh enrollCAadmin $domain $volume $orgname $admport $username $password

# ## enroll orderer node
# ssh root@larmdev.ml "bash -s" -- <./enroll.sh enrollIdenity $domain $volume $orgname $admport $username $password
# ssh root@larmdev.ml "bash -s" -- <./enroll.sh enrollIdenity $domain $volume $orgname $admport $username $password
# ssh root@larmdev.ml "bash -s" -- <./enroll.sh enrollIdenity $domain $volume $orgname $admport $username $password

# ## enroll orderer admin
# ssh root@larmdev.ml "bash -s" -- <./enroll.sh enrollCAadmin $domain $volume $orgname $admport $username $password


ssh root@larmdev.ml "bash -s" -- <./enrollOrdererUser.sh enrollCAadmin larmdev.ml organizations fabric-ca 7054 admin pass

ssh root@larmdev.ml "bash -s" -- <./enrollOrdererUser.sh enrollIdentities larmdev.ml organizations fabric-ca 7054 orderer1 pass
ssh root@larmdev.ml "bash -s" -- <./enrollOrdererUser.sh enrollIdentities larmdev.ml organizations fabric-ca 7054 orderer2 pass
ssh root@larmdev.ml "bash -s" -- <./enrollOrdererUser.sh enrollIdentities larmdev.ml organizations fabric-ca 7054 orderer3 pass

ssh root@larmdev.ml "bash -s" -- <./enrollOrdererUser.sh enrollCAadmin larmdev.ml organizations fabric-ca 7054 ordererAdmin pass


ssh root@larmdev.ml "bash -s" -- <./enrollUser.sh enrollCAadmin larmdev.ml organizations fabric-ca 7054 admin pass
ssh root@larmdev.ml "bash -s" -- <./enrollUser.sh enrollPeer larmdev.ml organizations fabric-ca 7054 peer0 pass
ssh root@larmdev.ml "bash -s" -- <./enrollUser.sh enrollOrgUser larmdev.ml organizations fabric-ca 7054 user1 pass
ssh root@larmdev.ml "bash -s" -- <./enrollUser.sh enrollOrgAdmin larmdev.ml organizations fabric-ca 7054 org1admin pass