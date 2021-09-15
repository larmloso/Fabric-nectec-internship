import sys

def docker():
    import yaml
    path = "docker-compose.yaml"

    with open(path) as f:
        y=yaml.safe_load(f)
        y['services']['openldap']['ports'] = [ sys.argv[2] + ':389', '636:636' ]
        y['services']['openldap']['environment'][2] = f'LDAP_ADMIN_USERNAME={sys.argv[3]}'
        y['services']['openldap']['environment'][3] = f'LDAP_ADMIN_PASSWORD={sys.argv[4]}'

    with open(path, "w") as f:
        yaml.dump(y, f)

if sys.argv[1] == 'docker':
    docker()