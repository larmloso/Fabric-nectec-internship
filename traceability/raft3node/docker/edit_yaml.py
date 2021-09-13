import sys

def configtx():
    import yaml
    path = 'docker/configtx.yaml'
    with open(path) as f:
        y=yaml.safe_load(f)
        # print(y['Organizations'][1])
        y['Organizations'][0]['MSPDir'] = f'../{sys.argv[2]}/ordererOrganizations/example.com/msp'
        y['Organizations'][0]['OrdererEndpoints'] = [f'orderer1.{sys.argv[8]}:{sys.argv[3]}', f'orderer2.{sys.argv[8]}:{sys.argv[4]}', f'orderer3.{sys.argv[8]}:{sys.argv[5]}']
        
        y['Organizations'][1]['MSPDir'] = f'../{sys.argv[2]}/peerOrganizations/org1.example.com/msp'
        y['Organizations'][1]['AnchorPeers'] = [{'Host': f'peer0.{sys.argv[8]}', 'Port': sys.argv[6]}]

        y['Organizations'][2]['MSPDir'] = f'../{sys.argv[2]}/peerOrganizations/org2.example.com/msp'
        y['Organizations'][2]['AnchorPeers'] = [{'Host': f'peer0.{sys.argv[9]}', 'Port':  sys.argv[7]}]

        y['Orderer']['Addresses'] = [f'orderer1.{sys.argv[8]}:{sys.argv[3]}', f'orderer2.{sys.argv[8]}:{sys.argv[4]}', f'orderer3.{sys.argv[8]}:{sys.argv[5]}']

        y['Orderer']['EtcdRaft']['Consenters'][0]['Host'] =f'orderer1.{sys.argv[8]}'
        y['Orderer']['EtcdRaft']['Consenters'][0]['Port'] = sys.argv[3]
        y['Orderer']['EtcdRaft']['Consenters'][0]['ClientTLSCert'] = f'../{sys.argv[2]}/ordererOrganizations/example.com/orderers/orderer1.{sys.argv[8]}/tls/server.crt'
        y['Orderer']['EtcdRaft']['Consenters'][0]['ServerTLSCert'] = f'../{sys.argv[2]}/ordererOrganizations/example.com/orderers/orderer1.{sys.argv[8]}/tls/server.crt'

        y['Orderer']['EtcdRaft']['Consenters'][1]['Host'] =f'orderer2.{sys.argv[8]}'
        y['Orderer']['EtcdRaft']['Consenters'][1]['Port'] = sys.argv[4]
        y['Orderer']['EtcdRaft']['Consenters'][1]['ClientTLSCert'] = f'../{sys.argv[2]}/ordererOrganizations/example.com/orderers/orderer2.{sys.argv[8]}/tls/server.crt'
        y['Orderer']['EtcdRaft']['Consenters'][1]['ServerTLSCert'] = f'../{sys.argv[2]}/ordererOrganizations/example.com/orderers/orderer2.{sys.argv[8]}/tls/server.crt'

        y['Orderer']['EtcdRaft']['Consenters'][2]['Host'] =f'orderer3.{sys.argv[8]}'
        y['Orderer']['EtcdRaft']['Consenters'][2]['Port'] = sys.argv[5]
        y['Orderer']['EtcdRaft']['Consenters'][2]['ClientTLSCert'] = f'../{sys.argv[2]}/ordererOrganizations/example.com/orderers/orderer3.{sys.argv[8]}/tls/server.crt'
        y['Orderer']['EtcdRaft']['Consenters'][2]['ServerTLSCert'] = f'../{sys.argv[2]}/ordererOrganizations/example.com/orderers/orderer3.{sys.argv[8]}/tls/server.crt'

    with open(path, "w") as f:
        yaml.dump(y, f)
    
    with open(path) as f:
        y=yaml.safe_load(f)
        y['Profiles']['TwoOrgsApplicationGenesis']['Orderer']['Addresses'] = [f'orderer1.{sys.argv[8]}:{sys.argv[3]}', f'orderer2.{sys.argv[8]}:{sys.argv[4]}', f'orderer3.{sys.argv[8]}:{sys.argv[5]}']

    with open(path, "w") as f:
        yaml.dump(y, f)

