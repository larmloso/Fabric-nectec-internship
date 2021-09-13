#!/bin/bash

function installDocker() {

    echo "install docker..."
    ## downloads docker engin
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    ## chmod
    sudo chmod +x /usr/local/bin/docker-compose

    ## install docker-compose
    apt install docker-compose -y

    echo "install docker success"
}

## install nvm
function installNVM() {

    echo "install nvm..."

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

    source ~/.bashrc

    sleep 2
    
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

    echo "install node v.14.17.3"
    nvm install 14.17.3

    echo "install nvm success"

}

function installJQ() {

    echo "install jq..."

    sudo apt install jq -y

    echo "install jq success"
}



sudo apt update -y

sudo apt install dos2unix -y

installDocker
sleep 1

installNVM
sleep 1

installJQ
