cd ..
./run.sh deployCA --domain larmdev.cf --volume organizations --orgname fabric-ca --password adminpw

cd addOrg

ssh root@larmdev.cf "bash -s" -- <./register_peer.sh larmdev.cf organizations fabric-ca 7054

./updateChannel.sh --domain1 larmdev.ml --domain2 larmdev.ga --domain3 larmdev.cf --port1 7051 --port2 9051 --port3 11051


cd chaincode

./script.sh