def orderer():
    import yaml
    path = "docker/docker-compose.yaml"

    with open(path) as f:
        y=yaml.safe_load(f)
        y['volumes'][f'orderer1.{sys.argv[9]}'] = y['volumes']['orderer1.com']
        del y['volumes']['orderer1.com']
        y['volumes'][f'orderer2.{sys.argv[9]}'] = y['volumes']['orderer2.com']
        del y['volumes']['orderer2.com']
        y['volumes'][f'orderer3.{sys.argv[9]}'] = y['volumes']['orderer3.com']
        del y['volumes']['orderer3.com']

        y['services'][f'orderer1.{sys.argv[9]}'] = y['services']['orderer1.com']
        del y['services']['orderer1.com']
        y['services'][f'orderer2.{sys.argv[9]}'] = y['services']['orderer2.com']
        del y['services']['orderer2.com']
        y['services'][f'orderer3.{sys.argv[9]}'] = y['services']['orderer3.com']
        del y['services']['orderer3.com']
        y['services'][f'orderer1.{sys.argv[9]}']['container_name'] = f'orderer1.{sys.argv[9]}'
        y['services'][f'orderer1.{sys.argv[9]}']['environment'][2] = f'ORDERER_GENERAL_LISTENPORT={sys.argv[3]}'
        y['services'][f'orderer1.{sys.argv[9]}']['environment'][21] = f'ORDERER_ADMIN_LISTENADDRESS=0.0.0.0:{sys.argv[6]}'

        y['services'][f'orderer1.{sys.argv[9]}']['volumes'][1] = f'../{sys.argv[2]}/ordererOrganizations/example.com/orderers/orderer1.{sys.argv[9]}/msp:/var/hyperledger/orderer/msp'
        y['services'][f'orderer1.{sys.argv[9]}']['volumes'][2] = f'../{sys.argv[2]}/ordererOrganizations/example.com/orderers/orderer1.{sys.argv[9]}/tls/:/var/hyperledger/orderer/tls'
        y['services'][f'orderer1.{sys.argv[9]}']['volumes'][3] = f'orderer1.{sys.argv[9]}:/var/hyperledger/production/orderer'

        y['services'][f'orderer1.{sys.argv[9]}']['ports'] = [f'{sys.argv[3]}:{sys.argv[3]}', f'{sys.argv[6]}:{sys.argv[6]}']

        y['services'][f'orderer2.{sys.argv[9]}']['container_name'] = f'orderer2.{sys.argv[9]}'
        y['services'][f'orderer2.{sys.argv[9]}']['environment'][2] = f'ORDERER_GENERAL_LISTENPORT={sys.argv[4]}'
        y['services'][f'orderer2.{sys.argv[9]}']['environment'][21] = f'ORDERER_ADMIN_LISTENADDRESS=0.0.0.0:{sys.argv[7]}'

        y['services'][f'orderer2.{sys.argv[9]}']['volumes'][1] = f'../{sys.argv[2]}/ordererOrganizations/example.com/orderers/orderer2.{sys.argv[9]}/msp:/var/hyperledger/orderer/msp'
        y['services'][f'orderer2.{sys.argv[9]}']['volumes'][2] = f'../{sys.argv[2]}/ordererOrganizations/example.com/orderers/orderer2.{sys.argv[9]}/tls/:/var/hyperledger/orderer/tls'
        y['services'][f'orderer2.{sys.argv[9]}']['volumes'][3] = f'orderer2.{sys.argv[9]}:/var/hyperledger/production/orderer'

        y['services'][f'orderer2.{sys.argv[9]}']['ports'] = [f'{sys.argv[4]}:{sys.argv[4]}', f'{sys.argv[7]}:{sys.argv[7]}']

        y['services'][f'orderer3.{sys.argv[9]}']['container_name'] = f'orderer3.{sys.argv[9]}'
        y['services'][f'orderer3.{sys.argv[9]}']['environment'][2] = f'ORDERER_GENERAL_LISTENPORT={sys.argv[5]}'
        y['services'][f'orderer3.{sys.argv[9]}']['environment'][21] = f'ORDERER_ADMIN_LISTENADDRESS=0.0.0.0:{sys.argv[8]}'

        y['services'][f'orderer3.{sys.argv[9]}']['volumes'][1] = f'../{sys.argv[2]}/ordererOrganizations/example.com/orderers/orderer3.{sys.argv[9]}/msp:/var/hyperledger/orderer/msp'
        y['services'][f'orderer3.{sys.argv[9]}']['volumes'][2] = f'../{sys.argv[2]}/ordererOrganizations/example.com/orderers/orderer3.{sys.argv[9]}/tls/:/var/hyperledger/orderer/tls'
        y['services'][f'orderer3.{sys.argv[9]}']['volumes'][3] = f'orderer3.{sys.argv[9]}:/var/hyperledger/production/orderer'

        y['services'][f'orderer3.{sys.argv[9]}']['ports'] = [f'{sys.argv[5]}:{sys.argv[5]}', f'{sys.argv[8]}:{sys.argv[8]}']

    with open(path, "w") as f:
        yaml.dump(y, f)

