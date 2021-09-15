port=$1
admin=$2
adminpw=$3

function up() {
    python3 ./edit_port.py docker ${port} ${admin} ${adminpw}
    docker-compose up -d
}
up
