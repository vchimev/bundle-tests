#!/bin/sh
export NVM_REPO="https://github.com/creationix/nvm.git"
export NVM_NODEJS_ORG_MIRROR="https://nodejs.org/dist"
export NVM_DIR="${PROJECT_DIR:-$(pwd)}/.nvm"
export NODE_VER="v6.9.1"

activate_nvm() {
    if [ ! -d "$NVM_DIR" ] ; then
        git clone --depth=1 $NVM_REPO "$NVM_DIR"
    else
        echo "NVM detected at $NVM_DIR"
    fi

    . "$NVM_DIR/nvm.sh"
}

installed_under_nvm() {
    which "$1" | grep -q "$NVM_DIR"
}

install_node() {
    if ! nvm use $NODE_VER > /dev/null 2>&1 ; then
        echo "Installing node.js: $NODE_VER"
        nvm install $NODE_VER
        nvm use $NODE_VER
    fi
}

install_latest_tns() {
    if installed_under_nvm tns ; then
        echo "tns already installed."
    else
        echo "Installing tns"
        npm install -g nativescript --ignore-scripts
        tns usage-reporting disable
        tns error-reporting disable
    fi
}

activate_node_env() {
    activate_nvm
    install_node
    install_latest_tns
}