def peer():
    import yaml
    path = "docker/docker-compose.yaml"

    with open(path) as f:
        y=yaml.safe_load(f)
        y['volumes'][f'{sys.argv[3]}'] = y['volumes']['peer0.org1.com']
        del y['volumes']['peer0.org1.com']

        y['services'][f'{sys.argv[3]}'] = y['services']['peer0.org1.com']
        del y['services']['peer0.org1.com']
        
        y['services'][f'{sys.argv[3]}']['container_name'] = f'{sys.argv[3]}'
        y['services'][f'{sys.argv[3]}']['environment'][8] = f'CORE_PEER_ID={sys.argv[3]}'
        y['services'][f'{sys.argv[3]}']['environment'][9] = f'CORE_PEER_ADDRESS={sys.argv[3]}:{sys.argv[4]}'
        y['services'][f'{sys.argv[3]}']['environment'][10] = f'CORE_PEER_LISTENADDRESS=0.0.0.0:{sys.argv[4]}'
        y['services'][f'{sys.argv[3]}']['environment'][11] = f'CORE_PEER_CHAINCODEADDRESS={sys.argv[3]}:{sys.argv[5]}'
        y['services'][f'{sys.argv[3]}']['environment'][12] = f'CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:{sys.argv[5]}'
        y['services'][f'{sys.argv[3]}']['environment'][13] = f'CORE_PEER_GOSSIP_BOOTSTRAP={sys.argv[3]}:{sys.argv[4]}'
        y['services'][f'{sys.argv[3]}']['environment'][14] = f'CORE_PEER_GOSSIP_EXTERNALENDPOINT={sys.argv[3]}:{sys.argv[4]}'

        y['services'][f'{sys.argv[3]}']['volumes'][1] = f'../{sys.argv[2]}/peerOrganizations/org1.example.com/peers/{sys.argv[3]}/msp:/etc/hyperledger/fabric/msp'
        y['services'][f'{sys.argv[3]}']['volumes'][2] = f'../{sys.argv[2]}/peerOrganizations/org1.example.com/peers/{sys.argv[3]}/tls:/etc/hyperledger/fabric/tls'
        y['services'][f'{sys.argv[3]}']['volumes'][3] = f'{sys.argv[3]}:/var/hyperledger/production'

        y['services'][f'{sys.argv[3]}']['ports'] = [f'{sys.argv[4]}:{sys.argv[4]}']

    with open(path, "w") as f:
        yaml.dump(y, f)

def couch():
    import yaml
    path = "docker/docker-compose-couch.yaml"

    with open(path) as f:
        y=yaml.safe_load(f)
        y['services'][f'peer0.{sys.argv[2]}'] = y['services']['peer0.org1.com']
        del y['services']['peer0.org1.com']

    with open(path, "w") as f:
        yaml.dump(y, f)

if sys.argv[1] == 'orderer':
    orderer()
if sys.argv[1] == 'peer':
    peer()
if sys.argv[1] == 'configtx':
    configtx()
if sys.argv[1] == 'couch':
    couch()