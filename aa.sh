pk=Package ID: basic_1.0:82fafd614819fac6bab54b05a45456afc028f29c387cf0e5e73487241edea205, Label: basic_1.0'
peer lifecycle chaincode queryapproved -C mychannel -n basic | sed '1d' | cut -d' ' -f8 | cut -d',' -f1
