# วิธีการใช้งาน
1.สามารถเช็ค Flags ด้วยการ run:
```** PaworShell 
./run.sh --help
```
หรือ
```** PaworShell 
./run.sh -h
```

2.Form an Overlay Network with Docker Swarm
```** PaworShell 
./run.sh swarm --ipaddress1 167.172.72.168 --domain1 larmdev.ml --domain2 larmdev.ga
```

3.Deploy CA ใน Server1 และ Server2
```** PaworShell 
./run.sh deployCA --domain larmdev.ml --volume organizations --orgname fabric-ca --password adminpw

./run.sh deployCA --domain larmdev.ga --volume organizations --orgname fabric-ca --password adminpw
```

4.RegisterOrderer และ RegisterPeer

4.1 RegisterOrderer ใน Server1
```** PaworShell 
./run.sh registerOrderer --domain larmdev.ml --volume organizations --orgname fabric-ca --admport 7054
```

4.2 RegisterPeer ใน Server2
```** PaworShell 
./run.sh registerPeer --domain larmdev.ga --volume organizations --orgname fabric-ca --admport 7054
```

5.Deploy Orderer raft 3 node และ Peer ใน Server1
```** PaworShell 
./run.sh deployRaft3Node --domain1 larmdev.ml --domain2 larmdev.ga --volume organizations --peerport1 7051 --peerport2 9051 --port1 7050 --port2 8050 --port3 9050 --admport1 7053 --admport2 8053 --admport3 9053
```

6.Deploy Peer ใน Server2
```** PaworShell 
./run.sh deployPeer --domain larmdev.ga --volume organizations --peerport 9051 --cport 9052
```

7.Deploy Chaincode

7.1 run script
```** PaworShell 
cd chaincode
dos2unix *
./script.sh larmdev.ml larmdev.ga 3500 fabric-ca fabric-ca
```

