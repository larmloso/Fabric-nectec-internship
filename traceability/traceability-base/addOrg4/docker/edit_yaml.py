import sys

def peer():
    import yaml
    path = "docker/docker-compose.yaml"

    with open(path) as f:
        y=yaml.safe_load(f)
        y['volumes'][f'{sys.argv[3]}'] = y['volumes']['peer0.org4.com']
        del y['volumes']['peer0.org4.com']

        y['services'][f'{sys.argv[3]}'] = y['services']['peer0.org4.com']
        del y['services']['peer0.org4.com']

        y['services'][f'{sys.argv[3]}']['container_name'] = f'{sys.argv[3]}'
        y['services'][f'{sys.argv[3]}']['environment'][8] = f'CORE_PEER_ID={sys.argv[3]}'
        y['services'][f'{sys.argv[3]}']['environment'][9] = f'CORE_PEER_ADDRESS={sys.argv[3]}:{sys.argv[4]}'
        y['services'][f'{sys.argv[3]}']['environment'][10] = f'CORE_PEER_LISTENADDRESS=0.0.0.0:{sys.argv[4]}'
        y['services'][f'{sys.argv[3]}']['environment'][11] = f'CORE_PEER_CHAINCODEADDRESS={sys.argv[3]}:{sys.argv[5]}'
        y['services'][f'{sys.argv[3]}']['environment'][12] = f'CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:{sys.argv[5]}'
        y['services'][f'{sys.argv[3]}']['environment'][13] = f'CORE_PEER_GOSSIP_BOOTSTRAP={sys.argv[3]}:{sys.argv[4]}'
        y['services'][f'{sys.argv[3]}']['environment'][14] = f'CORE_PEER_GOSSIP_EXTERNALENDPOINT={sys.argv[3]}:{sys.argv[4]}'

        y['services'][f'{sys.argv[3]}']['volumes'][1] = f'../{sys.argv[2]}/peerOrganizations/org4.example.com/peers/{sys.argv[3]}/msp:/etc/hyperledger/fabric/msp'
        y['services'][f'{sys.argv[3]}']['volumes'][2] = f'../{sys.argv[2]}/peerOrganizations/org4.example.com/peers/{sys.argv[3]}/tls:/etc/hyperledger/fabric/tls'
        y['services'][f'{sys.argv[3]}']['volumes'][3] = f'{sys.argv[3]}:/var/hyperledger/production'

        y['services'][f'{sys.argv[3]}']['ports'] = [f'{sys.argv[4]}:{sys.argv[4]}']

    with open(path, "w") as f:
        yaml.dump(y, f)
        
def couch():
    import yaml
    path = "docker/docker-compose-couch.yaml"

    with open(path) as f:
        y=yaml.safe_load(f)
        y['services'][f'peer0.{sys.argv[2]}'] = y['services']['peer0.org4.com']
        del y['services']['peer0.org4.com']

    with open(path, "w") as f:
        yaml.dump(y, f)


def configtx():
    import yaml
    path = "docker/configtx.yaml"

    with open(path) as f:
        y=yaml.safe_load(f)
        y['Organizations'][0]['Name'] = f'{sys.argv[3]}'
        y['Organizations'][0]['ID'] = f'{sys.argv[3]}'
        y['Organizations'][0]['MSPDir'] = f'../{sys.argv[2]}/peerOrganizations/org4.example.com/msp'
        y['Organizations'][0]['Policies']['Readers']['Rule'] = f"OR('{sys.argv[3]}.admin', '{sys.argv[3]}.peer', '{sys.argv[3]}.client')"
        y['Organizations'][0]['Policies']['Writers']['Rule'] = f"OR('{sys.argv[3]}.admin', '{sys.argv[3]}.client')"
        y['Organizations'][0]['Policies']['Admins']['Rule'] = f"OR('{sys.argv[3]}.admin')"
        y['Organizations'][0]['Policies']['Endorsement']['Rule'] = f"OR('{sys.argv[3]}.peer')"
        print(y['Organizations'][0])

    with open(path, "w") as f:
        yaml.dump(y, f)
        

if sys.argv[1] == 'peer':
    peer()

if sys.argv[1] == 'couch':
    couch()
    
if sys.argv[1] == 'configtx':
    configtx()