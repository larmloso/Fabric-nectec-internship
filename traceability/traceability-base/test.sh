
./run.sh deployCA --domain larmdev.ml --volume organizations --orgname fabric-ca --password adminpw
sleep 1
./run.sh deployCA --domain larmdev.ga --volume organizations --orgname fabric-ca --password adminpw
sleep 1
./run.sh registerOrderer --domain larmdev.ml --volume organizations --orgname fabric-ca --admport 7054
sleep 1
./run.sh registerPeer --domain larmdev.ga --volume organizations --orgname fabric-ca --admport 7054
sleep 1
./run.sh deployRaft3Node --domain1 larmdev.ml --domain2 larmdev.ga --volume organizations --peerport1 7051 --peerport2 9051 --port1 7050 --port2 8050 --port3 9050 --admport1 7053 --admport2 8053 --admport3 9053
sleep 1
./run.sh deployPeer --domain larmdev.ga --volume organizations --peerport 9051 --cport 9052
sleep 1


cd chaincode
dos2unix *
./script.sh larmdev.ml larmdev.ga 3500 fabric-ca fabric-ca
