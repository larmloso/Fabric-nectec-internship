
#!/bin/bash
function down(){
    docker kill $(docker ps -q)
    docker rm -f $(docker ps -a -q)
    docker rm -f $(docker ps -aq)
    docker volume rm $(docker volume ls -q)

    sudo rm -rf data
    # rm -rf docker-compose.yaml
    # rm -rf edit_port.py
}   
down