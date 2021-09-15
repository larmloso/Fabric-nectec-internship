DOMAINS=$1
PORTLDAP=$2
PORT=$3

function install(){
    echo "Install npm api"
    cd src
    echo "Install GUI redis"
    # npm install -g redis-commander

    echo "npm Install"
    # npm install

    echo "Docker pull redis"
    docker pull redis

    echo "run docker redis"
    docker run -d --name redis -p 6379:6379 redis

    echo "run server"
    docker build -t ldapapi .
    docker run -d -p ${PORT}:${PORT} --name LDAP_API -t ldapapi
    # echo "run redis-commander GUI"
    # nohup redis-commander

}
install