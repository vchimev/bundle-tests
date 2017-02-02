#!/bin/sh
export NVM_REPO="https://github.com/creationix/nvm.git"
export NVM_NODEJS_ORG_MIRROR="https://nodejs.org/dist"
export NVM_DIR="${PROJECT_DIR:-$(pwd)}/.nvm"
export NODE_VER="v6.9.5"
export APPIUM_VER="1.6.3"
export TNS_VER="2.5.0"

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

tns_version_matches() {
    tns --version | grep -qi "$TNS_VER"
}

node_not_installed() {
    nvm use $NODE_VER 2>&1 | grep -vqi "now using"
}

install_node() {
    if node_not_installed ; then
        echo "Installing node.js: $NODE_VER"
        nvm install $NODE_VER
        nvm use $NODE_VER
    fi
}

ensure_tns() {
    if installed_under_nvm tns ; then
        if ! tns_version_matches ; then
            echo "Previous tns version detected. Uninstalling..."
            npm uninstall -g nativescript
            install_tns
        else
            echo "tns@$TNS_VER already installed."
        fi
    else
        install_tns
    fi
}

install_tns() {
    echo "Installing tns $TNS_VER..."
    npm install -g "nativescript@$TNS_VER" --ignore-scripts
    tns usage-reporting disable
    tns error-reporting disable
}

ensure_appium() {
    REAL_APPIUM_VER="$(appium --version)"
    if [ "$REAL_APPIUM_VER" == "$APPIUM_VER" ] ; then
        echo "appium@$REAL_APPIUM_VER already installed."
    else
        echo "Installing appium@$APPIUM_VER..."
        npm install -g "appium@$APPIUM_VER"
    fi
}

activate_node_env() {
    activate_nvm
    install_node
    ensure_tns
    ensure_appium
}
