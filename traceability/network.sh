#!/bin/bash

## import utiles.sh
. scripts/utils.sh


## 

## export var .env file
function exportENV() {

    infoln "ENV MODE ..."

    ## file name dir
    ENVFILE=$(echo $CONFIG_FILE_ENV | cut -d"." -f2-)

    ## file name
    ENVNAME=$(echo $CONFIG_FILE_ENV | cut -d"." -f3-)

    ## check file .env
    if [[ -f .$ENVFILE ]]; then

        infoln "export ${ENVNAME} ..."

        if [ -d $ENVFILE ]; then
            echo "hello"
        else
            set -o allexport
            [[ -f .$ENVFILE ]] && source .$ENVFILE
            set +o allexport
        fi

    else
        errorln "not found $ENVNAME"
        exit 1
    fi
    echo $ORG1

}

## register $$ enroll 
function register() {
    infoln "Creating Org Identities"
}



## Parse mode
if [[ $# -lt 1 ]]; then
    printHelp
    exit 0
else
    MODE=$1
    shift
fi

# parse flags
while [[ $# -ge 1 ]]; do
    key="$1"
    case $key in
    --config=*)
        CONFIG_FILE_ENV="$1"
        shift
        ;;
    *)
        exit 1
        ;;
    esac
    shift
done

if [ "${MODE}" == "env" ]; then
    exportENV
elif [ "${MODE}" == "register" ]; then
    register
elif [ "${MODE}" == "addOrg" ]; then
    addOrg
else
    printHelp
    exit 1
fi
