
### 
# วิธีการใช้งาน
###
1.join docker swarm

```
./joindocker.sh [domain server1] [domain server 3]
```
###
2.Deploy CA ใน Server 3
```
cd..
```
```
./run.sh deployCA --domain larmdev.cf --volume organizations --orgname fabric-ca --password adminpw
```

3.RegisterPeer
```
cd addOrg
```
```
ssh root@larmdev.cf "bash -s" -- <./register_peer.sh larmdev.cf organizations fabric-ca 7054
```

4.Update Channel && deploy chaincode
```
./updateChannel.sh --domain1 larmdev.ml --domain2 larmdev.ga --domain3 larmdev.cf --port1 7051 --port2 9051 --port3 11051
```
