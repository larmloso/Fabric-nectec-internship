import sys

def tls():
    import yaml
    path = sys.argv[3] + "/" + sys.argv[2] + "/fabric-ca-server-tls/fabric-ca-server-config.yaml"

    with open(path) as f:
        y=yaml.safe_load(f)
        y['tls']['enabled'] = True
        y['ca']['name'] = sys.argv[2] + '-tls'
        y['csr']['hosts'].append('fabric-ca-server-tls.' + sys.argv[2])
        y['csr']['hosts'].append(sys.argv[4])
        del y['signing']['profiles']['ca']

    with open(path, "w") as f:
        yaml.dump(y, f)

def org():
    import yaml
    path2 = sys.argv[3] + "/" + sys.argv[2] + "/fabric-ca-server-org/fabric-ca-server-config.yaml"
    with open(path2) as f:
        y=yaml.safe_load(f)
        y['port'] = '7055'
        y['tls']['enabled'] = True
        y['ca']['name'] = sys.argv[2] + '-org'
        y['csr']['hosts'].append('fabric-ca-server-org.' + sys.argv[2])
        y['csr']['hosts'].append(sys.argv[4])
        y['operations']['listenAddress'] = '127.0.0.1:9445'
        
    with open(path2, "w") as f:
        yaml.dump(y, f)

if sys.argv[1] == 'tls':
    tls()
if sys.argv[1] == 'org':
    org()
