cd ..
./run.sh deployCA --domain larmdev.tech --volume organizations --orgname fabric-ca --password adminpw

cd addOrg4

ssh root@larmdev.tech "bash -s" -- <./register_peer.sh larmdev.tech organizations fabric-ca 7054

./updateChannel.sh --domain1 larmdev.ml --domain2 larmdev.ga --domain3 larmdev.tech --port1 7051 --port2 9051 --port3 12051


# cd chaincode

# ./script.sh